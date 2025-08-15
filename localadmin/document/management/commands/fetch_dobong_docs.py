from django.core.management.base import BaseCommand
from document.api import update_user_documents, classify_doc_type
from document.models import Document
from user.models import User
from datetime import datetime
import re

def extract_date_from_content(content):
    """
    공문 내용에서 날짜를 찾아 datetime 객체로 변환하는 함수입니다.
    다양한 날짜 형식을 인식할 수 있도록 정규 표현식을 사용합니다.
    
    Args:
        content (str): 날짜 정보가 포함된 공문 내용 문자열.
        
    Returns:
        datetime.date or None: 추출된 날짜를 담은 datetime.date 객체 또는 날짜를 찾지 못한 경우 None.
    """
    
    # 여러 날짜 형식을 포함하는 정규 표현식 패턴을 정의합니다.
    # 예: 2025. 8. 14.(목), 2025-08-14, 2025년 8월 14일 등
    date_patterns = [
        r'(\d{4})\s*년\s*(\d{1,2})\s*월\s*(\d{1,2})\s*일',  # YYYY년 MM월 DD일
        r'(\d{4})\.\s*(\d{1,2})\.\s*(\d{1,2})\.',         # YYYY. MM. DD.
        r'(\d{4})\s*.\s*(\d{1,2})\s*.\s*(\d{1,2})\s*\(\w\)', # YYYY. M. D. (요일)
        r'(\d{4})-(\d{1,2})-(\d{1,2})'                   # YYYY-MM-DD
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
        # 최근 100개 문서에 대해 마감일 필드가 비어있는 경우에만 업데이트
        # 불필요한 전체 순회를 방지하기 위해 최신 문서를 필터링합니다.
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
        # 최근 업데이트된 문서(id가 큰 순)를 기준으로 재분류를 진행합니다.
        queryset = Document.objects.filter(region_id=6).order_by('-id')[:100]
        for doc in queryset:
            new_type = classify_doc_type(doc.doc_title, doc.doc_content or "")
            if doc.doc_type != new_type['type']:
                doc.doc_type = new_type['type']
                doc.save()
                updated_count += 1

        self.stdout.write(self.style.SUCCESS(f"{updated_count}개의 도봉구 문서 타입이 재분류되었습니다."))
