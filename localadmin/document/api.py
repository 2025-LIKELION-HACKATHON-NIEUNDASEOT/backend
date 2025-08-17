import requests
import xml.etree.ElementTree as ET
from django.conf import settings
from document.models import Document
from user.models import Category, User
from datetime import datetime
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
import re


def get_default_guest_user():
    try:
        return User.objects.get(user_id='GUEST1')  # 김덕사
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
    # 기본 도봉구 키
    return settings.DOBONG_OPENAPI_KEY

def fetch_notices_for_user(user, start_index=1, end_index=5):
    key = get_openapi_key_for_user(user)
    api_name = 'DobongNewsNoticeList'  # 기본값

    if hasattr(user, 'profile'):
        region = getattr(user.profile, 'region', None)
        if region:
            if region.city == '경기도':
                api_name = 'GyeonggiNewsNoticeList'
            elif region.city == '서울특별시' and region.district == '도봉구':
                api_name = 'DobongNewsNoticeList'
            elif region.city == '서울특별시' and region.district == '종로구':
                api_name = 'JongnoNewsNoticeList'

    url = f"http://openapi.seoul.go.kr:8088/{key}/xml/{api_name}/{start_index}/{end_index}/"
    print(f"API 요청 URL: {url}")
    response = requests.get(url)
    print(f"사용 중인 키: {key}")
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


def extract_file_info_from_html(html_content):
    """HTML에서 첨부파일 정보와 bbs_docview 파라미터 추출"""
    soup = BeautifulSoup(html_content, "html.parser")
    file_info = []
    
    # bbs_docview 링크
    docview_pattern = r"javascript:bbs_docview\('([^']+)','([^']+)','([^']+)'\)"
    docview_matches = re.findall(docview_pattern, html_content)
    
    # 첨부파일 다운로드 링크 찾기
    download_links = soup.find_all('a', href=re.compile(r'/WDB_common/include/download\.asp'))
    
    for link in download_links:
        href = link.get('href')
        # URL에서 fcode와 bcode 추출
        fcode_match = re.search(r'fcode=(\d+)', href)
        bcode_match = re.search(r'bcode=(\d+)', href)
        
        if fcode_match and bcode_match:
            fcode = fcode_match.group(1)
            bcode = bcode_match.group(1)
            
            # 파일명 추출
            title = link.get('title', '')
            filename = title.split(' ')[0] if title else ''
            
            file_info.append({
                'fcode': fcode,
                'bcode': bcode,
                'filename': filename,
                'download_url': href
            })
    
    return file_info, docview_matches


def get_image_viewer_url(base_url, bcode, seq, fcode):
    """bbs_docview 파라미터를 이용해 이미지 뷰어 URL 생성"""
    possible_patterns = [
        f"{base_url}/WDB_common/include/file_view.asp?bcode={bcode}&seq={seq}&fcode={fcode}",
        f"{base_url}/WDB_common/include/image_view.asp?bcode={bcode}&fcode={fcode}",
        f"{base_url}/WDB_common/include/popup_view.asp?bcode={bcode}&seq={seq}&fcode={fcode}",
        f"{base_url}/WDB_common/include/doc_view.asp?bcode={bcode}&seq={seq}&fcode={fcode}",
        f"{base_url}/WDB_common/popup/file_view.asp?bcode={bcode}&fcode={fcode}",
    ]
    return possible_patterns


def try_direct_image_access(base_url, fcode, bcode):
    # 첨부파일 직접 접근
    direct_patterns = [
        f"{base_url}/WDB_common/upload/{bcode}/{fcode}",
        f"{base_url}/upload/board/{bcode}/{fcode}",
        f"{base_url}/files/{bcode}/{fcode}",
        f"{base_url}/WDB_common/files/{bcode}/{fcode}.jpg",
        f"{base_url}/WDB_common/files/{bcode}/{fcode}.png",
    ]
    
    for pattern in direct_patterns:
        try:
            resp = requests.head(pattern, timeout=5)
            if resp.status_code == 200 and 'image' in resp.headers.get('content-type', '').lower():
                return pattern
        except:
            continue
    return None


def fetch_image_from_viewer_page(viewer_url):
    """이미지 뷰어 페이지에서 실제 이미지 URL 추출"""
    try:
        print(f"이미지 뷰어 페이지 접근: {viewer_url}")
        resp = requests.get(viewer_url, timeout=10)
        resp.raise_for_status()
        soup = BeautifulSoup(resp.text, "html.parser")
        
        # 이미지 뷰어 페이지에서 이미지 찾기
        img_tags = soup.find_all('img')
        for img in img_tags:
            src = img.get('src', '')
            if src and not any(exclude in src.lower() for exclude in 
                             ['btn_', 'icon_', 'logo', 'banner', 'header', 'footer', 'button']):
                return urljoin(viewer_url, src)
        
        script_tags = soup.find_all('script')
        for script in script_tags:
            if script.string:
                img_url_patterns = [
                    r'src\s*=\s*["\']([^"\']*\.(jpg|jpeg|png|gif|bmp|webp))["\']',
                    r'image\s*=\s*["\']([^"\']*\.(jpg|jpeg|png|gif|bmp|webp))["\']',
                    r'url\s*=\s*["\']([^"\']*\.(jpg|jpeg|png|gif|bmp|webp))["\']'
                ]
                for pattern in img_url_patterns:
                    matches = re.findall(pattern, script.string, re.IGNORECASE)
                    if matches:
                        return urljoin(viewer_url, matches[0][0])
        
        return None
        
    except Exception as e:
        print(f"이미지 뷰어 페이지 접근 실패 ({viewer_url}): {e}")
        return None


def fetch_first_image(link_url):
    """링크 페이지에서 실제 이미지 URL 가져오기 (완전 개선된 버전)"""
    if not link_url:
        return None
        
    print(f"이미지 추출 시작: {link_url}")
    
    try:
        resp = requests.get(link_url, timeout=10)
        resp.raise_for_status()
        html_content = resp.text
        
        # URL 파싱 > base_url 추출
        parsed_url = urlparse(link_url)
        base_url = f"{parsed_url.scheme}://{parsed_url.netloc}"
        
        # HTML에서 파일 정보와 docview 파라미터 추출
        file_info_list, docview_matches = extract_file_info_from_html(html_content)
        
        print(f"추출된 파일 정보: {file_info_list}")
        print(f"추출된 docview 파라미터: {docview_matches}")
        
        # 이미지 파일 필터링 jpg png 등
        image_files = []
        for file_info in file_info_list:
            filename = file_info['filename'].lower()
            if any(filename.endswith(ext) for ext in ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp']):
                image_files.append(file_info)
        
        print(f"이미지 파일들: {image_files}")
        
        # docview 매개변수
        for docview_match in docview_matches:
            bcode, seq, fcode = docview_match
            print(f"docview 파라미터로 시도: bcode={bcode}, seq={seq}, fcode={fcode}")
            
            viewer_urls = get_image_viewer_url(base_url, bcode, seq, fcode)
            
            for viewer_url in viewer_urls:
                image_url = fetch_image_from_viewer_page(viewer_url)
                if image_url:
                    print(f"이미지 뷰어에서 발견: {image_url}")
                    return image_url
        
        for file_info in image_files:
            fcode = file_info['fcode']
            bcode = file_info['bcode']
            
            direct_image_url = try_direct_image_access(base_url, fcode, bcode)
            if direct_image_url:
                print(f"직접 접근으로 발견: {direct_image_url}")
                return direct_image_url
        
        # 다운로드 링크
        for file_info in image_files:
            download_url = urljoin(base_url, file_info['download_url'])
            try:
                head_resp = requests.head(download_url, timeout=5)
                if head_resp.status_code == 200:
                    content_type = head_resp.headers.get('content-type', '').lower()
                    if 'image' in content_type:
                        print(f"다운로드 링크가 이미지: {download_url}")
                        return download_url
            except:
                continue
        
        soup = BeautifulSoup(html_content, "html.parser")
        img_tags = soup.find_all("img")
        for img_tag in img_tags:
            src = img_tag.get("src")
            if src:
                src_lower = src.lower()
                if (not any(exclude in src_lower for exclude in 
                           ['btn_', 'icon_', 'logo', 'banner', 'header', 'footer', 'button', 'nav']) and
                    any(ext in src_lower for ext in ['.jpg', '.jpeg', '.png', '.gif'])):
                    return urljoin(link_url, src)
        
        print("이미지를 찾을 수 없습니다.")
        return None
        
    except Exception as e:
        print(f"이미지 추출 실패 ({link_url}): {e}")
        return None


def save_notices_to_db(notices, user):
    region = None
    if hasattr(user, 'profile'):
        region = getattr(user.profile, 'region', None)
        if isinstance(region, dict):
            region_name = region.get('city', '').lower()
        elif isinstance(region, str):
            region_name = region.lower()
        else:
            region_name = 'dobong'
    else:
        region_name = 'dobong'

    region_map = {
        'dobong': 6,
        '경기도': 7,
        'ggyeongi': 7,
        'gyeonggi': 7,
    }
    region_id = region_map.get(region_name, 2)

    for notice in notices:
        try:
            print("저장 시도:", notice['title'])
            result = classify_doc_type(notice['title'], notice.get('description', ''))
            pub_date_str = notice.get('pubdate')
            if pub_date_str:
                pub_date = datetime.strptime(pub_date_str, '%Y-%m-%d %H:%M:%S')
            else:
                from django.utils import timezone
                pub_date = timezone.now()

            doc = Document.objects.create(
                doc_title=notice['title'],
                doc_content=notice.get('description', ''),
                doc_type=result['type'],
                pub_date=pub_date,
                region_id=region_id,
                image_url=fetch_first_image(notice.get('link'))
            )
            print("저장 완료:", doc.id)

            if result['category']:
                categories_objs = Category.objects.filter(category_name__in=result['category'])
                doc.categories.add(*categories_objs)

        except Exception as e:
            print("저장 실패:", notice['title'], e)

def update_user_documents(user, start=1, end=5):
    print(f"update_user_documents 시작: user={user}")
    xml_data = fetch_notices_for_user(user, start, end)
    print(f"fetch_notices_for_user 결과(원본 XML):\n{xml_data[:500]}")
    notices = parse_notices(xml_data)
    print(f"파싱된 공지 개수: {len(notices)}")
    if len(notices) == 0:
        print("공지사항 데이터가 없습니다.")
    else:
        save_notices_to_db(notices, user)
    print("update_user_documents 종료")