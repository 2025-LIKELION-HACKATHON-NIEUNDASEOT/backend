from django.db import transaction
from django.utils import timezone
from django.core.exceptions import ValidationError
from typing import Dict, List, Optional, Any
import logging

from .models import Document, DocumentTypeChoices
from user.models import Category

logger = logging.getLogger(__name__)


class DocumentService:
    """공문 데이터 관리 서비스"""
    
    @staticmethod
    def create_document(document_data: Dict[str, Any]) -> Document:
        """
        단일 공문 생성
        
        Args:
            document_data: 공문 데이터 딕셔너리
            
        Returns:
            Document: 생성된 공문 객체
        """
        try:
            with transaction.atomic():
                # 카테고리 데이터 분리
                categories_data = document_data.pop('categories', [])
                
                # 공문 객체 생성
                document = Document.objects.create(**document_data)
                
                # 카테고리 연결
                if categories_data:
                    document.categories.set(categories_data)
                
                logger.info(f"Document created: {document.id} - {document.doc_title}")
                return document
                
        except Exception as e:
            logger.error(f"Error creating document: {e}")
            raise ValidationError(f"공문 생성 중 오류가 발생했습니다: {str(e)}")
    
    @staticmethod
    def bulk_create_documents(documents_data: List[Dict[str, Any]]) -> List[Document]:
        """
        여러 공문 일괄 생성
        
        Args:
            documents_data: 공문 데이터 리스트
            
        Returns:
            List[Document]: 생성된 공문 객체 리스트
        """
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
        """중복 공문 체크"""
        return Document.objects.filter(
            doc_title=document_data.get('doc_title'),
            region_id=document_data.get('region_id'),
            pub_date=document_data.get('pub_date')
        ).exists()
    
    @staticmethod
    def update_document(document_id: int, update_data: Dict[str, Any]) -> Document:
        """
        공문 업데이트
        
        Args:
            document_id: 공문 ID
            update_data: 업데이트할 데이터
            
        Returns:
            Document: 업데이트된 공문 객체
        """
        try:
            with transaction.atomic():
                document = Document.objects.select_for_update().get(id=document_id)
                
                # 카테고리 데이터 분리
                categories_data = update_data.pop('categories', None)
                
                # 필드 업데이트
                for field, value in update_data.items():
                    setattr(document, field, value)
                
                document.save()
                
                # 카테고리 업데이트
                if categories_data is not None:
                    document.categories.set(categories_data)
                
                logger.info(f"Document updated: {document.id}")
                return document
                
        except Document.DoesNotExist:
            raise ValidationError(f"공문을 찾을 수 없습니다: {document_id}")
        except Exception as e:
            logger.error(f"Error updating document {document_id}: {e}")
            raise ValidationError(f"공문 업데이트 중 오류가 발생했습니다: {str(e)}")


class DocumentDataProcessor:
    """API에서 가져온 데이터를 Document 모델에 맞게 변환하는 프로세서"""
    
    TYPE_MAPPING = {
        '공고': DocumentTypeChoices.ANNOUNCEMENT,
        '고시': DocumentTypeChoices.ANNOUNCEMENT,
        '보고': DocumentTypeChoices.REPORT,
        '공지': DocumentTypeChoices.NOTICE,
        '참여': DocumentTypeChoices.PARTICIPATION,
        '모집': DocumentTypeChoices.PARTICIPATION,
        '신청': DocumentTypeChoices.PARTICIPATION,
    }
    
    @staticmethod
    def process_api_data(api_data: Dict[str, Any], region_id: int) -> Dict[str, Any]:
        """
        API 데이터를 Document 모델 형식으로 변환
        
        Args:
            api_data: API에서 받은 원본 데이터
            region_id: 지역 ID
            
        Returns:
            Dict: Document 모델에 맞는 데이터
        """
        try:
            # 기본 데이터 매핑
            processed_data = {
                'doc_title': api_data.get('title', api_data.get('doc_title', '')),
                'doc_content': api_data.get('content', api_data.get('doc_content', '')),
                'pub_date': DocumentDataProcessor._parse_date(api_data.get('date', api_data.get('pub_date'))),
                'region_id': region_id,
                'is_active': True,
                'image_url': api_data.get('image_url', api_data.get('attachment_url'))
            }
            
            # 문서 타입 결정
            processed_data['doc_type'] = DocumentDataProcessor._determine_doc_type(
                api_data.get('category', ''),
                processed_data['doc_title']
            )
            
            # 마감일 처리 (참여형 문서의 경우)
            if processed_data['doc_type'] == DocumentTypeChoices.PARTICIPATION:
                processed_data['dead_date'] = DocumentDataProcessor._parse_date(
                    api_data.get('deadline', api_data.get('dead_date'))
                )
            
            # 카테고리 처리
            processed_data['categories'] = DocumentDataProcessor._get_categories(
                api_data.get('category', ''),
                api_data.get('department', '')
            )
            
            return processed_data
            
        except Exception as e:
            logger.error(f"Error processing API data: {e}")
            raise ValidationError(f"데이터 처리 중 오류가 발생했습니다: {str(e)}")
    
    @staticmethod
    def _parse_date(date_string: Any) -> Optional[timezone.datetime]:
        """날짜 문자열 파싱"""
        if not date_string:
            return None
            
        try:
            if isinstance(date_string, str):
                # 다양한 날짜 형식 처리
                from django.utils.dateparse import parse_datetime, parse_date
                
                # datetime 시도
                parsed = parse_datetime(date_string)
                if parsed:
                    return parsed
                
                # date 시도 후 datetime으로 변환
                parsed_date = parse_date(date_string)
                if parsed_date:
                    return timezone.datetime.combine(parsed_date, timezone.datetime.min.time())
                    
            return date_string if isinstance(date_string, timezone.datetime) else None
            
        except Exception as e:
            logger.warning(f"Date parsing failed for {date_string}: {e}")
            return None
    
    @staticmethod
    def _determine_doc_type(category: str, title: str) -> str:
        """문서 타입 결정"""
        text_to_check = f"{category} {title}".lower()
        
        # 키워드 기반 타입 결정
        participation_keywords = ['참여', '모집', '신청', '접수', '공모', '설문']
        announcement_keywords = ['공고', '고시', '안내', '알림']
        report_keywords = ['보고', '현황', '결과', '실적']
        
        if any(keyword in text_to_check for keyword in participation_keywords):
            return DocumentTypeChoices.PARTICIPATION
        elif any(keyword in text_to_check for keyword in announcement_keywords):
            return DocumentTypeChoices.ANNOUNCEMENT
        elif any(keyword in text_to_check for keyword in report_keywords):
            return DocumentTypeChoices.REPORT
        else:
            return DocumentTypeChoices.NOTICE
    
    @staticmethod
    def _get_categories(category_str: str, department: str) -> List[int]:
        """카테고리 ID 리스트 반환"""
        try:
            category_mapping = {
                '행사': ['행사', '축제', '이벤트'],
                '교통': ['교통', '도로', '주차', '대중교통'],
                '시설': ['시설', '건물', '공원', '도서관'],
                '복지': ['복지', '보건', '의료', '건강'],
                '환경': ['환경', '청소', '재활용', '녹색'],
                '교육': ['교육', '학교', '수업', '강의'],
                '문화': ['문화', '예술', '전시', '공연'],
                '안전': ['안전', '방범', '소방', '재해']
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