from django.core.management.base import BaseCommand
from django.db import transaction
from django.conf import settings
from document.models import Document, DocumentTypeChoices
from region.models import Region
from document.services.gyeonggi_api_services import GyeonggiAPIService, GyeonggiDocumentDataProcessor
import logging

logger = logging.getLogger(__name__)

class Command(BaseCommand):
    help = "경기도 공지사항 OpenAPI 데이터 업데이트 및 문서 타입 재분류"

    def handle(self, *args, **kwargs):
        self.stdout.write(self.style.SUCCESS("경기도 공지사항 API 데이터 업데이트 시작"))
        
        try:
            gyeonggi_region = Region.objects.filter(city='경기도').first()
            
            if not gyeonggi_region:
                return
        except Exception as e:
            # self.stderr.write(self.style.ERROR(f"Region 객체 조회 중 오류 발생: {e}"))
            return

        api_service = GyeonggiAPIService(api_key=settings.GYEONGGI_OPENAPI_KEY)
        processor = GyeonggiDocumentDataProcessor()
        service_name = 'GgNewsDataPortal'
        
        total_created_count = 0
        
        for pIndex in range(1, 100, 10):
            try:
                api_data = api_service.fetch_documents_from_api(
                    service_name=service_name,
                    start_idx=pIndex,
                    end_idx=pIndex + 9
                )
                
                if not api_data:
                    # 테스트용 self.stdout.write(self.style.WARNING(f"인덱스 {pIndex}부터 {pIndex + 9}까지 데이터가 없습니다. 중단합니다."))
                    break
                
                processed_docs = processor.process_gyeonggi_api_data(
                    api_data, gyeonggi_region.id
                )
                
                self.stdout.write(f"API에서 {len(api_data)}개 문서를 가져왔고, {len(processed_docs)}개로 처리했습니다.")
                
                if not processed_docs:
                    self.stdout.write(self.style.WARNING("처리된 문서가 없습니다."))
                    continue
                
                with transaction.atomic():
                    created_count = processor.save_documents_to_db(processed_docs)
                
                total_created_count += created_count
                self.stdout.write(self.style.SUCCESS(f"인덱스 {pIndex}부터 {pIndex + 9}까지 {created_count}개 문서 생성 완료"))
                
            except Exception as e:
                self.stderr.write(self.style.ERROR(f"데이터 처리 중 오류 발생: {e}"))
                logger.exception("An error occurred during data processing loop.") # 상세 오류 로그 추가
                continue
        
        self.stdout.write(self.style.SUCCESS(f"총 {total_created_count}개의 경기도 공지사항 API 데이터 업데이트 완료"))

        # 기존 문서 타입 재분류
        self.stdout.write("기존 경기도 문서 타입 재분류 시작...")
        updated_count = 0
        queryset = Document.objects.filter(region_id=gyeonggi_region.id)
        
        for doc in queryset:
            new_type = processor.classify_document_type(doc.doc_title, doc.doc_content or "")
            if doc.doc_type != new_type:
                doc.doc_type = new_type
                doc.save()
                updated_count += 1

        self.stdout.write(self.style.SUCCESS(f"{updated_count}개의 경기도 문서 타입이 재분류되었습니다."))