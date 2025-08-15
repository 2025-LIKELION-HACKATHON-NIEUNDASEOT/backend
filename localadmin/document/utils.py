# yourapp/utils.py (개선된 코드)

import google.generativeai as genai
import json
import time
import os
from django.db import connection
from django.conf import settings

def initialize_gemini():
    """
    환경 변수에서 API 키를 가져와 Gemini를 초기화합니다.
    """
    api_key = os.environ.get('GEMINI_API_KEY')
    if not api_key:
        raise ValueError("GEMINI_API_KEY가 설정되지 않았습니다.")
    genai.configure(api_key=api_key)

# API 키를 가져와 Gemini를 초기화합니다.
try:
    initialize_gemini()
except ValueError as e:
    print(f"Gemini API 초기화 오류: {e}")

# 초기화가 성공했는지 확인한 후 모델을 불러옵니다.
if os.environ.get('GEMINI_API_KEY'):
    GEMINI_MODEL = genai.GenerativeModel('gemini-1.5-flash')  # flash 모델로 변경 (더 빠르고 저렴)
else:
    GEMINI_MODEL = None

def check_api_status():
    """
    Gemini API 상태를 간단히 확인합니다.
    """
    if not GEMINI_MODEL:
        return False, "API 키가 설정되지 않음"
    
    try:
        # 매우 간단한 테스트 요청
        response = GEMINI_MODEL.generate_content("Hello")
        return True, "API 정상 작동"
    except Exception as e:
        return False, str(e)

def analyze_document_content(document_text, max_retries=3, base_delay=60):
    """
    Gemini API를 사용하여 공문 텍스트를 분석하고 핵심 정보를 추출합니다.
    Rate limiting과 재시도 로직이 추가되었습니다.
    """
    if not GEMINI_MODEL:
        print("경고: Gemini API 키가 설정되지 않아 분석을 건너뜁니다.")
        return None

    # 긴 텍스트를 자르기 (토큰 사용량 줄이기)
    max_content_length = 3000  # 약 1500-2000 토큰 정도
    if len(document_text) > max_content_length:
        document_text = document_text[:max_content_length] + "..."
        print(f"경고: 문서가 너무 길어서 {max_content_length}자로 잘렸습니다.")

    # 더 간단하고 짧은 프롬프트 사용
    prompt = f"""다음 공문을 간단히 분석하여 JSON으로 추출해 주세요:

{{
    "title": "문서 제목",
    "keywords": ["키워드1", "키워드2"],
    "related_departments": ["관련기관1"],
    "purpose": "목적 요약",
    "issue_date": "발행일",
    "summary": "100자 이내 요약"
}}

공문: {document_text}"""

    for attempt in range(max_retries):
        try:
            # API 호출 전 잠시 대기 (Rate limiting 방지)
            if attempt > 0:
                delay = base_delay * (2 ** (attempt - 1))  # 지수 백오프
                print(f"재시도 {attempt+1}/{max_retries} - {delay}초 대기 중...")
                time.sleep(delay)
            
            response = GEMINI_MODEL.generate_content(prompt)
            json_string = response.text.strip()
            
            # JSON 파싱
            if json_string.startswith("```json"):
                json_string = json_string[7:].strip()
            if json_string.endswith("```"):
                json_string = json_string[:-3].strip()
            
            return json.loads(json_string)
            
        except Exception as e:
            error_message = str(e)
            
            # 할당량 초과 오류인지 확인
            if "429" in error_message or "quota" in error_message.lower():
                print(f"할당량 초과 감지 (시도 {attempt+1}/{max_retries}): {e}")
                
                # retry_delay가 있으면 그 값을 사용
                if "retry_delay" in error_message:
                    try:
                        # 간단한 방법으로 retry_delay 추출
                        import re
                        delay_match = re.search(r'seconds: (\d+)', error_message)
                        if delay_match:
                            suggested_delay = int(delay_match.group(1))
                            print(f"권장 대기 시간: {suggested_delay}초")
                            if attempt < max_retries - 1:
                                time.sleep(suggested_delay + 5)  # 여유분 5초 추가
                                continue
                    except:
                        pass
                
                # 마지막 시도가 아니면 계속 재시도
                if attempt < max_retries - 1:
                    continue
                else:
                    print("모든 재시도 실패 - 할당량 초과")
                    return None
            else:
                print(f"기타 오류로 분석 실패: {e}")
                return None
    
    return None

def batch_analyze_documents(document_ids, batch_size=5, delay_between_batches=120):
    """
    문서들을 배치 단위로 분석합니다.
    Rate limiting을 고려하여 배치 간 지연시간을 둡니다.
    """
    from .models import Document  # 같은 앱 내의 models에서 import
    
    results = []
    total_batches = (len(document_ids) + batch_size - 1) // batch_size
    
    for i in range(0, len(document_ids), batch_size):
        batch = document_ids[i:i + batch_size]
        batch_num = i // batch_size + 1
        
        print(f"\n=== 배치 {batch_num}/{total_batches} 처리 중 (문서 {len(batch)}개) ===")
        
        for doc_id in batch:
            try:
                doc = Document.objects.get(id=doc_id)
                print(f"문서 ID {doc_id} 분석 중...")
                
                analysis_result = analyze_document_content(doc.doc_content)
                
                if analysis_result:
                    # 분석 결과를 데이터베이스에 저장
                    doc.keywords = list_to_comma_separated_str(analysis_result.get('keywords', []))
                    doc.related_departments = list_to_comma_separated_str(analysis_result.get('related_departments', []))
                    doc.purpose = analysis_result.get('purpose', '')
                    doc.summary = analysis_result.get('summary', '')
                    doc.save()
                    
                    results.append({'id': doc_id, 'status': 'success'})
                    print(f"문서 ID {doc_id} 분석 완료")
                else:
                    results.append({'id': doc_id, 'status': 'failed'})
                    print(f"문서 ID {doc_id} 분석 실패")
                
                # 각 문서 간 짧은 지연
                time.sleep(2)
                
            except Exception as e:
                print(f"문서 ID {doc_id} 처리 중 오류: {e}")
                results.append({'id': doc_id, 'status': 'error', 'error': str(e)})
        
        # 배치 간 지연 (마지막 배치가 아닌 경우)
        if batch_num < total_batches:
            print(f"다음 배치까지 {delay_between_batches}초 대기...")
            time.sleep(delay_between_batches)
    
    return results

def list_to_comma_separated_str(data_list):
    """리스트를 쉼표로 구분된 문자열로 변환합니다."""
    if not data_list:
        return None
    return ", ".join(data_list)

def comma_separated_str_to_list(data_str):
    """쉼표로 구분된 문자열을 리스트로 변환합니다."""
    if not data_str:
        return []
    return [item.strip() for item in data_str.split(',') if item.strip()]

def search_similar_documents_in_db(analyzed_data, current_doc_id=None, limit=3):
    """
    분석된 데이터를 바탕으로 MySQL FULLTEXT 검색을 사용하여 유사 공문을 찾습니다.
    """
    if not analyzed_data:
        return []

    search_terms = []
    # Gemini 분석 결과에서 사용할 필드들
    if analyzed_data.get('title'):
        search_terms.append(analyzed_data['title'])
    if analyzed_data.get('keywords'):
        search_terms.extend(analyzed_data['keywords'])
    if analyzed_data.get('related_departments'):
        search_terms.extend(analyzed_data['related_departments'])
    if analyzed_data.get('purpose'):
        search_terms.append(analyzed_data['purpose'])

    query_string_parts = []
    for term in search_terms:
        if isinstance(term, str):
            query_string_parts.append(f'"{term}"')
        elif isinstance(term, list):
            query_string_parts.extend([f'"{sub_term}"' for sub_term in term if isinstance(sub_term, str)])
    
    query_string = " ".join(query_string_parts)
    
    if not query_string:
        return []

    sql_query = f"""
    SELECT
        id,
        doc_title,
        SUBSTRING(doc_content, 1, 150) AS preview_content,
        pub_date,
        MATCH(doc_title, doc_content, keywords, related_departments, purpose) AGAINST (%s IN NATURAL LANGUAGE MODE) AS score
    FROM
        yourapp_document
    WHERE
        MATCH(doc_title, doc_content, keywords, related_departments, purpose) AGAINST (%s IN NATURAL LANGUAGE MODE)
        {'AND id != %s' if current_doc_id else ''}
    ORDER BY
        score DESC
    LIMIT %s;
    """
    
    params = [query_string, query_string]
    if current_doc_id:
        params.append(current_doc_id)
    params.append(limit)

    with connection.cursor() as cursor:
        try:
            cursor.execute(sql_query, tuple(params))
            columns = [col[0] for col in cursor.description]
            results = [dict(zip(columns, row)) for row in cursor.fetchall()]
            return results
        except Exception as e:
            print(f"Database error during search: {e}")
            return []