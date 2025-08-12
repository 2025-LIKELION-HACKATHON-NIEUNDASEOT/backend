from django.core.management.base import BaseCommand
from document.api import update_user_documents, classify_doc_type
from document.models import Document
from user.models import User

class Command(BaseCommand):
    help = "도봉구 공지사항 OpenAPI 데이터 업데이트 + 도봉구 문서 타입 재분류"

    def handle(self, *args, **kwargs):
        guest_user = User.objects.get(user_id='GUEST1')  # 기본 유저 (게스트)
        
        # 1. 새 데이터 수집 및 저장
        for start in range(1, 101, 20):
            end = start + 19
            update_user_documents(guest_user, start, end)  # 여기 user 객체 넘겨줘야 함
        
        self.stdout.write(self.style.SUCCESS("도봉구 공지사항 API 데이터 업데이트 완료"))

        # 2. 기존 도봉구 데이터 타입 재분류
        updated_count = 0
        queryset = Document.objects.filter(region_id=6)  # 도봉구만 선택
        for doc in queryset:
            new_type = classify_doc_type(doc.doc_title, doc.doc_content or "")
            if doc.doc_type != new_type['type']:  # classify_doc_type은 dict 반환
                doc.doc_type = new_type['type']
                doc.save()
                updated_count += 1

        self.stdout.write(self.style.SUCCESS(f"{updated_count}개의 도봉구 문서 타입이 재분류되었습니다."))
