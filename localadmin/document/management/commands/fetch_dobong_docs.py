from django.core.management.base import BaseCommand
from document.api import update_user_documents, classify_doc_type
from document.models import Document
from user.models import User
from datetime import datetime
import re

def extract_date_from_content(content):
    
    date_patterns = [
        r'(\d{4})\s*년\s*(\d{1,2})\s*월\s*(\d{1,2})\s*일',
        r'(\d{4})\.\s*(\d{1,2})\.\s*(\d{1,2})\.',
        r'(\d{4})\s*.\s*(\d{1,2})\s*.\s*(\d{1,2})\s*\(\w\)',
        r'(\d{4})-(\d{1,2})-(\d{1,2})'
    ]
    
    for pattern in date_patterns:
        match = re.search(pattern, content)
        if match:
            try:
                year, month, day = map(int, match.groups())
                return datetime(year, month, day).date()
            except (ValueError, TypeError):
                continue
                
    return None

class Command(BaseCommand):
    help = "도봉구 공지사항 OpenAPI 데이터 업데이트 + 도봉구 문서 타입 재분류 및 마감일 필드 채우기"

    def handle(self, *args, **kwargs):
        guest_user = User.objects.get(user_id='GUEST1')  # 김덕사
        
        # 새 데이터 수집 및 저장
        for start in range(1, 101, 20):
            end = start + 19
            update_user_documents(guest_user, start, end)
        
        self.stdout.write(self.style.SUCCESS("도봉구 공지사항 API 데이터 업데이트 완료"))

        # 마감일 필드 채우기
        self.stdout.write("공문 내용에서 마감일을 추출합니다...")
        documents_to_update = Document.objects.filter(region_id=6, dead_date__isnull=True).order_by('-created_at')[:100]
        date_updated_count = 0
        for doc in documents_to_update:
            extracted_date = extract_date_from_content(doc.doc_content)
            if extracted_date:
                doc.dead_date = extracted_date
                doc.save()
                date_updated_count += 1
        
        self.stdout.write(self.style.SUCCESS(f"{date_updated_count}개의 문서에 마감일이 추가되었습니다."))

        # 기존 도봉구 데이터 타입 재분류
        updated_count = 0
        queryset = Document.objects.filter(region_id=6).order_by('-id')[:100]
        for doc in queryset:
            new_type = classify_doc_type(doc.doc_title, doc.doc_content or "")
            if doc.doc_type != new_type['type']:
                doc.doc_type = new_type['type']
                doc.save()
                updated_count += 1

        self.stdout.write(self.style.SUCCESS(f"{updated_count}개의 도봉구 문서 타입이 재분류되었습니다."))
