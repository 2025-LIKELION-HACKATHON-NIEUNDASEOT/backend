# update_links.py
# 이 파일은 Django shell 밖에서 실행됩니다.

import os
import django
import sys
import xml.etree.ElementTree as ET
import requests
import logging
import re
import time
from tqdm import tqdm
from django.db.models import Q
from django.db import transaction


# Django 환경 설정
# settings.py 경로를 프로젝트에 맞게 수정하세요.
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'localadmin.settings')
django.setup()


logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

from document.models import Document
from document.api import fetch_first_image_enhanced

def update_document_images():
    """
    모든 Document의 image_url을 업데이트하는 함수
    """
    # link_url 필드에 값이 있고, image_url 필드가 비어있는 문서만 선택하도록 수정
    documents_to_update = Document.objects.filter(~Q(link_url__isnull=True) & ~Q(link_url__exact='') & Q(image_url__isnull=True) | Q(image_url__exact=''))
    
    total_count = documents_to_update.count()
    logging.info(f"총 {total_count}개의 문서를 업데이트합니다.")

    if total_count == 0:
        logging.info("업데이트할 문서가 없습니다. 스크립트를 종료합니다.")
        return

    # 대량의 데이터 업데이트 시 데이터 무결성을 위해 transaction.atomic() 사용
    with transaction.atomic():
        for doc in tqdm(documents_to_update, total=total_count, desc="이미지 업데이트 중"):
            try:
                logging.info(f"Document ID {doc.id} - 링크 URL: {doc.link_url} 처리 시작")
                
                # 새롭게 개선된 함수를 호출하여 이미지 URL 추출
                image_url = fetch_first_image_enhanced(doc.link_url)

                if image_url:
                    # 추출된 이미지 URL로 업데이트
                    doc.image_url = image_url
                    doc.save(update_fields=['image_url'])
                    logging.info(f"✅ Document ID {doc.id} 업데이트 성공: {image_url}")
                else:
                    logging.warning(f"❌ Document ID {doc.id} 이미지 추출 실패")
                
                # Selenium은 페이지 로딩에 시간이 걸리므로 sleep은 필요에 따라 조절
                time.sleep(1)

            except Exception as e:
                logging.error(f"⚠️ Document ID {doc.id} 처리 중 오류 발생: {e}")
                # 오류가 발생해도 다음 문서로 진행
                continue

    logging.info("모든 문서 업데이트 작업 완료.")

if __name__ == "__main__":
    update_document_images()