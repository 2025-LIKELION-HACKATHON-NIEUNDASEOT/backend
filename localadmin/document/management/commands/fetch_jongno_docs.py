from django.core.management.base import BaseCommand
from document.models import Region, Document
from document.services.jongno_api_service import JongnoAPIService, JongnoDocumentProcessor
from document.api import classify_doc_type
from datetime import datetime
import logging
import re

logger = logging.getLogger(__name__)

class Command(BaseCommand):
    help = "종로구 OpenAPI에서 문서를 가져와 저장하고, 마감일과 문서 타입을 업데이트합니다."

    def handle(self, *args, **options):
        # Region 조회/생성
        try:
            region, _ = Region.objects.get_or_create(
                district="종로구",
                defaults={"city": "서울특별시"}
            )
        except Exception as e:
            self.stderr.write(self.style.ERROR(f"Region 조회/생성 오류: {e}"))
            return

        # API 호출
        api_service = JongnoAPIService()
        processor = JongnoDocumentProcessor()
        service_name = "ListPublicReservationCulture"

        api_data = api_service.fetch_documents(service_name, 1, 100)


        if not api_data:
            self.stdout.write(self.style.WARNING("종로구 API에서 데이터를 가져오지 못했습니다."))
            return

        # 데이터 처리 및 DB 저장
        saved_count = processor.process_and_save(api_data, region.id)
        self.stdout.write(self.style.SUCCESS(f"{saved_count}개의 종로구 문서를 저장했습니다."))

        # 마감일 필드 채우기 (최신 100개 문서)
        self.stdout.write("공문 내용에서 마감일을 추출합니다...")
        documents_to_update = Document.objects.filter(region_id=region.id, dead_date__isnull=True).order_by('-created_at')[:100]
        date_updated_count = 0
        for doc in documents_to_update:
            extracted_date = JongnoDocumentProcessor.extract_deadline(doc.doc_content or "")
            doc.deadline_date = extracted_date
            doc.save()
            if extracted_date:
                doc.dead_date = extracted_date
                doc.save()
                date_updated_count += 1
        self.stdout.write(self.style.SUCCESS(f"{date_updated_count}개의 문서에 마감일이 추가되었습니다."))

        # 문서 타입 재분류 (최신 100개 문서)
        self.stdout.write("문서 타입을 재분류합니다...")
        updated_count = 0
        queryset = Document.objects.filter(region_id=region.id).order_by('-id')[:100]
        for doc in queryset:
            new_type = classify_doc_type(doc.doc_title, doc.doc_content or "")
            if doc.doc_type != new_type['type']:
                doc.doc_type = new_type['type']
                doc.save()
                updated_count += 1
        self.stdout.write(self.style.SUCCESS(f"{updated_count}개의 문서 타입이 재분류되었습니다."))
