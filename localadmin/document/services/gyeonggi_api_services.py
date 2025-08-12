import requests
import json
from django.conf import settings
from django.utils import timezone
import logging
from datetime import datetime
from document.models import Document, DocumentTypeChoices, Category
from region.models import Region
from document.serializers import DocumentSerializer

logger = logging.getLogger(__name__)

class GyeonggiAPIService:
    """경기도 OpenAPI 데이터 호출 및 파싱 서비스"""
    
    def __init__(self, api_key=None):
        self.api_key = api_key or getattr(settings, 'GYEONGGI_OPENAPI_KEY', '')
        self.base_url = 'https://openapi.gg.go.kr'
        
    def fetch_documents_from_api(self, service_name, start_idx=1, end_idx=100):
        try:
            # pIndex를 start_idx로, pSize를 end_idx - start_idx + 1로 설정
            page_size = end_idx - start_idx + 1
            
            url = (
                f"{self.base_url}/{service_name}?"
                f"KEY={self.api_key}&"
                f"Type=json&"
                f"pIndex={start_idx}&"
                f"pSize={page_size}"
            )
            
            logger.info(f"Requesting URL: {url}")
            
            response = requests.get(url, timeout=30)
            response.raise_for_status()
            
            data = response.json()
            
            # 응답 구조 확인 및 row 데이터 추출
            # GgNewsDataPortal 키 아래에 리스트가 있고, 'row'는 두 번째 아이템에 존재
            if service_name in data and isinstance(data[service_name], list):
                # 리스트의 두 번째 항목이 'row' 키를 가진 딕셔너리인지 확인
                if len(data[service_name]) > 1 and 'row' in data[service_name][1]:
                    row_data = data[service_name][1]['row']
                    logger.info(f"Found {len(row_data)} documents in API response")
                    return row_data
                else:
                    logger.warning(f"No 'row' key found in the expected location for service: {service_name}")
                    return []
            else:
                logger.warning(f"Service key '{service_name}' not found or not a list in API response")
                logger.warning(f"Available top-level keys: {list(data.keys())}")
                return []
            
        except requests.RequestException as e:
            logger.error(f"API request failed: {e}")
            logger.error(f"Response text: {e.response.text if e.response is not None else 'No response'}")
            return []
        except json.JSONDecodeError as e:
            logger.error(f"JSON decode error: {e}")
            logger.error(f"Response text: {response.text}")
            return []
        except Exception as e:
            logger.error(f"Unexpected error: {e}")
            return []

class GyeonggiDocumentDataProcessor:
    """경기도 공문 데이터 처리 및 분류 서비스"""
    
    @staticmethod
    def classify_document_type(title, content):
        # 서울시 코드와 동일하게 재활용
        participation_keywords = ['모집', '신청', '참여', '설문', '공모', '접수', '워크샵', '세미나', '교육', '강의', '행사', '이벤트']
        notice_keywords = ['안내', '통보', '알림', '변경', '시행', '제도', '규정', '정책', '운영', '서비스', '시설', '휴무', '중단']
        report_keywords = ['결과', '현황', '실적', '통계', '보고', '분석', '집행', '예산', '결산', '성과', '평가']
        announcement_keywords = ['고시', '공고', '입법', '조례', '개정', '제정', '개정안', '입찰', '계약', '선정', '지정', '승인', '허가']
        
        text = f"{title} {content}".lower()
        
        if any(keyword in text for keyword in announcement_keywords):
            return DocumentTypeChoices.ANNOUNCEMENT
        elif any(keyword in text for keyword in participation_keywords):
            return DocumentTypeChoices.PARTICIPATION
        elif any(keyword in text for keyword in report_keywords):
            return DocumentTypeChoices.REPORT
        else:
            return DocumentTypeChoices.NOTICE

    @staticmethod
    def extract_categories_from_content(title, content):
        # 서울시 코드와 동일하게 재활용
        category_mapping = {
            '문화': ['문화', '예술', '공연', '전시', '축제', '영화', '음악', '행사', '도자', '미술관', '교육프로그램', '심포지엄'],
            '주택': ['주택', '부동산', '아파트', '주거', '임대', '전세', '매매', '재개발', '재건축', '상가'],
            '경제': ['경제', '상권', '소상공인', '창업', '일자리', '고용', '세금', '금융', '투자', '재단', '메이커스페이스'],
            '환경': ['환경', '재활용', '쓰레기', '청소', '녹지', '공해', '기후', '온실가스'],
            '안전': ['안전', '방범', '방재', '소방', '구조', '경보', '교통사고', '재난', '응급', '교통안전', '식중독', '예방'],
            '복지': ['복지', '지원', '혜택', '돌봄', '보조', '급여', '장애인', '노인', '아동', '청렴', '인권', '의료비'],
            '행정': ['행정', '민원', '허가', '신청', '접수', '발급', '제도', '정책', '조례', '자치경찰', '추경', '예산']
        }
        
        text = f"{title} {content}".lower()
        matched_categories = []
        
        for category, keywords in category_mapping.items():
            if any(keyword in text for keyword in keywords):
                matched_categories.append(category)
        
        return matched_categories if matched_categories else ['일반']

    @staticmethod
    def parse_date(date_str):
        if not date_str:
            return timezone.now()
        
        date_formats = [
            '%Y-%m-%d %H:%M:%S', '%Y-%m-%d', '%Y.%m.%d %H:%M:%S',
            '%Y.%m.%d', '%Y/%m/%d %H:%M:%S', '%Y/%m/%d'
        ]
        
        for fmt in date_formats:
            try:
                parsed_date = datetime.strptime(date_str, fmt)
                # timezone-aware datetime으로 변환
                return timezone.make_aware(parsed_date) if timezone.is_naive(parsed_date) else parsed_date
            except ValueError:
                continue
        
        logger.warning(f"Date parsing failed for: {date_str}")
        return timezone.now()

    @staticmethod
    def extract_deadline_from_content(content):
        import re
        
        deadline_patterns = [
            r'마감일?\s*:?\s*(\d{4}[.-/]\d{1,2}[.-/]\d{1,2})',
            r'신청\s*마감\s*:?\s*(\d{4}[.-/]\d{1,2}[.-/]\d{1,2})',
            r'접수\s*마감\s*:?\s*(\d{4}[.-/]\d{1,2}[.-/]\d{1,2})',
            r'까지\s*접수.*?(\d{4}[.-/]\d{1,2}[.-/]\d{1,2})',
        ]
        
        for pattern in deadline_patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                return match.group(1)
        
        return None

    @classmethod
    def process_gyeonggi_api_data(cls, api_data_list, region_id):
        processed_documents = []
        
        for item in api_data_list:
            try:
                title = item.get('TITLE', '')
                # API 응답에 본문 내용이 없으므로 제목을 임시로 사용
                content = item.get('TITLE', '') 
                pub_date_str = item.get('REGIST_DTM', '')
                department = item.get('INST_NM', '')
                link_url = item.get('LINK_URL', '')
                
                if not title or not link_url:
                    logger.warning(f"Skipping document due to missing title or link_url: {item}")
                    continue
                
                doc_type = cls.classify_document_type(title, content)
                category_names = cls.extract_categories_from_content(title, content)
                parsed_date = cls.parse_date(pub_date_str)
                
                deadline = None
                # 본문 내용이 없어 마감일 추출 로직은 비활성화
                
                processed_doc = {
                    'doc_title': title,
                    'doc_content': content,
                    'pub_date': parsed_date,
                    'dead_date': deadline,
                    'doc_type': doc_type,
                    'image_url': None,
                    'region_id': region_id,
                    'is_active': True,
                    'category_names': category_names,
                    'department': department,
                    'link_url': link_url,
                }
                
                processed_documents.append(processed_doc)
            
            except Exception as e:
                logger.error(f"Error processing document: {e}, item: {item}")
                continue
        
        return processed_documents

    @classmethod
    def save_documents_to_db(cls, processed_documents):
        saved_count = 0
        
        for doc_data in processed_documents:
            try:
                category_names = doc_data.pop('category_names', [])
                department = doc_data.pop('department', '')
                link_url = doc_data.pop('link_url', '')
                
                # 중복 문서 체크 (제목과 링크 URL로 확인하여 정확도 높임)
                existing_doc = Document.objects.filter(
                    doc_title=doc_data['doc_title'],
                    region_id=doc_data['region_id']
                ).first()
                
                if existing_doc:
                    # 링크 URL이 달라 새로운 문서일 가능성이 있으므로 추가 확인
                    # 현재 모델에 link_url 필드가 없으므로, title과 region_id만으로 중복 판단
                    logger.info(f"Document with same title already exists, skipping: {doc_data['doc_title']}")
                    continue
                
                # Document 인스턴스 생성
                # 모델에 없는 department와 link_url 필드는 create 인자에 포함시키지 않음
                document = Document.objects.create(
                    doc_title=doc_data['doc_title'],
                    doc_content=doc_data['doc_content'],
                    pub_date=doc_data['pub_date'],
                    dead_date=doc_data['dead_date'],
                    doc_type=doc_data['doc_type'],
                    image_url=doc_data['image_url'],
                    region_id=doc_data['region_id'],
                    is_active=doc_data['is_active']
                )
                
                # 카테고리 처리
                if category_names:
                    categories = []
                    for category_name in category_names:
                        category, created = Category.objects.get_or_create(
                            category_name=category_name
                        )
                        categories.append(category)
                    
                    document.categories.set(categories)
                
                saved_count += 1
                logger.info(f"Document saved successfully: {document.doc_title}")
                
            except Exception as e:
                logger.error(f"Error saving document: {e}")
                logger.error(f"Document data: {doc_data}")
                continue
        
        return saved_count