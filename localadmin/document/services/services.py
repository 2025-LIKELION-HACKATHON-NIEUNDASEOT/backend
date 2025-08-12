from django.db import transaction
from django.utils import timezone
from django.core.exceptions import ValidationError
from typing import Dict, List, Optional, Any
import logging

from document.models import Document, DocumentTypeChoices
from user.models import Category

logger = logging.getLogger(__name__)


class DocumentService:
    #공문 데이터 관리 서비스
    
    @staticmethod
    def create_document(document_data: Dict[str, Any]) -> Document:
        try:
            with transaction.atomic():
                categories_data = document_data.pop('categories', [])
                document = Document.objects.create(**document_data)
                
                if categories_data:
                    document.categories.set(categories_data)
                
                logger.info(f"Document created: {document.id} - {document.doc_title}")
                return document
                
        except Exception as e:
            logger.error(f"Error creating document: {e}")
            raise ValidationError(f"공문 생성 중 오류가 발생했습니다: {str(e)}")
    
    @staticmethod
    def bulk_create_documents(documents_data: List[Dict[str, Any]]) -> List[Document]:
        created_documents = []
        
        try:
            with transaction.atomic():
                for doc_data in documents_data:
                    try:
                        # 중복 체크 (제목 + 지역 + 게시일 기준)
                        if not DocumentService._is_duplicate(doc_data):
                            document = DocumentService.create_document(doc_data)
                            created_documents.append(document)
                        else:
                            logger.info(f"Duplicate document skipped: {doc_data.get('doc_title', 'Unknown')}")
                    
                    except Exception as e:
                        logger.error(f"Error creating individual document: {e}")
                        continue
                
                logger.info(f"Bulk created {len(created_documents)} documents")
                return created_documents
                
        except Exception as e:
            logger.error(f"Error in bulk creation: {e}")
            raise ValidationError(f"공문 일괄 생성 중 오류가 발생했습니다: {str(e)}")
    
    @staticmethod
    def _is_duplicate(document_data: Dict[str, Any]) -> bool:
        return Document.objects.filter(
            doc_title=document_data.get('doc_title'),
            region_id=document_data.get('region_id'),
            pub_date=document_data.get('pub_date')
        ).exists()


class DocumentDataProcessor:
    #api에서 가져온 데이터를 Document 모델에 맞게 변환
    
    # 기능명세서 기준 4가지 타입
    TYPE_MAPPING = {
        '참여': DocumentTypeChoices.PARTICIPATION,  # 참여 유도형 (행사, 설문)
        '공지': DocumentTypeChoices.NOTICE,          # 공지형 (행정제도 안내, 통보)
        '보고': DocumentTypeChoices.REPORT,          # 보고형 (사업 결과, 예산 집행)
        '고시': DocumentTypeChoices.ANNOUNCEMENT,    # 법적 고시/공고형 (입법예고, 조례개정)
        '공고': DocumentTypeChoices.ANNOUNCEMENT,
    }
    
    @staticmethod
    def process_api_data(api_data: Dict[str, Any], region_id: int) -> Dict[str, Any]:
        # API 데이터 > Document 모델 형식으로 변환
        try:
            doc_title = api_data.get('ROW_TITLE', api_data.get('title', ''))
            doc_content = api_data.get('ROW_CONTENT', api_data.get('content', ''))
            pub_date = DocumentDataProcessor._parse_date(api_data.get('ROW_DATE', api_data.get('pub_date', '')))
            department = api_data.get('ROW_DEPT', api_data.get('department', ''))
            link_url = api_data.get('ROW_URL', api_data.get('link_url', ''))

            if not doc_title:
                doc_title = api_data.get('doc_title', '')
            if not doc_content:
                doc_content = api_data.get('doc_content', '')

            if not doc_title or not doc_content:
                logger.warning("Skipping document due to missing title or content.")
                return None

            processed_data = {
                'doc_title': doc_title,
                'doc_content': doc_content,
                'pub_date': pub_date,
                'region_id': region_id,
                'is_active': True,
                'image_url': api_data.get('image_url', api_data.get('attachment_url', '')),
                'department': department,
                'link_url': link_url
            }
            
            # 4가지 타입 분류
            processed_data['doc_type'] = DocumentDataProcessor._determine_doc_type(
                api_data.get('category', ''),
                processed_data['doc_title']
            )
            
            # 마감일
            if processed_data['doc_type'] == DocumentTypeChoices.PARTICIPATION:
                processed_data['dead_date'] = DocumentDataProcessor._parse_date(
                    api_data.get('deadline', api_data.get('dead_date', ''))
                )
            
            # 카테고리
            processed_data['categories'] = DocumentDataProcessor._get_categories(
                api_data.get('category', ''),
                processed_data['department']
            )
            
            return processed_data
            
        except Exception as e:
            logger.error(f"Error processing API data: {e}")
            raise ValidationError(f"데이터 처리 중 오류가 발생했습니다: {str(e)}")

    @staticmethod
    def _parse_date(date_string: Any) -> Optional[timezone.datetime]:
        if not date_string:
            return None
            
        try:
            if isinstance(date_string, str):
                from django.utils.dateparse import parse_datetime, parse_date
                
                parsed = parse_datetime(date_string)
                if parsed:
                    return parsed
                
                parsed_date = parse_date(date_string)
                if parsed_date:
                    return timezone.datetime.combine(parsed_date, timezone.datetime.min.time())
                    
            return date_string if isinstance(date_string, timezone.datetime) else None
            
        except Exception as e:
            logger.warning(f"Date parsing failed for {date_string}: {e}")
            return None
    
    @staticmethod
    def _determine_doc_type(category: str, title: str) -> str:
        text_to_check = f"{category} {title}".lower()
        
        participation_keywords = ['참여', '모집', '신청', '접수', '공모', '설문', '행사', '이벤트']
        report_keywords = ['보고', '현황', '결과', '실적', '예산', '집행', '성과']
        announcement_keywords = ['고시', '공고', '입법', '예고', '조례', '개정', '규정', '법령']
        notice_keywords = ['공지', '안내', '통보', '알림', '제도', '변경', '시행']
        
        if any(keyword in text_to_check for keyword in participation_keywords):
            return DocumentTypeChoices.PARTICIPATION
        elif any(keyword in text_to_check for keyword in report_keywords):
            return DocumentTypeChoices.REPORT
        elif any(keyword in text_to_check for keyword in announcement_keywords):
            return DocumentTypeChoices.ANNOUNCEMENT
        else:
            return DocumentTypeChoices.NOTICE
    
    @staticmethod
    def _get_categories(category_str: str, department: str) -> List[int]:
        try:
            category_mapping = {
                '문화': ['문화', '예술', '공연', '전시', '축제', '영화', '음악', '행사'],
                '주택': ['주택', '부동산', '아파트', '주거', '임대', '전세', '매매', '재개발', '재건축'],
                '경제': ['경제', '상권', '소상공인', '창업', '일자리', '고용', '세금', '금융', '투자'],
                '환경': ['환경', '재활용', '쓰레기', '청소', '녹지', '공해', '기후', '온실가스'],
                '안전': ['안전', '방범', '방재', '소방', '구조', '경보', '교통사고', '재난', '응급'],
                '복지': ['복지', '지원', '혜택', '돌봄', '보조', '급여', '장애인', '노인', '아동'],
                '행정': ['행정', '민원', '허가', '신청', '접수', '발급', '제도', '정책', '조례']
            }
            
            text_to_check = f"{category_str} {department}".lower()
            matched_categories = []
            
            for category_name, keywords in category_mapping.items():
                if any(keyword in text_to_check for keyword in keywords):
                    try:
                        category = Category.objects.get(name=category_name)
                        matched_categories.append(category.id)
                    except Category.DoesNotExist:
                        continue
            
            return matched_categories
            
        except Exception as e:
            logger.warning(f"Category matching failed: {e}")
            return []