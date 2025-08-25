import requests
import json
import logging
import re
from datetime import datetime
from django.utils import timezone
from django.conf import settings
from document.models import Document, DocumentTypeChoices, Category

logger = logging.getLogger(__name__)

# 종로구청 공지사항 OpenAPI에 요청해서 json 데이터 가져옴
class JongnoAPIService:
    BASE_URL = "http://openapi.seoul.go.kr:8088"

    def __init__(self, api_key=None):
        self.api_key = api_key or getattr(settings, 'JONGNO_OPENAPI_KEY', '')
        if not self.api_key:
            logger.warning("JONGNO_OPENAPI_KEY가 설정되지 않았습니다!")

    def fetch_documents(self, service_name, start_idx=1, end_idx=100):
        url = f"{self.BASE_URL}/{self.api_key}/json/{service_name}/{start_idx}/{end_idx}"
        logger.info(f"Requesting URL: {url}")
        try:
            response = requests.get(url, timeout=30)
            response.raise_for_status()
            text = response.text.strip()
            print("응답 원문:", text[:500])  # 테ㅡ트용

            if text.startswith('<'):
                logger.error(f"API 오류: {text}")
                return []

            data = response.json()
            if service_name in data and isinstance(data[service_name], dict):
                return data[service_name].get('row', [])
            else:
                logger.warning(f"No data or invalid structure for service: {service_name}")
                return []

        except requests.RequestException as e:
            logger.error(f"API 요청 실패: {e}")
            return []
        except json.JSONDecodeError as e:
            logger.error(f"JSON 디코딩 오류: {e}")
            return []

# 공문 제목, 내용 기반으로 타입, 카테고리 분류 > 추후 다른 api 파싱 service 코드와 통합
class JongnoDocumentProcessor:
    participation_keywords = ['모집', '신청', '참여', '설문', '공모', '접수', '워크샵', '세미나', '교육', '강의', '행사', '이벤트']
    notice_keywords = ['안내', '통보', '알림', '변경', '시행', '제도', '규정', '정책', '운영', '서비스', '시설', '휴무', '중단']
    report_keywords = ['결과', '현황', '실적', '통계', '보고', '분석', '집행', '예산', '결산', '성과', '평가']
    announcement_keywords = ['고시', '공고', '입법', '조례', '개정', '제정', '개정안', '입찰', '계약', '선정', '지정', '승인', '허가']

    category_mapping = {
        '문화': ['문화', '예술', '공연', '전시', '축제', '영화', '음악', '도자', '미술관', '교육프로그램', '심포지엄'],
        '주택': ['주택', '부동산', '아파트', '주거', '임대', '전세', '매매', '재개발', '재건축', '상가'],
        '경제': ['경제', '상권', '소상공인', '창업', '일자리', '고용', '세금', '금융', '투자', '재단', '메이커스페이스'],
        '환경': ['환경', '재활용', '쓰레기', '청소', '녹지', '공해', '기후', '온실가스'],
        '안전': ['안전', '방범', '방재', '소방', '구조', '경보', '교통사고', '재난', '응급', '교통안전', '식중독', '예방'],
        '복지': ['복지', '지원', '혜택', '돌봄', '보조', '급여', '장애인', '노인', '아동', '청렴', '인권', '의료비'],
        '행정': ['행정', '민원', '허가', '신청', '접수', '발급', '제도', '정책', '조례', '자치경찰', '추경', '예산']
    }

    @staticmethod
    def classify_document_type(title, content):
        text = f"{title} {content}".lower()
        if any(k in text for k in JongnoDocumentProcessor.announcement_keywords):
            return DocumentTypeChoices.ANNOUNCEMENT
        elif any(k in text for k in JongnoDocumentProcessor.participation_keywords):
            return DocumentTypeChoices.PARTICIPATION
        elif any(k in text for k in JongnoDocumentProcessor.report_keywords):
            return DocumentTypeChoices.REPORT
        else:
            return DocumentTypeChoices.NOTICE

    @staticmethod
    def extract_categories(title, content):
        text = f"{title} {content}".lower()
        matched = []
        for category, keywords in JongnoDocumentProcessor.category_mapping.items():
            if any(k in text for k in keywords):
                matched.append(category)
        return matched if matched else ['일반']

    @staticmethod
    def parse_date(date_str):
        if not date_str:
            return None
        date_str = date_str.strip()
        date_formats = ['%Y-%m-%d', '%Y/%m/%d', '%Y.%m.%d',
                        '%Y-%m-%d %H:%M:%S', '%Y/%m/%d %H:%M:%S', '%Y.%m.%d %H:%M:%S']
        for fmt in date_formats:
            try:
                dt = datetime.strptime(date_str, fmt)
                return timezone.make_aware(dt) if timezone.is_naive(dt) else dt
            except ValueError:
                continue
        return None

    # api 데이터 목록 순회하면서 각 공문을 document 모델에 저장 - 문서 업데이트or생성
    @classmethod
    def process_and_save(cls, api_data, region_id):
        saved_count = 0
        for notice in api_data:  # api_data는 리스트
            try:
                title = notice.get('SVCNM') or notice.get('TITLE') or "제목 없음"
                description = notice.get('USETGTINFO') or notice.get('DESCRIPTION') or ""
                pub_date_str = notice.get('SVCDATE') or notice.get('PUBDATE')
                pub_date = cls.parse_date(pub_date_str) or timezone.now()

                doc_type = cls.classify_document_type(title, description)
                categories = cls.extract_categories(title, description)

                document, created = Document.objects.update_or_create(
                    doc_title=title,
                    defaults={
                        'doc_content': description,
                        'pub_date': pub_date,
                        'region_id': region_id,
                        'doc_type': doc_type
                    }
                )

                category_objs = Category.objects.filter(category_name__in=categories)
                document.categories.set(category_objs)

                saved_count += 1
                logger.info(f"[저장 완료] {title}")

            except Exception as e:
                logger.error(f"[저장 실패] {title} : {e}")

        return saved_count

    @staticmethod
    def extract_deadline(text):
        if not text:
            return None

        now_year = datetime.now().year

        patterns = [
            r'(\d{4}년\s*\d{1,2}월\s*\d{1,2}일)',
            r'(\d{1,2}[/-]\d{1,2})',
            r'(\d{4}[.-/]\d{1,2}[.-/]\d{1,2})',
        ]

        for pat in patterns:
            match = re.search(pat, text)
            if match:
                date_str = match.group(1)
                if '년' in date_str and '월' in date_str and '일' in date_str:
                    date_str = re.sub(r'[년월]', '-', date_str)
                    date_str = date_str.replace('일', '')
                    date_str = re.sub(r'\s+', '', date_str)
                elif re.match(r'^\d{1,2}[/-]\d{1,2}$', date_str):
                    date_str = f"{now_year}-{date_str.replace('/', '-')}"
                dt = JongnoDocumentProcessor.parse_date(date_str)
                if dt:
                    return dt

        return None