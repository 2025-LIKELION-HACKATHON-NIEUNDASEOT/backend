import google.generativeai as genai
import json
import time
import os
from django.db import connection
from django.conf import settings
import json
import re

# 변수에서 api 가져와 gemini 모델 초기화
def initialize_gemini():
    api_key = os.environ.get('GEMINI_API_KEY')
    if not api_key:
        raise ValueError("GEMINI_API_KEY가 설정되지 않았습니다.")
    genai.configure(api_key=api_key)

try:
    initialize_gemini()
except ValueError as e:
    print(f"Gemini API 초기화 오류: {e}")

if os.environ.get('GEMINI_API_KEY'):
    GEMINI_MODEL = genai.GenerativeModel('gemini-1.5-flash')
else:
    GEMINI_MODEL = None

# def check_api_status():
#     if not GEMINI_MODEL:
#         return False, "API 키가 설정되지 않음"
    
#     try:
#         response = GEMINI_MODEL.generate_content("Hello")
#         return True, "API 정상 작동"
#     except Exception as e:
#         return False, str(e)

# gemini 모델로 공문 내용 분석 및 요약, 키워드, 관련 부서 추출
def analyze_document_content(document_text, max_retries=3, base_delay=60):
    # 긴 텍스트 컷 > 토큰 사용량 다운
    max_content_length = 3000
    if len(document_text) > max_content_length:
        document_text = document_text[:max_content_length] + "..."
        print(f"경고: 문서가 너무 길어 {max_content_length}자로 잘렸습니다.")

    # 프롬프트
    prompt = f"""당신은 지역 행정 정보를 친절하고 상냥하게 요약한 버전으로 제공하는 AI 비서입니다.
    
    다음 공문을 분석하여 다음 규칙에 따라 JSON 형식으로 추출해 주세요.
    - **요약(summary) 규칙:**
    - 말투는 최대한 부드럽고 친절하게 다듬으세요.
    - 사용자의 질문에 정확하고 도움이 되는 답변을 제공해주세요.
    - 최대한 쉬운 단어로만 설명하세요.
    - 답변은 최대 10줄, 최소 3줄로 작성하세요.
    
    - **JSON 응답 규칙:**
    - 결과는 어떠한 설명이나 추가 문장 없이 오직 JSON 객체만 포함해야 합니다.
    - 키워드는 반드시 '스포츠', '청년', '복지', '환경', '재정', '교육' 등과 같은 일반적인 상위 개념으로 추출해 주세요.
    - 모든 키(title, keywords, related_departments, purpose, issue_date, summary)는 반드시 포함해야 하며, 값이 없는 경우 빈 문자열("") 또는 빈 리스트([])로 처리해 주세요.

    공문: {document_text}"""

    for attempt in range(max_retries):
        try:
            if attempt > 0:
                delay = base_delay * (2 ** (attempt - 1))
                print(f"재시도 {attempt+1}/{max_retries} - {delay}초 대기 중...")
                time.sleep(delay)
            
            response = GEMINI_MODEL.generate_content(prompt)
            json_string = response.text.strip()
            
            if json_string.startswith("```json"):
                json_string = json_string[7:].strip()
            if json_string.endswith("```"):
                json_string = json_string[:-3].strip()
            
            return json.loads(json_string)
            
        except json.JSONDecodeError as e:
            print(f"JSON 파싱 오류 발생 (시도 {attempt+1}/{max_retries}): {e}")
            print(f"오류가 발생한 문자열: {json_string}")
            return None

        except Exception as e:
            error_message = str(e)
            
            if "429" in error_message or "quota" in error_message.lower():
                print(f"할당량 초과 감지 (시도 {attempt+1}/{max_retries}): {e}")
                
                delay_match = re.search(r'seconds: (\d+)', error_message)
                if delay_match:
                    suggested_delay = int(delay_match.group(1))
                    print(f"권장 대기 시간: {suggested_delay}초")
                    if attempt < max_retries - 1:
                        time.sleep(suggested_delay + 5)
                        continue # 재시도
                
                if attempt < max_retries - 1:
                    continue
                else:
                    print("모든 재시도 실패 - 할당량 초과 또는 API 오류")
                    return None
            else:
                print(f"기타 오류로 분석 실패 (시도 {attempt+1}/{max_retries}): {e}")
                return None
    
    return None

def batch_analyze_documents(document_ids, batch_size=5, delay_between_batches=120):
    from .models import Document
    
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
                    doc.summary = analysis_result.get('summary', '') # 요약 필드 저장
                    doc.save()
                    
                    results.append({'id': doc_id, 'status': 'success'})
                    print(f"문서 ID {doc_id} 분석 완료")
                else:
                    results.append({'id': doc_id, 'status': 'failed'})
                    print(f"문서 ID {doc_id} 분석 실패")
                
                time.sleep(2)
                
            except Exception as e:
                print(f"문서 ID {doc_id} 처리 중 오류: {e}")
                results.append({'id': doc_id, 'status': 'error', 'error': str(e)})
        
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
    

# fulltext 인덱스로 공문 상세 보기에서 유사한 다른 문서 찾아 추천
def search_similar_documents_in_db(analyzed_data, current_doc_id=None, limit=3):
    """
    분석된 데이터를 바탕으로 유사 공문을 찾습니다.
    FULLTEXT 인덱스가 없는 경우 LIKE 검색을 사용합니다.
    """
    print(f"=== search_similar_documents_in_db 디버깅 시작 ===")
    print(f"입력 analyzed_data: {analyzed_data}")
    print(f"current_doc_id: {current_doc_id}")
    
    if not analyzed_data:
        print("analyzed_data가 비어있음")
        return []
    
    search_terms = []
    if analyzed_data.get('title'):
        search_terms.append(analyzed_data['title'])
        print(f"title 추가: {analyzed_data['title']}")
    if analyzed_data.get('keywords'):
        search_terms.extend(analyzed_data['keywords'])
        print(f"keywords 추가: {analyzed_data['keywords']}")
    if analyzed_data.get('related_departments'):
        search_terms.extend(analyzed_data['related_departments'])
        print(f"related_departments 추가: {analyzed_data['related_departments']}")
    if analyzed_data.get('purpose'):
        search_terms.append(analyzed_data['purpose'])
        print(f"purpose 추가: {analyzed_data['purpose']}")
    if analyzed_data.get('summary'):
        search_terms.append(analyzed_data['summary'])
        print(f"summary 추가: {analyzed_data['summary']}")
    
    print(f"최종 search_terms: {search_terms}")
    
    query_string_parts = []
    for term in search_terms:
        print(f"처리 중인 term: {term} (타입: {type(term)})")
        if isinstance(term, str):
            query_string_parts.append(f'"{term}"')
        elif isinstance(term, list):
            query_string_parts.extend([f'"{sub_term}"' for sub_term in term if isinstance(sub_term, str)])
    
    query_string = " ".join(query_string_parts)
    print(f"최종 query_string: '{query_string}'")
    
    if not query_string:
        print("query_string이 비어있음")
        return []
    
    # ✅ document_id를 Primary Key로 사용하도록 수정
    sql_query = f"""
    SELECT
        document_id as id,
        doc_title,
        SUBSTRING(doc_content, 1, 150) AS preview_content,
        pub_date,
        (
            MATCH(keywords) AGAINST (%s IN NATURAL LANGUAGE MODE) * 3 +
            MATCH(doc_title, purpose) AGAINST (%s IN NATURAL LANGUAGE MODE) * 2 +
            MATCH(summary, doc_content) AGAINST (%s IN NATURAL LANGUAGE MODE) * 1
        ) AS score
    FROM
        document
    WHERE
        MATCH(doc_title, doc_content, keywords, related_departments, purpose, summary)
        AGAINST (%s IN NATURAL LANGUAGE MODE)
        {'AND document_id != %s' if current_doc_id else ''}
    ORDER BY
        score DESC
    LIMIT %s;
    """
    
    # SQL 쿼리 실행 전 파라미터 확인
    params = [query_string, query_string, query_string, query_string]
    if current_doc_id:
        params.append(current_doc_id)
    params.append(limit)
    
    print(f"SQL 파라미터: {params}")
    print(f"실행할 SQL: {sql_query}")
    
    with connection.cursor() as cursor:
        try:
            cursor.execute(sql_query, tuple(params))
            columns = [col[0] for col in cursor.description]
            results = [dict(zip(columns, row)) for row in cursor.fetchall()]
            print(f"FULLTEXT 검색 결과 개수: {len(results)}")
            for i, result in enumerate(results):
                print(f"결과 {i+1}: ID={result['id']}, 제목={result['doc_title']}, 점수={result.get('score', 'N/A')}")
            return results
        except Exception as e:
            print(f"FULLTEXT 검색 실패: {e}")
            print("LIKE 검색으로 대체 시도...")
            return search_similar_documents_like_fallback(analyzed_data, current_doc_id, limit)


def search_similar_documents_like_fallback(analyzed_data, current_doc_id=None, limit=3):
    """
    LIKE 검색을 사용한 유사 문서 검색 (FULLTEXT 대안)
    """
    if not analyzed_data or not analyzed_data.get('keywords'):
        print("키워드가 없어서 LIKE 검색 불가")
        return []
    
    keywords = analyzed_data['keywords']
    print(f"LIKE 검색 키워드: {keywords}")
    
    like_conditions = []
    params = []
    
    for keyword in keywords:
        if keyword.strip():
            like_conditions.append("""
                (keywords LIKE %s OR 
                 doc_title LIKE %s OR 
                 purpose LIKE %s OR 
                 summary LIKE %s OR
                 doc_content LIKE %s)
            """)
            keyword_pattern = f'%{keyword.strip()}%'
            params.extend([keyword_pattern] * 5)
    
    if not like_conditions:
        print("유효한 키워드가 없음")
        return []
    
    where_clause = " OR ".join(like_conditions)
    
    sql_query = f"""
    SELECT 
        document_id as id, 
        doc_title, 
        SUBSTRING(doc_content, 1, 150) AS preview_content, 
        pub_date
    FROM document
    WHERE ({where_clause})
    {'AND document_id != %s' if current_doc_id else ''}
    ORDER BY pub_date DESC
    LIMIT %s;
    """
    
    if current_doc_id:
        params.append(current_doc_id)
    params.append(limit)
    
    print(f"LIKE 검색 파라미터 개수: {len(params)}")
    
    with connection.cursor() as cursor:
        try:
            cursor.execute(sql_query, tuple(params))
            columns = [col[0] for col in cursor.description]
            results = [dict(zip(columns, row)) for row in cursor.fetchall()]
            print(f"LIKE 검색 결과: {len(results)}개")
            for i, result in enumerate(results):
                print(f"LIKE 결과 {i+1}: ID={result['id']}, 제목={result['doc_title']}")
            return results
        except Exception as e:
            print(f"LIKE 검색 오류: {e}")
            return []

