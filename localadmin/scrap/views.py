from rest_framework                import status
from rest_framework.decorators     import api_view, permission_classes
from rest_framework.permissions    import AllowAny
from rest_framework.response       import Response
from django.db                     import transaction, IntegrityError
from drf_yasg.utils                import swagger_auto_schema
from drf_yasg                      import openapi

from .models                       import ChatbotScrap, DocumentScrap
from .serializers                  import (
    # 챗봇 스크랩 시리얼라이저
    ChatbotScrapSerializer,
    ChatbotScrapCreateSerializer,
    ChatbotScrapListSerializer,
    
    # 공문 스크랩 시리얼라이저들
    DocumentScrapSerializer,
    DocumentScrapCreateSerializer,
    DocumentScrapListSerializer
)
from document.models               import Document, DocumentTypeChoices
from chatbot.services              import GeminiChatService
from user.utils                    import (
    get_current_user,
    create_success_response,
    create_error_response
)


# 챗봇 스크랩

@swagger_auto_schema(
    method='get',
    operation_summary="챗봇 스크랩 목록 조회",
    operation_description="""
    현재 사용자의 **챗봇 스크랩 목록**을 조회합니다.

    **쿼리 파라미터:**
    - **category_id** (string, 선택) : 쉼표로 구분된 카테고리 PK 목록(예: '1,2,3')
    - **order** (string, 선택) : 정렬 순서 ("latest" 또는 "oldest"), 기본값 latest
    - **page** (int, 선택) : 페이지 번호, 기본값 1
    - **page_size** (int, 선택) : 페이지 크기, 기본값 10

    **응답 데이터:**
    - **count** (int) : 총 스크랩 개수
    - **results** (array) : 스크랩 리스트
        - **id** (int) : 스크랩 ID
        - **summary** (string) : AI 응답 요약
        - **created_at** (string) : 생성 시각
        - **user_message_preview** (string) : 사용자 메시지 미리보기
        - **ai_message_preview** (string) : AI 메시지 요약/미리보기
        - **categories** (array) : 카테고리 배열 [{id, category_name}]
        - **session_info** (object) : 세션 정보 {id, title}
    """,
    manual_parameters=[
        openapi.Parameter(
            'category_id', openapi.IN_QUERY,
            description="쉼표로 구분된 카테고리 PK 목록(예: 1,2,3)",
            type=openapi.TYPE_STRING,
            required=False
        ),
        openapi.Parameter(
            'order', openapi.IN_QUERY,
            description="정렬 순서",
            type=openapi.TYPE_STRING,
            enum=['latest', 'oldest'],
            default='latest'
        ),
        openapi.Parameter(
            'page', openapi.IN_QUERY,
            description="페이지 번호",
            type=openapi.TYPE_INTEGER,
            default=1
        ),
        openapi.Parameter(
            'page_size', openapi.IN_QUERY,
            description="페이지 크기",
            type=openapi.TYPE_INTEGER,
            default=10
        )
    ],
    tags=['챗봇 스크랩']
)
@swagger_auto_schema(
    method='post',
    operation_summary="챗봇 스크랩 생성",
    operation_description="""
    챗봇 대화를 스크랩합니다.

    **요청 바디:**
    - **user_message_id** (int, 필수) : 사용자 메시지 ID
    - **ai_message_id** (int, 필수) : AI 메시지 ID

    **응답 데이터:**
    - **id** (int) : 스크랩 ID
    - **summary** (string) : AI 응답 요약
    - **created_at** (string) : 스크랩 생성 시각 (YYYY-MM-DD HH:MM:SS)
    - **user** (int) : 사용자 ID
    - **user_name** (string) : 사용자 이름
    - **chatbot_session** (int) : 세션 ID
    - **session_title** (string) : 세션 제목
    - **user_message** (int) : 사용자 메시지 ID
    - **user_message_content** (string) : 사용자 메시지 내용
    - **ai_message** (int) : AI 메시지 ID
    - **ai_message_content** (string) : AI 메시지 내용
    - **categories** (array) : 카테고리 배열 [{id, category_name}]

    **주의:**
    - 동일한 (user_message, ai_message) 조합은 중복 스크랩 불가
    """,
    request_body=ChatbotScrapCreateSerializer,
    responses={
        201: openapi.Response(
            description="스크랩 생성 성공",
            examples={
                "application/json": {
                    "success": True,
                    "message": "스크랩 생성 성공",
                    "data": {
                        "id": 1,
                        "summary": "김덕사님은 아직 만 40세 미만으로 ... 추천합니다.",
                        "created_at": "2025-08-10 01:19:28",
                        "user": 1,
                        "user_name": "김덕사",
                        "chatbot_session": 1,
                        "session_title": "서울시, 중장년 기술창업...",
                        "user_message": 3,
                        "user_message_content": "나도 포함 돼?",
                        "ai_message": 4,
                        "ai_message_content": "안녕하세요, 김덕사님!...",
                        "categories": [
                            {"id": 1, "category_name": "교통"},
                            {"id": 2, "category_name": "복지"}
                        ]
                    }
                }
            }
        )
    },
    tags=['챗봇 스크랩']
)
@api_view(['GET', 'POST'])
@permission_classes([AllowAny])
def scrap_list_create(request):
    """챗봇 스크랩 목록 조회 및 생성"""
    if request.method == 'GET':
        return handle_scrap_list(request)
    elif request.method == 'POST':
        return handle_scrap_create(request)

def handle_scrap_list(request):
    try:
        user      = get_current_user()
        queryset  = ChatbotScrap.objects.filter(user=user).prefetch_related(
            'categories',
            'chatbot_session',
            'user_message',
            'ai_message'
        )

        category_ids_param = request.GET.get('category_id')
        if category_ids_param:
            category_id_list = [
                int(cid.strip())
                for cid in category_ids_param.split(',')
                if cid.strip().isdigit()
            ]
            if category_id_list:
                queryset = queryset.filter(categories__id__in=category_id_list).distinct()

        order = request.GET.get('order', 'latest')
        if order == 'oldest':
            queryset = queryset.order_by('created_at')
        else:
            queryset = queryset.order_by('-created_at')

        page      = int(request.GET.get('page', 1))
        page_size = int(request.GET.get('page_size', 10))
        start     = (page - 1) * page_size
        end       = start + page_size

        scraps = queryset[start:end]
        total  = queryset.count()

        if total == 0:
            return Response(
                create_success_response(
                    "스크랩이 없습니다",
                    {"count": 0, "results": []}
                ),
                status=status.HTTP_200_OK
            )

        serializer = ChatbotScrapListSerializer(scraps, many=True)
        return Response(
            create_success_response(
                "스크랩 목록 조회 성공",
                {"count": total, "results": serializer.data}
            ),
            status=status.HTTP_200_OK
        )

    except Exception as e:
        return Response(
            create_error_response(f"스크랩 목록 조회 실패: {str(e)}"),
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@transaction.atomic
def handle_scrap_create(request):
    try:
        user       = get_current_user()
        serializer = ChatbotScrapCreateSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(
                create_error_response("스크랩 생성 실패", serializer.errors),
                status=status.HTTP_400_BAD_REQUEST
            )
        validated_data = serializer.validated_data

        try:
            chat_service = GeminiChatService()
            summary      = chat_service.summarize_response(
                validated_data['ai_message'].content,
                max_length=100
            )
        except Exception:
            content = validated_data['ai_message'].content
            summary = content[:97] + "..." if len(content) > 100 else content

        try:
            scrap = ChatbotScrap.objects.create(
                user            = user,
                chatbot_session = validated_data['chatbot_session'],
                user_message    = validated_data['user_message'],
                ai_message      = validated_data['ai_message'],
                summary         = summary
            )
            # 다중 카테고리 연결 (공문에서)
            document = validated_data['chatbot_session'].document
            scrap.categories.set(document.categories.all())

            scrap_serializer = ChatbotScrapSerializer(scrap)
            return Response(
                create_success_response("스크랩 생성 성공", scrap_serializer.data),
                status=status.HTTP_201_CREATED
            )
        except IntegrityError:
            return Response(
                create_error_response("이미 스크랩된 메시지입니다."),
                status=status.HTTP_409_CONFLICT
            )

    except Exception as e:
        return Response(
            create_error_response(f"스크랩 생성 실패: {str(e)}"),
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@swagger_auto_schema(
    method='get',
    operation_summary="챗봇 스크랩 상세 조회",
    operation_description="""
    특정 챗봇 스크랩의 상세 정보를 조회합니다.

    **응답 데이터:**
    - **id** (int) : 스크랩 ID
    - **summary** (string) : AI 응답 요약
    - **created_at** (string) : 생성 시각
    - **user** (int) : 사용자 ID
    - **user_name** (string) : 사용자 이름
    - **chatbot_session** (int) : 세션 ID
    - **session_title** (string) : 세션 제목
    - **user_message** (int) : 사용자 메시지 ID
    - **user_message_content** (string) : 사용자 메시지 내용
    - **ai_message** (int) : AI 메시지 ID
    - **ai_message_content** (string) : AI 메시지 내용
    - **categories** (array) : 카테고리 배열 [{id, category_name}]
    """,
    responses={
        200: openapi.Response(
            description="스크랩 조회 성공",
            examples={
                "application/json": {
                    "success": True,
                    "message": "스크랩 조회 성공",
                    "data": {
                        "id": 1,
                        "summary": "...",
                        "created_at": "2025-08-10 01:19:28",
                        "user": 1,
                        "user_name": "김덕사",
                        "chatbot_session": 1,
                        "session_title": "서울시, 중장년...",
                        "user_message": 3,
                        "user_message_content": "나도 포함 돼?",
                        "ai_message": 4,
                        "ai_message_content": "안녕하세요, 김덕사님! ...",
                        "categories": [
                            {"id": 1, "category_name": "교통"},
                            {"id": 2, "category_name": "복지"}
                        ]
                    }
                }
            }
        )
    },
    tags=['챗봇 스크랩']
)
@swagger_auto_schema(
    method='delete',
    operation_summary="챗봇 스크랩 삭제",
    operation_description="특정 챗봇 스크랩을 삭제합니다.",
    tags=['챗봇 스크랩']
)
@api_view(['GET', 'DELETE'])
@permission_classes([AllowAny])
def scrap_detail(request, scrap_id):
    try:
        user  = get_current_user()
        scrap = ChatbotScrap.objects.filter(
            id   = scrap_id,
            user = user
        ).first()

        if not scrap:
            return Response(
                create_error_response("스크랩을 찾을 수 없습니다."),
                status=status.HTTP_404_NOT_FOUND
            )

        if request.method == 'GET':
            serializer = ChatbotScrapSerializer(scrap)
            return Response(
                create_success_response("스크랩 조회 성공", serializer.data),
                status=status.HTTP_200_OK
            )

        elif request.method == 'DELETE':
            scrap.delete()
            return Response(
                create_success_response("스크랩 삭제 성공"),
                status=status.HTTP_200_OK
            )

    except Exception as e:
        return Response(
            create_error_response(f"스크랩 처리 중 오류 발생: {str(e)}"),
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )


# 공문 스크랩

@swagger_auto_schema(
    method='get',
    operation_summary="공문 스크랩 목록 조회",
    operation_description="""
    현재 사용자의 **공문 스크랩 목록**을 조회합니다.
    
    **쿼리 파라미터:**
    - **doc_type** (string, 선택) : 공문 타입 (PARTICIPATION, NOTICE, REPORT, ANNOUNCEMENT)
    - **region_ids** (string, 선택) : 쉼표로 구분된 지역 ID 목록 (예: '1,2,3')
    - **category_ids** (string, 선택) : 쉼표로 구분된 카테고리 ID 목록 (예: '1,2,3')
    - **order** (string, 선택) : 정렬 순서 ("latest" 또는 "oldest"), 기본값 latest
    - **page** (int, 선택) : 페이지 번호, 기본값 1
    - **page_size** (int, 선택) : 페이지 크기, 기본값 10
    
    **주의:**
    - doc_type, region_ids, category_ids는 비워두면 전체를 검색합니다
    """,
    responses={
        200: openapi.Response(
            description="공문 스크랩 목록 조회 성공",
            examples={
                "application/json": {
                    "success": True,
                    "message": "공문 스크랩 목록 조회 성공",
                    "data": {
                        "count": 1,
                        "results": [
                            {
                                "id": 4,
                                "doc_title": "서울시, 중장년 기술창업 지원 강화…입주기업 70% 쿼터제 첫 도입",
                                "doc_type": "PARTICIPATION",
                                "doc_type_display": "참여",
                                "pub_date": "2025-08-08T09:00:00+09:00",
                                "region": {
                                    "id": 1,
                                    "city": "서울특별시",
                                    "district": None,
                                    "full_name": "서울특별시"
                                },
                                "categories": [
                                    {
                                        "id": 1,
                                        "category_name": "교통"
                                    }
                                ],
                                "created_at": "2025-08-11T20:51:31.793230+09:00"
                            }
                        ]
                    }
                }
            }
        )
    },
    manual_parameters=[
        openapi.Parameter(
            'doc_type', openapi.IN_QUERY,
            description="공문 타입 (PARTICIPATION, NOTICE, REPORT, ANNOUNCEMENT)",
            type=openapi.TYPE_STRING,
            enum=['PARTICIPATION', 'NOTICE', 'REPORT', 'ANNOUNCEMENT'],
            required=False
        ),
        openapi.Parameter(
            'region_ids', openapi.IN_QUERY,
            description="쉼표로 구분된 지역 ID 목록 (예: 1,2,3)",
            type=openapi.TYPE_STRING,
            required=False
        ),
        openapi.Parameter(
            'category_ids', openapi.IN_QUERY,
            description="쉼표로 구분된 카테고리 ID 목록 (예: 1,2,3)",
            type=openapi.TYPE_STRING,
            required=False
        ),
        openapi.Parameter(
            'order', openapi.IN_QUERY,
            description="정렬 순서",
            type=openapi.TYPE_STRING,
            enum=['latest', 'oldest'],
            default='latest'
        ),
        openapi.Parameter(
            'page', openapi.IN_QUERY,
            description="페이지 번호",
            type=openapi.TYPE_INTEGER,
            default=1
        ),
        openapi.Parameter(
            'page_size', openapi.IN_QUERY,
            description="페이지 크기",
            type=openapi.TYPE_INTEGER,
            default=10
        )
    ],
    tags=['공문 스크랩']
)
@swagger_auto_schema(
    method='post',
    operation_summary="공문 스크랩 생성",
    operation_description="""
    공문을 스크랩합니다.
    
    **요청 바디:**
    - **document_id** (int, 필수) : 스크랩할 공문 ID
    """,
    request_body=DocumentScrapCreateSerializer,
    responses={
        201: openapi.Response(
            description="공문 스크랩 생성 성공",
            examples={
                "application/json": {
                    "success": True,
                    "message": "공문 스크랩 생성 성공",
                    "data": {
                        "id": 4,
                        "user": 1,
                        "user_name": "김덕사",
                        "document": 1,
                        "doc_title": "서울시, 중장년 기술창업 지원 강화…입주기업 70% 쿼터제 첫 도입",
                        "doc_type": "PARTICIPATION",
                        "doc_type_display": "참여",
                        "pub_date": "2025-08-08T09:00:00+09:00",
                        "region": {
                            "id": 1,
                            "city": "서울특별시",
                            "district": None,
                            "full_name": "서울특별시"
                        },
                        "categories": [
                            {
                                "id": 1,
                                "category_name": "교통"
                            }
                        ],
                        "created_at": "2025-08-11T20:51:31.793230+09:00"
                    }
                }
            }
        )
    },
    tags=['공문 스크랩']
)
@api_view(['GET', 'POST'])
@permission_classes([AllowAny])
def document_scrap_list_create(request):
    """공문 스크랩 목록 조회 및 생성"""
    if request.method == 'GET':
        return handle_document_scrap_list(request)
    elif request.method == 'POST':
        return handle_document_scrap_create(request)


def handle_document_scrap_list(request):
    """공문 스크랩 목록 조회"""
    try:
        user     = get_current_user()
        queryset = DocumentScrap.objects.filter(user=user).select_related(
            'document'
        ).prefetch_related(
            'document__categories'
        )

        # 1차 필터: 공문 타입 (단일 선택)
        doc_type = request.GET.get('doc_type')
        if doc_type and doc_type in dict(DocumentTypeChoices.choices):
            queryset = queryset.filter(document__doc_type=doc_type)

        # 2차 필터: 지역 (다중 선택, OR 조건)
        region_ids_param = request.GET.get('region_ids')
        if region_ids_param:
            region_id_list = [
                int(rid.strip())
                for rid in region_ids_param.split(',')
                if rid.strip().isdigit()
            ]
            if region_id_list:
                queryset = queryset.filter(
                    document__region_id__in=region_id_list
                )

        # 2차 필터: 카테고리 (다중 선택, OR 조건)
        category_ids_param = request.GET.get('category_ids')
        if category_ids_param:
            category_id_list = [
                int(cid.strip())
                for cid in category_ids_param.split(',')
                if cid.strip().isdigit()
            ]
            if category_id_list:
                queryset = queryset.filter(
                    document__categories__id__in=category_id_list
                ).distinct()

        # 정렬
        order = request.GET.get('order', 'latest')
        if order == 'oldest':
            queryset = queryset.order_by('created_at')
        else:
            queryset = queryset.order_by('-created_at')

        # 페이지네이션
        page      = int(request.GET.get('page', 1))
        page_size = int(request.GET.get('page_size', 10))
        start     = (page - 1) * page_size
        end       = start + page_size

        scraps = queryset[start:end]
        total  = queryset.count()

        if total == 0:
            return Response(
                create_success_response(
                    "스크랩된 공문이 없습니다",
                    {"count": 0, "results": []}
                ),
                status=status.HTTP_200_OK
            )

        serializer = DocumentScrapListSerializer(scraps, many=True)
        return Response(
            create_success_response(
                "공문 스크랩 목록 조회 성공",
                {"count": total, "results": serializer.data}
            ),
            status=status.HTTP_200_OK
        )

    except Exception as error:
        return Response(
            create_error_response(f"공문 스크랩 목록 조회 실패: {str(error)}"),
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )


@transaction.atomic
def handle_document_scrap_create(request):
    """공문 스크랩 생성"""
    try:
        user       = get_current_user()
        serializer = DocumentScrapCreateSerializer(data=request.data)
        
        if not serializer.is_valid():
            return Response(
                create_error_response("공문 스크랩 생성 실패", serializer.errors),
                status=status.HTTP_400_BAD_REQUEST
            )
        
        validated_data = serializer.validated_data
        document       = Document.objects.get(id=validated_data['document_id'])

        try:
            scrap = DocumentScrap.objects.create(
                user     = user,
                document = document
            )
            
            scrap_serializer = DocumentScrapSerializer(scrap)
            return Response(
                create_success_response("공문 스크랩 생성 성공", scrap_serializer.data),
                status=status.HTTP_201_CREATED
            )
            
        except IntegrityError:
            return Response(
                create_error_response("이미 스크랩된 공문입니다."),
                status=status.HTTP_409_CONFLICT
            )

    except Document.DoesNotExist:
        return Response(
            create_error_response("존재하지 않는 공문입니다."),
            status=status.HTTP_404_NOT_FOUND
        )
    except Exception as error:
        return Response(
            create_error_response(f"공문 스크랩 생성 실패: {str(error)}"),
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )


@swagger_auto_schema(
    method='delete',
    operation_summary="공문 스크랩 삭제",
    operation_description="특정 공문 스크랩을 삭제합니다.",
    tags=['공문 스크랩']
)
@api_view(['DELETE'])
@permission_classes([AllowAny])
def document_scrap_delete(request, scrap_id):
    """공문 스크랩 삭제"""
    try:
        user  = get_current_user()
        scrap = DocumentScrap.objects.filter(
            id   = scrap_id,
            user = user
        ).first()

        if not scrap:
            return Response(
                create_error_response("스크랩을 찾을 수 없습니다."),
                status=status.HTTP_404_NOT_FOUND
            )

        scrap.delete()
        return Response(
            create_success_response("공문 스크랩 삭제 성공"),
            status=status.HTTP_200_OK
        )

    except Exception as error:
        return Response(
            create_error_response(f"공문 스크랩 삭제 중 오류 발생: {str(error)}"),
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )