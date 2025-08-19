import json
import logging
import re
from pathlib import Path
from datetime import datetime
from django.core.management.base import BaseCommand
from django.utils import timezone
from django.utils.html import strip_tags
from document.models import Document, DocumentTypeChoices, Category, Region
from document.services.jongno_api_service import JongnoDocumentProcessor

logger = logging.getLogger(__name__)

class Command(BaseCommand):
    help = "종로구 JSON 파일에서 문서를 가져와 DB에 저장합니다."

    def handle(self, *args, **options):
        self.stdout.write("jn.json 파일을 읽고 있습니다...")
        file_path = Path('jn.json')
        if not file_path.exists():
            self.stderr.write(self.style.ERROR(f'오류: 파일이 존재하지 않습니다. {file_path}'))
            return

        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            documents_data = data.get('DATA', [])
            self.stdout.write(self.style.SUCCESS(f"파일에서 {len(documents_data)}개의 문서를 발견했습니다."))
        except (IOError, json.JSONDecodeError) as e:
            self.stderr.write(self.style.ERROR(f"JSON 파일 읽기 또는 파싱 오류: {e}"))
            return

        try:
            region, _ = Region.objects.get_or_create(
                district="종로구",
                defaults={"city": "서울특별시"}
            )
        except Exception as e:
            self.stderr.write(self.style.ERROR(f"Region 조회/생성 오류: {e}"))
            return

        processor = JongnoDocumentProcessor()
        saved_count = 0
        for doc in documents_data:
            try:
                title = doc.get('title', "제목 없음")
                content_raw = doc.get('description', "")
                pub_date_str = doc.get('pubdate')
                link_url = doc.get('link')
                related_departments = doc.get('department')
                
                doc_content = strip_tags(content_raw)
                pub_date = processor.parse_date(pub_date_str)
                if not pub_date:
                    pub_date = timezone.now()
                
                doc_type = processor.classify_document_type(title, doc_content)
                extracted_deadline = processor.extract_deadline(doc_content)
                
                image_url_match = re.search(r'src=[\'"](http[s]?://.*?)[\'"]', content_raw)
                image_url = image_url_match.group(1) if image_url_match else None

                document, created = Document.objects.update_or_create(
                    doc_title=title,
                    defaults={
                        'doc_content': doc_content,
                        'doc_type': doc_type,
                        'pub_date': pub_date,
                        'dead_date': extracted_deadline,
                        'is_active': True,
                        'region_id': region.id,
                        'image_url': image_url,
                        'link_url': link_url,
                        'related_departments': related_departments
                    }
                )

                categories = processor.extract_categories(title, doc_content)
                category_objs = Category.objects.filter(category_name__in=categories)
                document.categories.set(category_objs)

                saved_count += 1
                self.stdout.write(self.style.SUCCESS(f"[저장 완료] {title}"))
            except Exception as e:
                self.stderr.write(self.style.ERROR(f"문서 처리 중 오류 발생: {title} - {e}"))

        self.stdout.write(self.style.SUCCESS(f"{saved_count}개의 문서를 처리하여 데이터베이스에 저장했습니다."))