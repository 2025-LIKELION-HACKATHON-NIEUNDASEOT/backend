import requests
import re
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
import time
import xml.etree.ElementTree as ET
from django.conf import settings
from document.models import Document
from user.models import Category, User
from datetime import datetime
import logging
from django.utils import timezone
import json

# Selenium 라이브러리
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


# 로깅 설정
logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')


# 문서 API 관련 함수

def get_default_guest_user():
    try:
        return User.objects.get(user_id='GUEST1')
    except User.DoesNotExist:
        return None

def get_openapi_key_for_user(user):
    if user is None or not getattr(user, 'is_authenticated', False):
        user = get_default_guest_user()
        if user is None:
            return settings.DOBONG_OPENAPI_KEY
    
    region = None
    if hasattr(user, 'profile'):
        region = getattr(user.profile, 'region', None)
        if isinstance(region, dict):
            city = region.get('city')
            district = region.get('district')
            if city == '경기도':
                return settings.GYEONGGI_OPENAPI_KEY
            elif district == '종로구':
                return settings.JONGNO_OPENAPI_KEY
    return settings.DOBONG_OPENAPI_KEY

def fetch_notices_for_user(user, start_index=1, end_index=5):
    key = get_openapi_key_for_user(user)
    api_name = 'DobongNewsNoticeList'
    
    if hasattr(user, 'profile'):
        region = getattr(user.profile, 'region', None)
        if region:
            if region.get('city') == '경기도':
                api_name = 'GyeonggiNewsNoticeList'
            elif region.get('city') == '서울특별시' and region.get('district') == '도봉구':
                api_name = 'DobongNewsNoticeList'
            elif region.get('city') == '서울특별시' and region.get('district') == '종로구':
                api_name = 'JongnoNewsNoticeList'
    
    url = f"http://openapi.seoul.go.kr:8088/{key}/xml/{api_name}/{start_index}/{end_index}/"
    logger.info(f"API 요청 URL: {url}")
    response = requests.get(url)
    logger.info(f"사용 중인 키: {key}")
    response.raise_for_status()
    return response.text

def parse_notices(xml_str):
    root = ET.fromstring(xml_str)
    notices = []
    for row in root.findall('row'):
        notice = {
            'id': row.findtext('ID'),
            'title': row.findtext('TITLE'),
            'link': row.findtext('LINK'),
            'pubdate': row.findtext('PUBDATE'),
            'department': row.findtext('DEPARTMENT'),
            'manager': row.findtext('MANAGER'),
            'description': row.findtext('DESCRIPTION'),
        }
        notices.append(notice)
    return notices

def classify_doc_type(title, content):
    category_mapping = {
        '문화': ['문화', '예술', '공연', '전시', '축제', '영화', '음악', '행사'],
        '주택': ['주택', '부동산', '아파트', '주거', '임대', '전세', '매매', '재개발', '재건축'],
        '경제': ['경제', '상권', '소상공인', '창업', '일자리', '고용', '세금', '금융', '투자'],
        '환경': ['환경', '재활용', '쓰레기', '청소', '녹지', '공해', '기후', '온실가스'],
        '안전': ['안전', '방범', '방재', '소방', '구조', '경보', '교통사고', '재난', '응급'],
        '복지': ['복지', '지원', '혜택', '돌봄', '보조', '급여', '장애인', '노인', '아동'],
        '행정': ['행정', '민원', '허가', '신청', '접수', '발급', '제도', '정책', '조례']
    }
    type_mapping = {
        'PARTICIPATION': ['신청', '모집', '참여', '접수', '등록', '지원'],
        'NOTICE': ['안내', '공지', '알림', '유의사항'],
        'REPORT': ['보고', '신고', '제출', '통보'],
        'ANNOUNCEMENT': ['발표', '결과', '선정', '명단', '공지']
    }
    combined_text = f"{title} {content}"
    matched_categories = [cat for cat, keywords in category_mapping.items()
                          if any(keyword in combined_text for keyword in keywords)]
    type_result = None
    for t, keywords in type_mapping.items():
        if any(keyword in combined_text for keyword in keywords):
            type_result = t
            break
    return {
        "category": matched_categories if matched_categories else None,
        "type": type_result
    }

def save_notices_to_db(notices, user):
    region = None
    if hasattr(user, 'profile'):
        region = getattr(user.profile, 'region', None)
        if isinstance(region, dict):
            region_name = region.get('district', region.get('city', '')).lower()
        elif isinstance(region, str):
            region_name = region.lower()
        else:
            region_name = 'dobong'
    else:
        region_name = 'dobong'

    region_map = {
        'dobong': 6,
        '종로구': 24,

        '경기도': 7,
        'ggyeongi': 7,
        'gyeonggi': 7,
    }
    region_id = region_map.get(region_name, 2)

    for notice in notices:
        try:
            logger.info(f"저장 시도: {notice['title']}")
            result = classify_doc_type(notice['title'], notice.get('description', ''))
            pub_date_str = notice.get('pubdate')
            if pub_date_str:
                pub_date = datetime.strptime(pub_date_str, '%Y-%m-%d %H:%M:%S')
            else:
                pub_date = timezone.now()

            doc = Document.objects.create(
                doc_title=notice['title'],
                doc_content=notice.get('description', ''),
                doc_type=result['type'],
                pub_date=pub_date,
                region_id=region_id,
                link_url=notice.get('link'), # 원본 링크 추가
                image_url=fetch_first_image_enhanced(notice.get('link'))
            )
            logger.info(f"저장 완료: {doc.id}")

            if result['category']:
                categories_objs = Category.objects.filter(category_name__in=result['category'])
                doc.categories.add(*categories_objs)

        except Exception as e:
            logger.error(f"저장 실패: {notice['title']}, {e}")

def update_user_documents(user, start=1, end=5):
    logger.info(f"update_user_documents 시작: user={user}")
    xml_data = fetch_notices_for_user(user, start, end)
    logger.info(f"fetch_notices_for_user 결과(원본 XML):\n{xml_data[:500]}")
    notices = parse_notices(xml_data)
    logger.info(f"파싱된 공지 개수: {len(notices)}")
    if len(notices) == 0:
        logger.info("공지사항 데이터가 없습니다.")
    else:
        save_notices_to_db(notices, user)
    logger.info("update_user_documents 종료")
    
# 이미지 추출 관련 함수 -최종

def get_viewer_url_from_download_link(html_content):
    # 다운로드 링크에서 뷰어 URL 추출
    logger.info(f"[get_viewer_url_from_download_link] 다운로드 링크에서 뷰어 URL 추출 시작")
    soup = BeautifulSoup(html_content, "html.parser")
    
    download_link = soup.find('a', href=re.compile(r'/WDB_common/include/download\.asp'))
    if download_link:
        href = download_link.get('href')
        fcode_match = re.search(r'fcode=(\d+)', href)
        bcode_match = re.search(r'bcode=(\d+)', href)
        
        if fcode_match and bcode_match:
            fcode = fcode_match.group(1)
            bcode = bcode_match.group(1)
            viewer_url = f"https://viewer.dobong.go.kr/skin/doc.html?fn={fcode}&rs=/WEB_FILE/bbs/bcode{bcode}/docView"
            logger.info(f"[get_viewer_url_from_download_link] 생성된 뷰어 URL: {viewer_url}")
            return viewer_url
    
    logger.warning(f"[get_viewer_url_from_download_link] 다운로드 링크를 찾지 못함")
    return None

def extract_bbsdocview_params(html_content):
    # bbs_docview 자바스크립트 파라미터에서 뷰어 URL 추출
    logger.info(f"[extract_bbsdocview_params] bbsDocview 파라미터 추출 시작")
    
    patterns = [
        r"javascript:bbsDocview\('([^']+)','([^']+)','([^']+)'\)",
        r"javascript:bbs_docview\('([^']+)','([^']+)','([^']+)'\)"
    ]
    
    viewer_urls = []
    
    for pattern in patterns:
        matches = re.findall(pattern, html_content)
        for match in matches:
            bcode, seq, fcode = match
            viewer_url = f"https://viewer.dobong.go.kr/skin/doc.html?fn={fcode}&rs=/WEB_FILE/bbs/bcode{bcode}/docView"
            if viewer_url not in viewer_urls:
                viewer_urls.append(viewer_url)
                logger.debug(f"[extract_bbsdocview_params] 패턴에서 뷰어 URL 발견: {viewer_url}")
    
    logger.info(f"[extract_bbsdocview_params] 총 {len(viewer_urls)}개의 고유 뷰어 URL 발견")
    return viewer_urls

def try_direct_image_from_params(fcode, bcode):
    logger.info(f"[try_direct_image_from_params] 직접 이미지 경로 시도 - fcode: {fcode}, bcode: {bcode}")

    base_url = "https://www.dobong.go.kr"
    viewer_base_url = "https://viewer.dobong.go.kr"

    paths = [
        f"/WEB_FILE/bbs/bcode{bcode}/docView/{fcode}.jpg",
        f"/WEB_FILE/bbs/bcode{bcode}/docView/{fcode}_1.jpg",
        f"/WEB_FILE/bbs/bcode{bcode}/docView/page_1.jpg",
        f"/WEB_FILE/bbs/bcode{bcode}/docView/page_001.jpg",
        f"/WEB_FILE/bbs/bcode{bcode}/docView/{fcode}", # 확장자 없는 경우
        f"/WEB_FILE/bbs/bcode{bcode}/{fcode}",
        f"/files/bbs/bcode{bcode}/{fcode}",
    ]

    for path in paths:
        for base in [base_url, viewer_base_url]:
            full_url = urljoin(base, path)
            logger.debug(f"[try_direct_image_from_params] 경로 시도: {full_url}")

            try:
                # GET 요청으로 실제 파일 콘텐츠의 일부를 확인
                response = requests.get(full_url, timeout=5, headers={'User-Agent': 'Mozilla/5.0'}, stream=True)
                if response.status_code == 200:
                    content_type = response.headers.get('content-type', '').lower()
                    
                    # 1. Content-Type으로 이미지 여부 판단
                    if 'image' in content_type:
                        logger.info(f"[try_direct_image_from_params] ✅ 이미지 발견 (Content-Type): {full_url}")
                        return full_url
                    
                    # 2. 파일 시그니처로 이미지 여부 판단 (Text/html인 경우 대비)
                    first_bytes = response.content[:10]
                    if first_bytes.startswith(b'\xff\xd8\xff') or first_bytes.startswith(b'\x89PNG') or first_bytes.startswith(b'GIF8'):
                        logger.info(f"[try_direct_image_from_params] ✅ 이미지 발견 (파일 시그니처): {full_url}")
                        return full_url

            except requests.exceptions.RequestException as e:
                logger.debug(f"[try_direct_image_from_params] 경로 접근 실패: {e}")
                continue
    
    logger.warning(f"[try_direct_image_from_params] 모든 직접 경로 실패")
    return None

def fetch_image_from_viewer_page(viewer_url):
    #최종 뷰어 페이지 이미지 추출
    logger.info(f"[fetch_image_from_viewer_page] 최종 개선된 뷰어 페이지 이미지 추출: {viewer_url}")
    try:
        resp = requests.get(viewer_url, timeout=10)
        resp.raise_for_status()
        html_content = resp.text
        soup = BeautifulSoup(html_content, "html.parser")

        # document_pages JavaScript 변수에서 URL 추출
        script_tags = soup.find_all('script')
        for script in script_tags:
            if script.string:
                # 정규표현식?
                match = re.search(r'var document_pages\s*=\s*(\[[^;\]]*?\])', script.string, re.DOTALL)
                if match:
                    json_str = match.group(1)
                    try:
                        pages = json.loads(json_str)
                        if pages and isinstance(pages, list) and 'src' in pages[0]:
                            image_path = pages[0]['src']
                            full_url = urljoin(viewer_url, image_path)
                            
                            # 추출한 URL이 유효한 이미지인지 최종 확인
                            if 'image' in requests.head(full_url).headers.get('content-type', '').lower():
                                logger.info(f"[fetch_image_from_viewer_page] ✅ document_pages에서 이미지 발견: {full_url}")
                                return full_url
                    except json.JSONDecodeError as e:
                        logger.error(f"[fetch_image_from_viewer_page] JSON 파싱 오류: {e}")

        # 기존 로직
        img_tag = soup.find('img', class_='contents-page__img')
        if img_tag and img_tag.get('src'):
            full_url = urljoin(viewer_url, img_tag['src'])
            if 'image' in requests.head(full_url).headers.get('content-type', ''):
                 logger.info(f"[fetch_image_from_viewer_page] 유효한 이미지 URL 반환: {full_url}")
                 return full_url
        
        script_tags = soup.find_all('script')
        for script in script_tags:
            if script.string:
                img_url_patterns = [
                    r'src\s*=\s*["\']([^"\']*\.(jpg|jpeg|png|gif|bmp|webp))["\']',
                ]
                for pattern in img_url_patterns:
                    matches = re.findall(pattern, script.string, re.IGNORECASE)
                    if matches:
                        image_path = matches[0][0]
                        full_url = urljoin(viewer_url, image_path)
                        if 'image' in requests.head(full_url).headers.get('content-type', ''):
                            logger.info(f"[fetch_image_from_viewer_page] 스크립트에서 이미지 URL 반환: {full_url}")
                            return full_url

    except requests.exceptions.RequestException as e:
        logger.error(f"[fetch_image_from_viewer_page] 뷰어 페이지 요청 실패: {e}")
        return None
    
    logger.warning(f"[fetch_image_from_viewer_page] 뷰어 페이지에서 이미지를 찾지 못함")
    return None

def fetch_image_with_selenium(link_url):
    # Selenium > 동적으로 로드되는 이미지 URL 추출
    logger.info(f"[Selenium] 웹 드라이버를 사용하여 이미지 추출 시작: {link_url}")
    
    # WebDriver 설정
    options = webdriver.ChromeOptions()
    options.add_argument('headless')
    options.add_argument('window-size=1920x1080')
    options.add_argument("disable-gpu")
    options.add_argument("user-agent=Mozilla/5.0...")

    driver = None
    try:
        service = Service(ChromeDriverManager().install())
        driver = webdriver.Chrome(service=service, options=options)
        driver.get(link_url)

        # 미리보기 버튼 클릭
        wait = WebDriverWait(driver, 10)
        preview_button = wait.until(
            EC.presence_of_element_located((By.XPATH, "//a[contains(@href, 'bbs_docview')]"))
        )
        
        # 새 창 클릭
        preview_button.click()
        time.sleep(2)
        
        # 새 창
        if len(driver.window_handles) > 1:
            driver.switch_to.window(driver.window_handles[1])

        # 팝업 페이지 내의 이미지
        img_tag = wait.until(
            EC.presence_of_element_located((By.CSS_SELECTOR, ".contents-page__img"))
        )
        
        # 이미지 URL 추출
        image_url = img_tag.get_attribute("src")
        logger.info(f"[Selenium] ✅ 이미지 URL 추출 성공: {image_url}")
        
        # URL이 상대 경로인 경우 절대 경로로 변환
        if not image_url.startswith('http'):
            image_url = urljoin(driver.current_url, image_url)
            
        return image_url

    except Exception as e:
        logger.error(f"[Selenium] 이미지 추출 실패: {e}")
        return None
    finally:
        if driver:
            driver.quit()


def fetch_first_image_enhanced(link_url):
    # 이미지 추출 메인로직 업
    logger.info(f"[fetch_first_image_enhanced] === 향상된 이미지 추출 시작 === URL: {link_url}")

    if not link_url:
        logger.error(f"[fetch_first_image_enhanced] URL이 없음")
        return None

    # 일단 Selenium을 사용하여 이미지 추출 시도
    logger.info("[fetch_first_image_enhanced] Step 1: Selenium으로 이미지 추출 시도")
    image_url = fetch_image_with_selenium(link_url)
    if image_url:
        return image_url
        
    logger.error(f"[fetch_first_image_enhanced] ❌ 모든 방법 실패")
    return None