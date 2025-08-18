import os
import sys
from tqdm import tqdm
import logging
import time
import django

# 프로젝트 루트 디렉터리를 Python 경로에 추가합니다.
# 이 경로는 스크립트 파일이 있는 'backend/localadmin'의 부모 디렉터리입니다.
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Django 프로젝트 설정
# 'localadmin.settings'는 settings.py 파일의 경로입니다.
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "localadmin.settings")
django.setup()

# 로깅 설정
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

from document.models import Document
from document.api import fetch_first_image_enhanced

def update_document_images():
    """
    모든 Document의 image_url을 업데이트하는 함수
    """
    # link 대신 link_url 필드 사용으로 수정
    documents_to_update = Document.objects.all().exclude(link_url__isnull=True)
    
    total_count = documents_to_update.count()
    logging.info(f"총 {total_count}개의 문서를 업데이트합니다.")

    if total_count == 0:
        logging.info("업데이트할 문서가 없습니다. 스크립트를 종료합니다.")
        return

    for doc in tqdm(documents_to_update, total=total_count, desc="이미지 업데이트 중"):
        try:
            # link_url 필드 사용으로 수정
            logging.info(f"Document ID {doc.id} - 링크 URL: {doc.link_url} 처리 시작")
            
            # 새롭게 개선된 함수를 호출하여 이미지 URL 추출 (link_url 사용)
            image_url = fetch_first_image_enhanced(doc.link_url)

            if image_url:
                # 추출된 이미지 URL로 업데이트
                doc.image_url = image_url
                doc.save(update_fields=['image_url'])
                logging.info(f"✅ Document ID {doc.id} 업데이트 성공: {image_url}")
            else:
                logging.warning(f"❌ Document ID {doc.id} 이미지 추출 실패")
            
            time.sleep(1)

        except Exception as e:
            logging.error(f"⚠️ Document ID {doc.id} 처리 중 오류 발생: {e}")
            continue

    logging.info("모든 문서 업데이트 작업 완료.")

if __name__ == "__main__":
    update_document_images()