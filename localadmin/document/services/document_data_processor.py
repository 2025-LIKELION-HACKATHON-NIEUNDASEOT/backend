import re
from urllib.parse import urlparse, urljoin
from bs4 import BeautifulSoup
from ..api import fetch_first_image_enhanced
import logging

logger = logging.getLogger(__name__)

class DocumentDataProcessor:
    @staticmethod
    def process_seoul_api_data(api_data, region_id):
        #서울시/도봉구 OpenAPI 데이터 처리
        processed_documents = []
        for item in api_data:
            pcode = item.get('SHEET_ID')
            link_url = f"https://www.dobong.go.kr/bbs.asp?bmode=D&pcode={pcode}&code=10008769" if pcode else None
            
            if item.get('CONTENTS'):
                link_match = re.search(r'(https?://\S+)', item['CONTENTS'])
                if link_match:
                    link_url = link_url or link_match.group(1)

            image_url = None
            if link_url:
                logger.info(f"문서 ID: {pcode} - 미리보기 이미지 추출 시도: {link_url}")
                try:
                    image_url = fetch_first_image_enhanced(link_url)
                except Exception as e:
                    logger.error(f"미리보기 이미지 추출 중 오류 발생: {e}")

            if not image_url:
                logger.warning(f"미리보기 이미지 추출 실패, 본문에서 이미지 추출 시도.")
                doc_content = (
                    item.get('CONTENT')
                    or item.get('DESCRIPTION')
                    or item.get('BODY')
                    or ''
                )
                link = item.get('LINK', '')
                base_url = f"{urlparse(link).scheme}://{urlparse(link).netloc}" if link else ''
                image_url = DocumentDataProcessor.extract_image_url(doc_content, base_url)

            processed_documents.append({
                'title': item.get('TITLE'),
                'content': item.get('CONTENTS'),
                'link_url': link_url, # 링크 URL 추가
                'pub_date': item.get('PUBLISH_DATE') or item.get('PUBDATE'),
                'deadline': item.get('DEADLINE'),
                'category': item.get('CATEGORY'),
                'department': item.get('DEPARTMENT'),
                'region_id': region_id,
                'image_url': image_url
            })
        return processed_documents

    @staticmethod
    def process_api_data(raw_doc, region_id):
        link = raw_doc.get('link', '')
        base_url = f"{urlparse(link).scheme}://{urlparse(link).netloc}" if link else ''

        doc_content = raw_doc.get('content', '')
        image_url = DocumentDataProcessor.extract_image_url(doc_content, base_url)

        return {
            'title': raw_doc.get('title'),
            'content': doc_content,
            'pub_date': raw_doc.get('date'),
            'deadline': raw_doc.get('deadline'),
            'category': raw_doc.get('category'),
            'department': raw_doc.get('department'),
            'region_id': region_id,
            'image_url': image_url,
            'link_url': raw_doc.get('link') # link 추가
        }

    @staticmethod
    def extract_image_url(html_content, base_url):
        soup = BeautifulSoup(html_content or '', "html.parser")

        img_tag = soup.find("img")
        if img_tag and img_tag.get("src"):
            return urljoin(base_url, img_tag["src"])

        for a_tag in soup.find_all("a", href=True):
            href = a_tag["href"].lower()
            if href.endswith((".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp")):
                return urljoin(base_url, href)

        return None