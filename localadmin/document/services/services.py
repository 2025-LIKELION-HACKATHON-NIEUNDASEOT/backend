from django.db import transaction
from django.utils import timezone
from django.core.exceptions import ValidationError
from typing import Dict, List, Optional, Any
import logging
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
from datetime import datetime
import requests
from document.models import Document, DocumentTypeChoices
from user.models import Category

logger = logging.getLogger(__name__)


# class DocumentService:
    
#     # bulk_create_documents에 통합, 추후 삭제 예정
#     @staticmethod
#     def create_document(document_data: Dict[str, Any]) -> Document:
#         try:
#             with transaction.atomic():
#                 categories_data = document_data.pop('categories', [])
#                 document = Document.objects.create(**document_data)
                
#                 if categories_data:
#                     document.categories.set(categories_data)
                
#                 logger.info(f"Document created: {document.id} - {document.doc_title}")
#                 return document
                
#         except Exception as e:
#             logger.error(f"Error creating document: {e}")
#             raise ValidationError(f"공문 생성 중 오류가 발생했습니다: {str(e)}")
    
#     @staticmethod
#     def bulk_create_documents(documents_data: List[Dict[str, Any]]) -> List[Document]:
#         created_documents = []
        
#         try:
#             with transaction.atomic():
#                 for doc_data in documents_data:
#                     try:
#                         if not DocumentService._is_duplicate(doc_data):
#                             document = DocumentService.create_document(doc_data)
#                             created_documents.append(document)
#                         else:
#                             logger.info(f"Duplicate document skipped: {doc_data.get('doc_title', 'Unknown')}")
                    
#                     except Exception as e:
#                         logger.error(f"Error creating individual document: {e}")
#                         continue
                
#                 logger.info(f"Bulk created {len(created_documents)} documents")
#                 return created_documents
                
#         except Exception as e:
#             logger.error(f"Error in bulk creation: {e}")
#             raise ValidationError(f"공문 일괄 생성 중 오류가 발생했습니다: {str(e)}")
    
#     # bulk_create_documents에 통합, 추후 삭제 예정
#     @staticmethod
#     def _is_duplicate(document_data: Dict[str, Any]) -> bool:
#         return Document.objects.filter(
#             doc_title=document_data.get('doc_title'),
#             region_id=document_data.get('region_id'),
#             pub_date=document_data.get('pub_date')
#         ).exists()


# document/services.py (수정된 코드)

from django.db import transaction
from django.utils import timezone
from django.core.exceptions import ValidationError
from typing import Dict, List, Optional, Any
import logging
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
from datetime import datetime
import requests
from django.db.models import Q

from document.models import Document, DocumentTypeChoices
from user.models import Category

logger = logging.getLogger(__name__)

# 중복되지 않은 문서만 생성하도록 fix
class DocumentService:
    @staticmethod
    def bulk_create_documents(documents_data: List[Dict[str, Any]]) -> List[Document]:
        if not documents_data:
            return []

        doc_titles = [doc.get('doc_title') for doc in documents_data]
        link_urls = [doc.get('link_url') for doc in documents_data if 'link_url' in doc]
        
        existing_docs = Document.objects.filter(
            Q(doc_title__in=doc_titles) | Q(link_url__in=link_urls)
        ).values('doc_title', 'link_url')
        
        existing_titles = {doc['doc_title'] for doc in existing_docs}
        existing_urls = {doc['link_url'] for doc in existing_docs if doc['link_url']}
        
        # 중복되지 않는 새로운 문서
        new_documents = []
        for doc_data in documents_data:
            doc_title = doc_data.get('doc_title')
            link_url = doc_data.get('link_url')
            is_duplicate = False
            if doc_title and doc_title in existing_titles:
                is_duplicate = True
            elif link_url and link_url in existing_urls:
                is_duplicate = True
                
            if not is_duplicate:
                new_documents.append(Document(**doc_data))
                
        if not new_documents:
            logger.info("모든 문서가 중복되어 생성된 문서가 없습니다.")
            return []
            
        with transaction.atomic():
            created_documents = Document.objects.bulk_create(new_documents)
            
            for doc in created_documents:
                original_data = next((d for d in documents_data if d['doc_title'] == doc.doc_title), None)
                if original_data and 'categories' in original_data:
                    doc.categories.set(original_data['categories'])
            
            logger.info(f"성공적으로 {len(created_documents)}개의 문서가 일괄 생성되었습니다.")
            return created_documents

class DocumentDataProcessor:
    TYPE_MAPPING = {
        '참여': 'participation',
        '공지': 'notice',
        '보고': 'report',
        '고시': 'announcement',
        '공고': 'announcement',
    }

    @staticmethod
    def process_api_data(api_data: Dict[str, Any], region_id: int) -> Optional[Dict[str, Any]]:
        try:
            link_url = api_data.get('LINK') or api_data.get('ROW_URL') or api_data.get('link_url', '')
            base_url = ''
            if link_url:
                parsed_url = urlparse(link_url)
                base_url = f"{parsed_url.scheme}://{parsed_url.netloc}"

            doc_title = api_data.get('TITLE') or api_data.get('ROW_TITLE') or ''
            doc_content = api_data.get('DESCRIPTION') or api_data.get('ROW_CONTENT') or ''
            pub_date = DocumentDataProcessor._parse_date(api_data.get('PUBDATE') or api_data.get('ROW_DATE'))
            department = api_data.get('DEPARTMENT') or api_data.get('ROW_DEPT', '')

            if not doc_title or not doc_content:
                logger.warning("Skipping document due to missing title or content.")
                return None

            image_url = DocumentDataProcessor.extract_image_url(doc_content, base_url)

            if not image_url and link_url:
                image_url = DocumentDataProcessor.extract_image_from_link(link_url)

            processed_data = {
                'doc_title': doc_title,
                'doc_content': doc_content,
                'pub_date': pub_date,
                'region_id': region_id,
                'is_active': True,
                'image_url': image_url,
                'department': department,
                'link_url': link_url,
            }

            processed_data['doc_type'] = DocumentDataProcessor._determine_doc_type(
                api_data.get('CATEGORY', ''), doc_title
            )

            # 참여형이면 마감일 처리
            if processed_data['doc_type'] == 'participation':
                processed_data['dead_date'] = DocumentDataProcessor._parse_date(
                    api_data.get('DEADLINE')
                )

            processed_data['categories'] = DocumentDataProcessor._get_categories(
                api_data.get('CATEGORY', ''), department
            )

            return processed_data

        except Exception as e:
            logger.error(f"Error processing API data: {e}")
            raise ValidationError(f"데이터 처리 중 오류가 발생했습니다: {str(e)}")

    @staticmethod
    def extract_image_url(html_content: str, base_url: str) -> Optional[str]:
        """본문 HTML에서 이미지 추출"""
        soup = BeautifulSoup(html_content or '', "html.parser")

        img_tag = soup.find("img")
        if img_tag and img_tag.get("src"):
            return urljoin(base_url, img_tag["src"])

        for a_tag in soup.find_all("a", href=True):
            href = a_tag["href"].lower()
            if href.endswith((".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp")):
                return urljoin(base_url, href)

        return None

    @staticmethod
    def extract_image_from_link(link_url: str) -> Optional[str]:
        """<LINK> 페이지에서 첫 번째 이미지 추출"""
        try:
            resp = requests.get(link_url, timeout=5)
            resp.raise_for_status()
            soup = BeautifulSoup(resp.text, "html.parser")
            img_tag = soup.find("img")
            if img_tag and img_tag.get("src"):
                base_url = f"{urlparse(link_url).scheme}://{urlparse(link_url).netloc}"
                return urljoin(base_url, img_tag["src"])
        except Exception as e:
            logger.warning(f"Failed to fetch image from link {link_url}: {e}")
        return None

    @staticmethod
    def _parse_date(date_string: Any) -> Optional[timezone.datetime]:
        if not date_string:
            return None
        try:
            from django.utils.dateparse import parse_datetime, parse_date
            if isinstance(date_string, str):
                parsed = parse_datetime(date_string)
                if parsed:
                    return timezone.make_aware(parsed)
                parsed_date = parse_date(date_string)
                if parsed_date:
                    return timezone.make_aware(
                        timezone.datetime.combine(parsed_date, timezone.datetime.min.time())
                    )
            elif isinstance(date_string, timezone.datetime):
                return timezone.make_aware(date_string) if timezone.is_naive(date_string) else date_string
            return None
        except Exception as e:
            logger.warning(f"Date parsing failed for {date_string}: {e}")
            return None

    @staticmethod
    def _determine_doc_type(category: str, title: str) -> str:
        text = f"{category} {title}".lower()
        if any(k in text for k in ['참여', '모집', '신청', '접수', '공모', '설문', '행사', '이벤트']):
            return 'participation'
        elif any(k in text for k in ['보고', '현황', '결과', '실적', '예산', '집행', '성과']):
            return 'report'
        elif any(k in text for k in ['고시', '공고', '입법', '예고', '조례', '개정', '규정', '법령']):
            return 'announcement'
        else:
            return 'notice'

    @staticmethod
    def _get_categories(category_str: str, department: str) -> List[int]:
        from user.models import Category
        category_mapping = {
            '문화': ['문화', '예술', '공연', '전시', '축제', '영화', '음악', '행사'],
            '주택': ['주택', '부동산', '아파트', '주거', '임대', '전세', '매매', '재개발', '재건축'],
            '경제': ['경제', '상권', '소상공인', '창업', '일자리', '고용', '세금', '금융', '투자'],
            '환경': ['환경', '재활용', '쓰레기', '청소', '녹지', '공해', '기후', '온실가스'],
            '안전': ['안전', '방범', '방재', '소방', '구조', '경보', '교통사고', '재난', '응급'],
            '복지': ['복지', '지원', '혜택', '돌봄', '보조', '급여', '장애인', '노인', '아동'],
            '행정': ['행정', '민원', '허가', '신청', '접수', '발급', '제도', '정책', '조례']
        }
        text = f"{category_str} {department}".lower()
        matched_categories = []
        for cat_name, keywords in category_mapping.items():
            if any(k in text for k in keywords):
                try:
                    category = Category.objects.get(name=cat_name)
                    matched_categories.append(category.id)
                except Category.DoesNotExist:
                    continue
        return matched_categories