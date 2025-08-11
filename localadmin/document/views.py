from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django.db.models import Q
from django.utils import timezone
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi

from .models import Document, DocumentTypeChoices
from .services import DocumentService, DocumentDataProcessor
from .serializers import DocumentSerializer, DocumentListSerializer


# 공통 파라미터 정의
region_param = openapi.Parameter(
    'region_id', openapi.IN_QUERY, 
    description="지역 ID (복수 선택 가능, 예: 1,2,3)", 
    type=openapi.TYPE_STRING
)

doc_type_param = openapi.Parameter(
    'doc_type', openapi.IN_QUERY,
    description="문서 타입",
    type=openapi.TYPE_STRING,
    enum=['PARTICIPATION', 'NOTICE', 'REPORT', 'ANNOUNCEMENT']
)

category_param = openapi.Parameter(
    'category', openapi.IN_QUERY,
    description="카테고리 ID (복수 선택 가능)",
    type=openapi.TYPE_STRING
)

search_param = openapi.Parameter(
    'search', openapi.IN_QUERY,
    description="제목/내용 검색 키워드",
    type=openapi.TYPE_STRING
)

start_date_param = openapi.Parameter(
    'start_date', openapi.IN_QUERY,
    description="시작 날짜 (YYYY-MM-DDTHH:MM:SS)",
    type=openapi.TYPE_STRING,
    format='date-time'
)

end_date_param = openapi.Parameter(
    'end_date', openapi.IN_QUERY,
    description="종료 날짜 (YYYY-MM-DDTHH:MM:SS)",
    type=openapi.TYPE_STRING,
    format='date-time'
)

has_deadline_param = openapi.Parameter(
    'has_deadline', openapi.IN_QUERY,
    description="마감일이 있는 문서만 조회 (true/false)",
    type=openapi.TYPE_BOOLEAN
)


class DocumentListView(generics.ListAPIView):
    """공문 목록 조회 (필터링 지원)"""
    serializer_class = DocumentListSerializer
    
    @swagger_auto_schema(
        operation_summary="공문 목록 조회",
        operation_description="""
        공문 목록을 조회합니다. 다양한 필터링 옵션을 지원합니다.
        
        ### 필터링 예시
        - 특정 지역: ?region_id=1,2
        - 참여형 공문: ?doc_type=PARTICIPATION
        - 키워드 검색: ?search=모집
        - 날짜 범위: ?start_date=2024-01-01&end_date=2024-12-31
        - 마감일 있는 문서: ?has_deadline=true
        """,
        manual_parameters=[
            region_param, doc_type_param, category_param, 
            search_param, start_date_param, end_date_param, has_deadline_param
        ],
        responses={
            200: DocumentListSerializer(many=True),
            400: "잘못된 요청",
            500: "서버 오류"
        },
        tags=['공문 조회']
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)
    
    def get_queryset(self):
        queryset = Document.objects.filter(is_active=True).select_related().prefetch_related('categories')
        
        # 필터링 로직 (이전과 동일)
        region_ids = self.request.query_params.getlist('region_id')
        doc_types = self.request.query_params.getlist('doc_type')
        category_ids = self.request.query_params.getlist('category')
        start_date = self.request.query_params.get('start_date')
        end_date = self.request.query_params.get('end_date')
        search = self.request.query_params.get('search')
        has_deadline = self.request.query_params.get('has_deadline')
        
        if region_ids:
            queryset = queryset.filter(region_id__in=region_ids)
        
        if doc_types:
            queryset = queryset.filter(doc_type__in=doc_types)
        
        if category_ids:
            queryset = queryset.filter(categories__id__in=category_ids).distinct()
        
        if start_date:
            try:
                start_date = timezone.datetime.fromisoformat(start_date)
                queryset = queryset.filter(pub_date__gte=start_date)
            except ValueError:
                pass
        
        if end_date:
            try:
                end_date = timezone.datetime.fromisoformat(end_date)
                queryset = queryset.filter(pub_date__lte=end_date)
            except ValueError:
                pass
        
        if search:
            queryset = queryset.filter(
                Q(doc_title__icontains=search) | 
                Q(doc_content__icontains=search)
            )
        
        if has_deadline == 'true':
            queryset = queryset.filter(dead_date__isnull=False)
        
        return queryset.order_by('-pub_date')


class DocumentDetailView(generics.RetrieveAPIView):
    """공문 상세 조회"""
    queryset = Document.objects.filter(is_active=True)
    serializer_class = DocumentSerializer
    
    @swagger_auto_schema(
        operation_summary="공문 상세 조회",
        operation_description="특정 공문의 상세 정보를 조회합니다.",
        responses={
            200: DocumentSerializer(),
            404: "공문을 찾을 수 없습니다.",
            500: "서버 오류"
        },
        tags=['공문 조회']
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)


@swagger_auto_schema(
    method='post',
    operation_summary="API 데이터 일괄 저장",
    operation_description="""
    외부 API에서 가져온 공문 데이터를 일괄로 저장합니다.
    데이터는 자동으로 처리되어 모델 형식에 맞게 변환됩니다.
    """,
    request_body=openapi.Schema(
        type=openapi.TYPE_OBJECT,
        required=['region_id', 'documents'],
        properties={
            'region_id': openapi.Schema(
                type=openapi.TYPE_INTEGER,
                description='지역 ID'
            ),
            'documents': openapi.Schema(
                type=openapi.TYPE_ARRAY,
                description='공문 데이터 배열',
                items=openapi.Schema(
                    type=openapi.TYPE_OBJECT,
                    properties={
                        'title': openapi.Schema(type=openapi.TYPE_STRING, description='제목'),
                        'content': openapi.Schema(type=openapi.TYPE_STRING, description='내용'),
                        'date': openapi.Schema(type=openapi.TYPE_STRING, format='date-time', description='게시일'),
                        'deadline': openapi.Schema(type=openapi.TYPE_STRING, format='date-time', description='마감일'),
                        'category': openapi.Schema(type=openapi.TYPE_STRING, description='카테고리'),
                        'department': openapi.Schema(type=openapi.TYPE_STRING, description='부서명'),
                    }
                )
            )
        }
    ),
    responses={
        201: openapi.Schema(
            type=openapi.TYPE_OBJECT,
            properties={
                'message': openapi.Schema(type=openapi.TYPE_STRING),
                'created_count': openapi.Schema(type=openapi.TYPE_INTEGER),
                'documents': openapi.Schema(type=openapi.TYPE_ARRAY, items=openapi.Schema(type=openapi.TYPE_OBJECT))
            }
        ),
        400: "잘못된 요청",
        500: "서버 오류"
    },
    tags=['공문 저장']
)
@api_view(['POST'])
def save_documents_from_api(request):
    """API에서 가져온 공문 데이터 저장"""
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
            'documents': DocumentSerializer(created_documents, many=True).data
        }, status=status.HTTP_201_CREATED)
        
    except Exception as e:
        return Response(
            {'error': str(e)}, 
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )


@swagger_auto_schema(
    method='post',
    operation_summary="단일 공문 저장",
    operation_description="단일 공문을 직접 저장합니다.",
    request_body=openapi.Schema(
        type=openapi.TYPE_OBJECT,
        required=['doc_title', 'pub_date', 'region_id'],
        properties={
            'doc_title': openapi.Schema(type=openapi.TYPE_STRING, description='제목'),
            'doc_content': openapi.Schema(type=openapi.TYPE_STRING, description='내용'),
            'doc_type': openapi.Schema(
                type=openapi.TYPE_STRING, 
                description='문서 타입',
                enum=['PARTICIPATION', 'NOTICE', 'REPORT', 'ANNOUNCEMENT']
            ),
            'pub_date': openapi.Schema(type=openapi.TYPE_STRING, format='date-time', description='게시일'),
            'dead_date': openapi.Schema(type=openapi.TYPE_STRING, format='date-time', description='마감일'),
            'region_id': openapi.Schema(type=openapi.TYPE_INTEGER, description='지역 ID'),
            'categories': openapi.Schema(
                type=openapi.TYPE_ARRAY,
                description='카테고리 ID 배열',
                items=openapi.Schema(type=openapi.TYPE_INTEGER)
            ),
            'image_url': openapi.Schema(type=openapi.TYPE_STRING, description='이미지 URL')
        }
    ),
    responses={
        201: DocumentSerializer(),
        400: "잘못된 요청",
        500: "서버 오류"
    },
    tags=['공문 저장']
)
@api_view(['POST'])
def save_single_document(request):
    """단일 공문 저장"""
    try:
        document = DocumentService.create_document(request.data)
        return Response({
            'message': '공문이 저장되었습니다.',
            'document': DocumentSerializer(document).data
        }, status=status.HTTP_201_CREATED)
        
    except Exception as e:
        return Response(
            {'error': str(e)}, 
            status=status.HTTP_400_BAD_REQUEST
        )


@swagger_auto_schema(
    method='get',
    operation_summary="지역별 공문 조회",
    operation_description="특정 지역의 공문 목록을 조회합니다. (페이지네이션 지원)",
    manual_parameters=[
        openapi.Parameter(
            'page', openapi.IN_QUERY,
            description="페이지 번호",
            type=openapi.TYPE_INTEGER
        )
    ],
    responses={
        200: openapi.Schema(
            type=openapi.TYPE_OBJECT,
            properties={
                'documents': openapi.Schema(type=openapi.TYPE_ARRAY, items=openapi.Schema(type=openapi.TYPE_OBJECT)),
                'total_count': openapi.Schema(type=openapi.TYPE_INTEGER),
                'total_pages': openapi.Schema(type=openapi.TYPE_INTEGER),
                'current_page': openapi.Schema(type=openapi.TYPE_INTEGER),
                'has_next': openapi.Schema(type=openapi.TYPE_BOOLEAN),
                'has_previous': openapi.Schema(type=openapi.TYPE_BOOLEAN),
            }
        ),
        404: "지역을 찾을 수 없습니다.",
        500: "서버 오류"
    },
    tags=['공문 조회']
)
@api_view(['GET'])
def get_documents_by_region(request, region_id):
    """특정 지역의 공문 목록 조회"""
    try:
        documents = Document.objects.filter(
            region_id=region_id, 
            is_active=True
        ).prefetch_related('categories').order_by('-pub_date')
        
        from django.core.paginator import Paginator
        page = request.GET.get('page', 1)
        paginator = Paginator(documents, 20)
        page_documents = paginator.get_page(page)
        
        serializer = DocumentListSerializer(page_documents, many=True)
        
        return Response({
            'documents': serializer.data,
            'total_count': paginator.count,
            'total_pages': paginator.num_pages,
            'current_page': int(page),
            'has_next': page_documents.has_next(),
            'has_previous': page_documents.has_previous(),
        })
        
    except Exception as e:
        return Response(
            {'error': str(e)}, 
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )


@swagger_auto_schema(
    method='get',
    operation_summary="긴급 공문 조회",
    operation_description="마감일이 7일 이내인 참여형 공문을 조회합니다.",
    responses={
        200: openapi.Schema(
            type=openapi.TYPE_OBJECT,
            properties={
                'urgent_documents': openapi.Schema(type=openapi.TYPE_ARRAY, items=openapi.Schema(type=openapi.TYPE_OBJECT)),
                'count': openapi.Schema(type=openapi.TYPE_INTEGER)
            }
        ),
        500: "서버 오류"
    },
    tags=['공문 조회']
)
@api_view(['GET'])
def get_urgent_documents(request):
    """마감일이 임박한 참여형 공문 조회"""
    try:
        from datetime import timedelta
        
        today = timezone.now()
        urgent_deadline = today + timedelta(days=7)
        
        documents = Document.objects.filter(
            doc_type=DocumentTypeChoices.PARTICIPATION,
            dead_date__isnull=False,
            dead_date__gte=today,
            dead_date__lte=urgent_deadline,
            is_active=True
        ).prefetch_related('categories').order_by('dead_date')
        
        serializer = DocumentListSerializer(documents, many=True)
        
        return Response({
            'urgent_documents': serializer.data,
            'count': documents.count()
        })
        
    except Exception as e:
        return Response(
            {'error': str(e)}, 
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )