import requests
import xml.etree.ElementTree as ET
from django.conf import settings
from document.models import Document
from user.models import Category, User
from datetime import datetime

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
            if city == '경기도':
                return settings.GYEONGGI_OPENAPI_KEY
    # 기본 도봉구 키
    return settings.DOBONG_OPENAPI_KEY

def fetch_notices_for_user(user, start_index=1, end_index=5):
    key = get_openapi_key_for_user(user)
    api_name = 'DobongNewsNoticeList'
    if hasattr(user, 'profile'):
        region = getattr(user.profile, 'region', None)
        if isinstance(region, dict) and region.get('city') == '경기도':
            api_name = 'GyeonggiNewsNoticeList'
    
    url = f"http://openapi.seoul.go.kr:8088/{key}/xml/{api_name}/{start_index}/{end_index}/"
    print(f"API 요청 URL: {url}")  # <== 이 줄 추가
    response = requests.get(url)
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
                region_id=region_id
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
