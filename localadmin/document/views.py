from django.utils import timezone
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django.db.models import Q
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
import logging
from datetime import date

from .models import Document, DocumentTypeChoices
from .services import DocumentService, DocumentDataProcessor
from .services.seoul_api_service import SeoulAPIService, DocumentService as SeoulDocumentService
from .serializers import DocumentSerializer, DocumentListSerializer, DocumentDetailWithSimilarSerializer
from .utils import analyze_document_content, search_similar_documents_in_db, list_to_comma_separated_str, comma_separated_str_to_list
from document.api import fetch_first_image_enhanced

from scrap.models import DocumentScrap
from .serializers import DocumentScrapUpcomingSerializer
from user.utils import get_current_user, create_success_response, create_error_response

# ChatbotSession 모델
from chatbot.models import ChatbotSession

logger = logging.getLogger(__name__)

class DocumentListView(generics.ListAPIView):
    serializer_class = DocumentListSerializer
    
    @swagger_auto_schema(
        operation_summary="공문 목록 조회 (최신순)",
        operation_description="""
        공문 목록을 최신순으로 조회합니다. 사용자의 관심 지역 및 관심 주제로 필터링 가능합니다.
        
        ### 필터링 옵션
        - region_id: 관심 지역 (도봉구 - 6, 경기도 - 85)
        - category: 관심 주제 (1,2,3)
        - doc_type: 공문 타입 (참여/공지/보고/고시공고)
        """,
        manual_parameters=[
            openapi.Parameter(
                'region_id', openapi.IN_QUERY, 
                description="관심 지역 ID (복수 선택: 도봉구 6, 경기도 85)", 
                type=openapi.TYPE_STRING
            ),
            openapi.Parameter(
                'category', openapi.IN_QUERY,
                description="관심 주제 ID (복수 선택: 1,2,3)",
                type=openapi.TYPE_STRING
            ),
            openapi.Parameter(
                'doc_type', openapi.IN_QUERY,
                description="공문 타입",
                type=openapi.TYPE_STRING,
                enum=['PARTICIPATION', 'NOTICE', 'REPORT', 'ANNOUNCEMENT']
            ),
        ],
        responses={200: DocumentListSerializer(many=True)},
        tags=['공문 조회']
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)
    
    def get_queryset(self):
        queryset = Document.objects.filter(is_active=True).select_related().prefetch_related('categories')
        
        region_ids_str = self.request.query_params.get('region_id', '')
        if region_ids_str:
            try:
                region_ids = [int(rid.strip()) for rid in region_ids_str.split(',') if rid.strip().isdigit()]
                if region_ids:
                    queryset = queryset.filter(region_id__in=region_ids)
            except ValueError:
                pass
        
        category_str = self.request.query_params.get('category', '')
        if category_str:
            try:
                category_ids = [int(cid.strip()) for cid in category_str.split(',') if cid.strip().isdigit()]
                if category_ids:
                    queryset = queryset.filter(categories__id__in=category_ids).distinct()
            except ValueError:
                pass
        
        doc_types = self.request.query_params.getlist('doc_type')
        if doc_types:
            queryset = queryset.filter(doc_type__in=doc_types)
        
        return queryset.order_by('-pub_date')


# class DocumentDetailView(generics.RetrieveAPIView):
#     """
#     공문 상세 조회
#     기능명세서: "공문 자세히보기"
#     """
#     queryset = Document.objects.filter(is_active=True)
#     serializer_class = DocumentSerializer
    
#     @swagger_auto_schema(
#         operation_summary="공문 상세 조회",
#         operation_description="특정 공문의 상세 정보를 조회합니다.",
#         responses={
#             200: DocumentSerializer(),
#             404: "공문을 찾을 수 없습니다."
#         },
#         tags=['공문 조회']
#     )
#     def get(self, request, *args, **kwargs):
#         return super().get(request, *args, **kwargs)


@swagger_auto_schema(
    method='post',
    operation_summary="서울시 OpenAPI 데이터 동기화",
    operation_description="서울시 OpenAPI에서 공문 데이터를 조회하여 DB에 저장합니다.",
    request_body=openapi.Schema(
        type=openapi.TYPE_OBJECT,
        required=['region_id', 'service_name'],
        properties={
            'region_id': openapi.Schema(
                type=openapi.TYPE_INTEGER,
                description='지역 ID'
            ),
            'service_name': openapi.Schema(
                type=openapi.TYPE_STRING,
                description='서울시 API 서비스명 (예: ListPublicDataPblancDetail)'
            ),
            'api_key': openapi.Schema(
                type=openapi.TYPE_STRING,
                description='서울시 API 키',
            ),
            'start_idx': openapi.Schema(
                type=openapi.TYPE_INTEGER,
                description='시작 인덱스 (기본값: 1)',
                default=1
            ),
            'end_idx': openapi.Schema(
                type=openapi.TYPE_INTEGER,
                description='종료 인덱스 (기본값: 100)',
                default=100
            ),
        }
    ),
    responses={
        201: "동기화 성공",
        400: "잘못된 요청",
        500: "서버 오류"
    },
    tags=['서울시 API 연동']
)
@api_view(['POST'])
def sync_seoul_api_data(request):
    try:
        region_id = request.data.get('region_id')
        service_name = request.data.get('service_name')
        api_key = request.data.get('api_key')
        start_idx = request.data.get('start_idx', 1)
        end_idx = request.data.get('end_idx', 100)

        if not region_id or not service_name:
            return Response(
                {'error': '지역 ID와 서비스명이 필요합니다.'},
                status=status.HTTP_400_BAD_REQUEST
            )

        api_service = SeoulAPIService(api_key)

        api_data = api_service.fetch_documents_from_api(
            service_name=service_name,
            start_idx=start_idx,
            end_idx=end_idx
        )

        if not api_data:
            return Response(
                {'message': 'API에서 데이터를 가져오지 못했습니다.',
                 'created_count': 0},
                status=status.HTTP_200_OK
            )

        processed_documents = DocumentDataProcessor.process_seoul_api_data(
            api_data, region_id
        )
        
        # processed_documents에 link_url이 포함되어 있다고 가정
        # 이제 이미지 추출 로직을 추가합니다.
        for doc in processed_documents:
            link_url = doc.get('link_url') # link_url 필드 추가 후 사용 가능
            if link_url:
                image_url = fetch_first_image_enhanced(link_url)
                if image_url:
                    doc['image_url'] = image_url
        
        created_documents = SeoulDocumentService.bulk_create_documents_from_seoul_api(
            processed_documents
        )

        return Response({
            'message': f'서울시 API에서 {len(created_documents)}개의 공문을 성공적으로 동기화했습니다.',
            'created_count': len(created_documents),
            'total_fetched': len(api_data),
            'documents': DocumentListSerializer(created_documents, many=True).data[:10]
        }, status=status.HTTP_201_CREATED)

    except Exception as e:
        logger.error(f"Seoul API sync error: {e}")
        return Response(
            {'error': f'동기화 중 오류가 발생했습니다: {str(e)}'},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@swagger_auto_schema(
    method='post',
    operation_summary="API 데이터 일괄 저장 (기존 방식)",
    operation_description="외부 API에서 가져온 공문 데이터를 일괄로 저장합니다.",
    request_body=openapi.Schema(
        type=openapi.TYPE_OBJECT,
        required=['region_id', 'documents'],
        properties={
            'region_id': openapi.Schema(type=openapi.TYPE_INTEGER, description='지역 ID'),
            'documents': openapi.Schema(
                type=openapi.TYPE_ARRAY,
                description='공문 데이터 배열',
                items=openapi.Schema(
                    type=openapi.TYPE_OBJECT,
                    properties={
                        'title': openapi.Schema(type=openapi.TYPE_STRING, description='제목'),
                        'content': openapi.Schema(type=openapi.TYPE_STRING, description='내용'),
                        'date': openapi.Schema(type=openapi.TYPE_STRING, format='date-time', description='게시일'),
                        'deadline': openapi.Schema(type=openapi.TYPE_STRING, format='date-time', description='마감일 (참여형만)'),
                        'category': openapi.Schema(type=openapi.TYPE_STRING, description='카테고리'),
                        'department': openapi.Schema(type=openapi.TYPE_STRING, description='부서명'),
                    }
                )
            )
        }
    ),
    responses={201: "저장 성공", 400: "잘못된 요청"},
    tags=['공문 저장']
)
@api_view(['POST'])
def save_documents_from_api(request):
    try:
        region_id = request.data.get('region_id')
        raw_documents = request.data.get('documents', [])
        
        if not region_id:
            return Response(
                {'error': '지역 ID가 필요합니다.'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        processed_documents = []
        for raw_doc in raw_documents:
            processed_doc = DocumentDataProcessor.process_api_data(raw_doc, region_id)
            processed_documents.append(processed_doc)
        
        created_documents = DocumentService.bulk_create_documents(processed_documents)
        
        return Response({
            'message': f'{len(created_documents)}개의 공문이 저장되었습니다.',
            'created_count': len(created_documents),
            'documents': DocumentListSerializer(created_documents, many=True).data
        }, status=status.HTTP_201_CREATED)
        
    except Exception as e:
        logger.error(f"Error saving documents: {e}")
        return Response(
            {'error': str(e)}, 
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )


@swagger_auto_schema(
    method='get',
    operation_summary="서울시 API 서비스 상태 확인",
    operation_description="서울시 OpenAPI 서비스 연결 상태를 확인합니다.",
    manual_parameters=[
        openapi.Parameter(
            'service_name', openapi.IN_QUERY,
            description="확인할 서비스명",
            type=openapi.TYPE_STRING,
            required=True
        )
    ],
    responses={200: "서비스 정상", 400: "서비스 오류"},
    tags=['서울시 API 연동']
)
@api_view(['GET'])
def check_seoul_api_status(request):
    try:
        service_name = request.query_params.get('service_name')
        
        if not service_name:
            return Response(
                {'error': '서비스명이 필요합니다.'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        api_service = SeoulAPIService()
        
        test_data = api_service.fetch_documents_from_api(
            service_name=service_name,
            start_idx=1,
            end_idx=1
        )
        
        if test_data:
            return Response({
                'status': 'success',
                'message': f'{service_name} 서비스가 정상 작동합니다.',
                'service_name': service_name,
                'sample_data_count': len(test_data)
            }, status=status.HTTP_200_OK)
        else:
            return Response({
                'status': 'warning',
                'message': f'{service_name} 서비스에서 데이터를 가져올 수 없습니다.',
                'service_name': service_name
            }, status=status.HTTP_200_OK)
            
    except Exception as e:
        logger.error(f"Seoul API status check error: {e}")
        return Response({
            'status': 'error',
            'message': f'서비스 상태 확인 중 오류가 발생했습니다: {str(e)}',
            'service_name': service_name
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@swagger_auto_schema(
    method='get',
    operation_summary="관심 지역 최근 소식 (최신순 3개)",
    operation_description="""
    기능명세서: "설정된 지역의 새로운 소식을 관심 분야와 관계 없이 최신순으로 3개 노출"
    """,
    manual_parameters=[
        openapi.Parameter(
            'region_id', openapi.IN_PATH,
            description="관심 지역 ID",
            type=openapi.TYPE_INTEGER,
            required=True
        )
    ],
    responses={200: DocumentListSerializer(many=True)},
    tags=['공문 조회']
)
@api_view(['GET'])
def get_recent_region_news(request, region_id):
    try:
        # 해당 지역의 최신 공문 3개
        documents = Document.objects.filter(
            region_id=region_id,
            is_active=True
        ).order_by('-pub_date')[:3]
        
        serializer = DocumentListSerializer(documents, many=True)
        
        return Response({
            'region_id': region_id,
            'recent_news': serializer.data,
            'count': documents.count()
        })
        
    except Exception as e:
        return Response(
            {'error': str(e)}, 
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )


@swagger_auto_schema(
    method='get',
    operation_summary="관심 분야 최근 알림 (최신순 3개)",
    operation_description="""
    기능명세서: "사용자가 관심 분야로 설정한 카테고리의 공문 최신순으로 3개 노출"
    """,
    manual_parameters=[
        openapi.Parameter(
            'category_ids', openapi.IN_QUERY,
            description="관심 카테고리 ID들 (쉼표로 구분: 1,2,3)",
            type=openapi.TYPE_STRING,
            required=True
        )
    ],
    responses={200: DocumentListSerializer(many=True)},
    tags=['공문 조회']
)
@api_view(['GET'])
def get_recent_category_alerts(request):
    try:
        category_ids = request.query_params.get('category_ids', '').split(',')
        
        if not category_ids or category_ids == ['']:
            return Response(
                {'error': '관심 카테고리 ID가 필요합니다.'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # 관심 카테고리의 최신 공문 3개
        documents = Document.objects.filter(
            categories__id__in=category_ids,
            is_active=True
        ).distinct().order_by('-pub_date')[:3]
        
        serializer = DocumentListSerializer(documents, many=True)
        
        return Response({
            'category_ids': category_ids,
            'recent_alerts': serializer.data,
            'count': documents.count()
        })
        
    except Exception as e:
        return Response(
            {'error': str(e)}, 
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

class DocumentDetailView(generics.RetrieveAPIView):
    queryset = Document.objects.filter(is_active=True)
    serializer_class = DocumentDetailWithSimilarSerializer

    @swagger_auto_schema(
        operation_summary="공문 상세 조회 및 유사 공문 추천",
        operation_description="특정 공문의 상세 정보를 조회하고, 유사한 공문 목록을 함께 추천합니다.",
        responses={
            200: DocumentDetailWithSimilarSerializer(),
            404: "공문을 찾을 수 없습니다."
        },
        tags=['공문 조회']
    )
    def get(self, request, *args, **kwargs):
        instance = self.get_object()
        
        user_for_session = get_current_user()
        
        chatbot_session_id = None
        
        if user_for_session:
            try:
                chatbot_session, created = ChatbotSession.objects.get_or_create(
                    document=instance,
                    defaults={'user': user_for_session}
                )
                chatbot_session_id = chatbot_session.id
                if created:
                    print(f"--- Document ID {instance.id}: 새로운 챗봇 세션 생성 (ID: {chatbot_session_id}) ---")
                else:
                    print(f"--- Document ID {instance.id}: 기존 챗봇 세션 사용 (ID: {chatbot_session_id}) ---")
            except Exception as e:
                print(f"--- 챗봇 세션 생성 중 오류 발생: {e} ---")
        else:
            print("--- 유효한 사용자 객체를 찾을 수 없어 챗봇 세션을 생성하지 않습니다. ---")

        # 챗봇 세션 id 전달
        serializer_context = self.get_serializer_context()
        serializer_context['chatbot_session_id'] = chatbot_session.id
        
        # 캐싱된 데이터 사용 (summary가 존재하면)
        if instance.summary:
            print(f"--- Document ID {instance.id}: 캐싱된 요약 데이터 사용 ---")
            analyzed_data = {
                "title": instance.doc_title,
                "keywords": comma_separated_str_to_list(instance.keywords),
                "related_departments": comma_separated_str_to_list(instance.related_departments),
                "purpose": instance.purpose,
                "summary": instance.summary
            }
        else:
            # summary가 없으면 Gemini API 호출하여 분석
            print(f"--- Document ID {instance.id}: Gemini API 호출하여 분석 ---")
            document_content = instance.doc_content
            gemini_result = analyze_document_content(document_content)

            if gemini_result:
                analyzed_data = gemini_result
                
                instance.keywords = list_to_comma_separated_str(gemini_result.get('keywords', []))
                instance.related_departments = list_to_comma_separated_str(gemini_result.get('related_departments', []))
                instance.purpose = gemini_result.get('purpose', '')
                instance.summary = gemini_result.get('summary', '') 
                
                try:
                    instance.save(update_fields=['keywords', 'related_departments', 'purpose', 'summary'])
                    print(f"--- Document ID {instance.id}: 분석 결과 DB에 저장 완료 (요약 포함) ---")
                except Exception as e:
                    print(f"--- Document ID {instance.id}: 분석 결과 DB 저장 중 오류 발생: {e} ---")
            else:
                print(f"--- Document ID {instance.id}: Gemini 분석 실패. 유사 공문 추천 및 요약 불가. ---")
                analyzed_data = {}

        similar_docs_data = []
        if analyzed_data and 'keywords' in analyzed_data:
            print(f"--- Document ID {instance.id}: 유사 공문 검색 시작 ---")
            similar_docs_data = search_similar_documents_in_db(analyzed_data, current_doc_id=instance.id, limit=3)
            print(f"--- Document ID {instance.id}: 최종 유사 공문 검색 결과: {len(similar_docs_data)}개 ---")
        
        serializer = self.get_serializer(instance, context=serializer_context)
        response_data = serializer.data
        response_data['similar_documents'] = similar_docs_data

        return Response(response_data, status=status.HTTP_200_OK)
    
    def get_serializer_context(self):
        context = super().get_serializer_context()
        context['request'] = self.request
        return context


@swagger_auto_schema(
    method='get',
    operation_summary="마감일이 가까운 스크랩 공문 목록 조회",
    operation_description="""
    현재 사용자가 스크랩한 공문 중 마감일이 가까운 순으로 최대 5개를 조회합니다.
    **dead_date가 오늘 이후인 문서만 포함됩니다.**
    """,
    tags=['공문']
)
@api_view(['GET'])
def upcoming_deadlines_api(request):
    try:
        user = get_current_user()
        
        now = timezone.now()
        
        upcoming_scraps = DocumentScrap.objects.filter(
            user=user,
            document__dead_date__gt=now
        ).select_related('document').order_by('document__dead_date')[:5]
        
        serializer = DocumentScrapUpcomingSerializer(upcoming_scraps, many=True)
        
        return Response(
            create_success_response(
                "마감일이 가까운 스크랩 공문 목록 조회 성공",
                {"count": len(serializer.data), "results": serializer.data}
            ),
            status=status.HTTP_200_OK
        )

    except Exception as error:
        return Response(
            create_error_response(f"마감일이 가까운 스크랩 공문 목록 조회 실패: {str(error)}"),
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )


@swagger_auto_schema(
    method='get',
    operation_summary="모든 공문 목록 검색 및 필터링",
    operation_description="""
    다양한 쿼리 파라미터를 사용하여 모든 공문을 검색, 필터링, 정렬합니다.
    주의: 이 API는 스크랩 여부와 상관없이 모든 공문을 조회합니다.
    """,
    tags=['공문'],
    manual_parameters=[
        openapi.Parameter('q', in_=openapi.IN_QUERY, type=openapi.TYPE_STRING, description="검색어 (제목, 내용, 키워드, 요약)"),
        openapi.Parameter('doc_type', in_=openapi.IN_QUERY, type=openapi.TYPE_STRING, description="공문 타입", enum=[choice.value for choice in DocumentTypeChoices]),
        openapi.Parameter('region_ids', in_=openapi.IN_QUERY, type=openapi.TYPE_STRING, description="쉼표로 구분된 지역 ID 목록 (예: '1,2,3')"),
        openapi.Parameter('category_ids', in_=openapi.IN_QUERY, type=openapi.TYPE_STRING, description="쉼표로 구분된 카테고리 ID 목록 (예: '1,2,3')"),
        openapi.Parameter('order', in_=openapi.IN_QUERY, type=openapi.TYPE_STRING, description="정렬 순서 ('latest' 또는 'oldest'), 기본값 latest", enum=['latest', 'oldest']),
        openapi.Parameter('page', in_=openapi.IN_QUERY, type=openapi.TYPE_INTEGER, description="페이지 번호, 기본값 1"),
        openapi.Parameter('page_size', in_=openapi.IN_QUERY, type=openapi.TYPE_INTEGER, description="페이지 크기, 기본값 10"),
    ],
)
@api_view(['GET'])
def all_documents_search_api(request):
    try:
        q = request.query_params.get('q')
        doc_type = request.query_params.get('doc_type')
        region_ids_str = request.query_params.get('region_ids')
        category_ids_str = request.query_params.get('category_ids')
        order = request.query_params.get('order', 'latest')
        page = int(request.query_params.get('page', 1))
        page_size = int(request.query_params.get('page_size', 10))

        documents = Document.objects.all()
        
        filters = Q()
        if q:
            filters &= (
                Q(doc_title__icontains=q) |
                Q(doc_content__icontains=q) |
                Q(keywords__icontains=q) |
                Q(summary__icontains=q)
            )

        if doc_type:
            filters &= Q(doc_type=doc_type)
        
        if region_ids_str:
            region_ids = [int(id) for id in region_ids_str.split(',') if id]
            if region_ids:
                filters &= Q(region_id__in=region_ids)

        if category_ids_str:
            category_ids = [int(id) for id in category_ids_str.split(',') if id]
            if category_ids:
                filters &= Q(categories__id__in=category_ids)
        
        filtered_documents = documents.filter(filters).distinct()

        if order == 'oldest':
            filtered_documents = filtered_documents.order_by('pub_date')
        else:
            filtered_documents = filtered_documents.order_by('-pub_date')

        offset = (page - 1) * page_size
        paginated_documents = filtered_documents[offset:offset + page_size]
        
        serializer = DocumentSerializer(paginated_documents, many=True)

        return Response(
            create_success_response(
                "공문 검색 성공",
                {
                    "count": filtered_documents.count(),
                    "results": serializer.data
                }
            ),
            status=status.HTTP_200_OK
        )

    except Exception as error:
        return Response(
            create_error_response(f"공문 검색 실패: {str(error)}"),
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )
