from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse

class DocumentDataProcessor:
    @staticmethod
    def process_seoul_api_data(api_data, region_id):
        """서울시/도봉구 OpenAPI 데이터 처리"""
        processed_documents = []
        for item in api_data:
            # LINK에서 도메인 추출
            link = item.get('LINK', '')
            base_url = ''
            if link:
                parsed_url = urlparse(link)
                base_url = f"{parsed_url.scheme}://{parsed_url.netloc}"

            # CONTENT, DESCRIPTION, BODY 등 다양한 필드 지원
            doc_content = (
                item.get('CONTENT')
                or item.get('DESCRIPTION')
                or item.get('BODY')
                or ''
            )

            image_url = DocumentDataProcessor.extract_image_url(doc_content, base_url)

            processed_documents.append({
                'title': item.get('TITLE'),
                'content': doc_content,
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
        """기타 외부 API 데이터 처리"""
        link = raw_doc.get('link', '')
        base_url = ''
        if link:
            parsed_url = urlparse(link)
            base_url = f"{parsed_url.scheme}://{parsed_url.netloc}"

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
            'image_url': image_url
        }

    @staticmethod
    def extract_image_url(html_content, base_url):
        """
        본문 HTML에서 첫 번째 이미지 URL 추출
        - img 태그 src
        - img가 없으면 a 태그 href 중 이미지 확장자(.jpg, .png 등) 추출
        """
        soup = BeautifulSoup(html_content or '', "html.parser")

        # 1. <img> 태그에서 이미지 추출
        img_tag = soup.find("img")
        if img_tag and img_tag.get("src"):
            return urljoin(base_url, img_tag["src"])

        # 2. 첨부파일 중 이미지 확장자 검색
        for a_tag in soup.find_all("a", href=True):
            href = a_tag["href"].lower()
            if href.endswith((".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp")):
                return urljoin(base_url, href)

        return None
