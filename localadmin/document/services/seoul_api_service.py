import requests
import xml.etree.ElementTree as ET
import json
from datetime import datetime
from django.conf import settings
from django.db import transaction
from django.utils import timezone
import logging

from document.models import Document, DocumentTypeChoices, Category
from region.models import Region
from document.serializers import DocumentSerializer

logger = logging.getLogger(__name__)


class SeoulAPIService:
    def __init__(self, api_key=None):
        self.api_key = api_key or getattr(settings, 'SEOUL_API_KEY', '')
        self.base_url = 'http://openapi.seoul.go.kr:8088'
        
    def fetch_documents_from_api(self, service_name, region_code=None, start_idx=1, end_idx=100):
        try:
            url = f"{self.base_url}/{self.api_key}/json/{service_name}/{start_idx}/{end_idx}"
            
            params = {}
            if region_code:
                params['REGION_CD'] = region_code
                
            response = requests.get(url, params=params, timeout=30)
            response.raise_for_status()
            
            data = response.json()
            
            # API 응답 구조 주의
            if service_name in data:
                api_data = data[service_name]
                if 'row' in api_data:
                    return api_data['row']
                elif 'list_total_count' in api_data and api_data['list_total_count'] > 0:
                    return api_data.get('row', [])
            
            logger.warning(f"No data found for service: {service_name}")
            return []
            
        except requests.RequestException as e:
            logger.error(f"API request failed: {e}")
            return []
        except json.JSONDecodeError as e:
            logger.error(f"JSON decode error: {e}")
            return []
        except Exception as e:
            logger.error(f"Unexpected error: {e}")
            return []


class DocumentDataProcessor:
    @staticmethod
    def classify_document_type(title, content):
        
        participation_keywords = [
            '모집', '신청', '참여', '설문', '공모', '접수', '신청서', 
            '워크샵', '세미나', '교육', '강의', '행사', '이벤트'
        ]
        notice_keywords = [
            '안내', '통보', '알림', '변경', '시행', '제도', '규정',
            '정책', '운영', '서비스', '시설', '휴무', '중단'
        ]
        report_keywords = [
            '결과', '현황', '실적', '통계', '보고', '분석', 
            '집행', '예산', '결산', '성과', '평가'
        ]
        announcement_keywords = [
            '고시', '공고', '입법', '조례', '개정', '제정', '개정안',
            '입찰', '계약', '선정', '지정', '승인', '허가'
        ]
        
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
        # user.views 기준
        # 추후 ai openapi로 고도화
        category_mapping = {
            '문화': ['문화', '예술', '공연', '전시', '축제', '영화', '음악', '행사'],
            '주택': ['주택', '부동산', '아파트', '주거', '임대', '전세', '매매', '재개발', '재건축'],
            '경제': ['경제', '상권', '소상공인', '창업', '일자리', '고용', '세금', '금융', '투자'],
            '환경': ['환경', '재활용', '쓰레기', '청소', '녹지', '공해', '기후', '온실가스'],
            '안전': ['안전', '방범', '방재', '소방', '구조', '경보', '교통사고', '재난', '응급'],
            '복지': ['복지', '지원', '혜택', '돌봄', '보조', '급여', '장애인', '노인', '아동'],
            '행정': ['행정', '민원', '허가', '신청', '접수', '발급', '제도', '정책', '조례']
        }
        
        text = f"{title} {content}".lower()
        matched_categories = []
        
        for category, keywords in category_mapping.items():
            if any(keyword in text for keyword in keywords):
                matched_categories.append(category)
        
        return matched_categories if matched_categories else ['일반']
    
    @staticmethod 
    def parse_date(date_str):
        """날짜 문자열 파싱"""
        if not date_str:
            return timezone.now()
            
        try:
            date_formats = [
                '%Y-%m-%d %H:%M:%S',
                '%Y-%m-%d',
                '%Y.%m.%d %H:%M:%S',
                '%Y.%m.%d',
                '%Y/%m/%d %H:%M:%S', 
                '%Y/%m/%d',
            ]
            
            for fmt in date_formats:
                try:
                    return datetime.strptime(date_str, fmt)
                except ValueError:
                    continue
            
            logger.warning(f"Date parsing failed for: {date_str}")
            return timezone.now()
            
        except Exception as e:
            logger.error(f"Date parsing error: {e}")
            return timezone.now()
    
    @classmethod
    def process_seoul_api_data(cls, api_data_list, region_id):
        
        processed_documents = []
        
        for item in api_data_list:
            try:
                if service_name == 'GyeonggiNewsNoticeList':
                    title = item.get('ROW_TITLE', '')
                    content = item.get('ROW_CONTENT', '')
                    pub_date = item.get('ROW_DATE', '')
                else:
                    title = item.get('TITLE', '')
                    content = item.get('CONTENT', '')
                    pub_date = item.get('REG_DATE', '')
                title = item.get('TITLE', item.get('SJ', ''))
                content = item.get('CONTENT', item.get('CN', ''))
                pub_date = item.get('REG_DATE', item.get('REGIST_DT', ''))
                department = item.get('DEPT_NM', item.get('CHARGER_DEPT_NM', ''))
                link_url = item.get('LINK_URL', item.get('DTL_LINK', ''))
                
                if not title or not content:
                    continue
                
                doc_type = cls.classify_document_type(title, content)
                
                category_names = cls.extract_categories_from_content(title, content)
                
                parsed_date = cls.parse_date(pub_date)
                
                # 마감일 추출 (참여형only)
                deadline = None
                if doc_type == DocumentTypeChoices.PARTICIPATION:
                    deadline_str = cls.extract_deadline_from_content(content)
                    if deadline_str:
                        deadline = cls.parse_date(deadline_str)
                
                processed_doc = {
                    'title': title,
                    'content': content,
                    'pub_date': parsed_date,
                    'deadline': deadline,
                    'doc_type': doc_type,
                    'department': department,
                    'link_url': link_url,
                    'region_id': region_id,
                    'category_names': category_names,
                    'is_active': True,
                }
                
                processed_documents.append(processed_doc)
                
            except Exception as e:
                logger.error(f"Error processing document: {e}, item: {item}")
                continue
        
        return processed_documents
    
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


class DocumentService:
    @staticmethod
    def get_or_create_category(name):
        category, created = Category.objects.get_or_create(
            name=name,
            defaults={'description': f'{name} 관련 공문'}
        )
        return category
    
    @classmethod
    @transaction.atomic
    def bulk_create_documents_from_seoul_api(cls, processed_documents):
        created_documents = []
        
        for doc_data in processed_documents:
            try:
                category_names = doc_data.pop('category_names', [])
                
                existing_doc = Document.objects.filter(
                    title=doc_data['title'],
                    region_id=doc_data['region_id'],
                    pub_date__date=doc_data['pub_date'].date()
                ).first()
                
                if existing_doc:
                    logger.info(f"Document already exists: {doc_data['title']}")
                    continue
                
                document = Document.objects.create(**doc_data)
                
                for category_name in category_names:
                    category = cls.get_or_create_category(category_name)
                    document.categories.add(category)
                
                created_documents.append(document)
                logger.info(f"Created document: {document.title}")
                
            except Exception as e:
                logger.error(f"Error creating document: {e}, data: {doc_data}")
                continue
        
        return created_documents
    
    @classmethod
    def sync_seoul_api_data(cls, region_id, service_name, api_key=None):
        try:
            api_service = SeoulAPIService(api_key)
            
            api_data = api_service.fetch_documents_from_api(
                service_name=service_name,
                region_code=None,
                start_idx=1,
                end_idx=1000
            )
            
            if not api_data:
                logger.warning("No data received from Seoul API")
                return []
            
            # 전처리
            processed_documents = DocumentDataProcessor.process_seoul_api_data(
                api_data, region_id
            )
            
            # DB 저장
            created_documents = cls.bulk_create_documents_from_seoul_api(
                processed_documents
            )
            
            logger.info(f"Successfully synced {len(created_documents)} documents")
            return created_documents
            
        except Exception as e:
            logger.error(f"Error syncing Seoul API data: {e}")
            return []