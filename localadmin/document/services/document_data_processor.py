# backend/localadmin/document/services/document_data_processor.py

class DocumentDataProcessor:
    @staticmethod
    def process_seoul_api_data(api_data, region_id):
        # 실제 API 데이터를 원하는 형태로 가공하는 로직 작성
        # 예시: 단순히 데이터를 그대로 반환한다고 가정
        return api_data

    @staticmethod
    def process_api_data(raw_doc, region_id):
        # 단일 문서 데이터를 처리하는 로직 작성
        # 예시: 최소한의 변환 코드
        processed_doc = {
            'title': raw_doc.get('title'),
            'content': raw_doc.get('content'),
            'pub_date': raw_doc.get('date'),
            'deadline': raw_doc.get('deadline'),
            'category': raw_doc.get('category'),
            'department': raw_doc.get('department'),
            'region_id': region_id,
        }
        return processed_doc
