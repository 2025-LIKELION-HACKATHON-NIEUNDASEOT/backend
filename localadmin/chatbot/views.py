from rest_framework                  import status
from rest_framework.decorators       import api_view, permission_classes
from rest_framework.permissions      import AllowAny
from rest_framework.response         import Response
from django.shortcuts                import get_object_or_404
from django.db                       import transaction

from drf_yasg.utils                  import swagger_auto_schema
from drf_yasg                        import openapi

from document.models                 import Document
from .models                         import ChatbotSession, ChatbotMessage, SpeakerChoices
from .serializers                    import (
    ChatbotSessionCreateSerializer,
    ChatbotMessageSerializer,
    ChatbotMessageCreateSerializer
)
from .services                       import GeminiChatService
from user.utils                      import (
    get_current_user,
    create_success_response,
    create_error_response
)


@swagger_auto_schema(
    method='post',
    operation_summary="새 챗봇 세션 생성",
    operation_description="""
    새로운 챗봇 세션을 생성합니다.

    **요청 바디:**
    - **document_id** (int, 필수) : 연결할 공문 ID
    - **initial_message** (string, 필수) : 세션 시작 시의 첫 질문 메시지

    **응답 데이터 (상세조회와 동일 구조):**
    - **id** (int) : 세션 ID
    - **is_active** (boolean) : 세션 활성 상태
    - **created_at** (string) : 세션 생성 시각 (YYYY-MM-DD HH:MM:SS)
    - **user** (int) : 세션 생성자 사용자 ID
    - **user_name** (string) : 세션 생성자 이름
    - **document** (object) : 연결된 공문 정보
        - **id** (int) : 공문 ID
        - **title** (string) : 공문 제목
    - **messages** (array) : 세션의 메시지 목록
        - **id** (int) : 메시지 ID
        - **speaker** (string) : "USER" 또는 "AI"
        - **content** (string) : 메시지 내용
        - **created_at** (string) : 메시지 작성 시각 (YYYY-MM-DD HH:MM:SS)
    - **message_count** (int) : 전체 메시지 개수
    """,
    request_body=ChatbotSessionCreateSerializer,
    responses = {
    201: openapi.Response(
        description="세션 생성 성공",
        examples={
            "application/json": {
                "success"      : True,
                "message"      : "세션 생성 성공",
                "data"         : {
                    "id"           : 1,
                    "is_active"    : True,
                    "created_at"   : "2025-08-09 18:12:47",
                    "user"         : 1,
                    "user_name"    : "김덕사",
                    "document"     : {
                        "id"    : 1,
                        "title" : "서울시, 중장년 기술창업 지원 강화…"
                    },
                    "messages"     : [
                        {
                            "id"         : 1,
                            "speaker"    : "USER",
                            "content"    : "중장년층들에게 얼만큼 도움 돼?",
                            "created_at" : "2025-08-10 03:12:47"
                        },
                        {
                            "id"         : 2,
                            "speaker"    : "AI",
                            "content"    : "안녕하세요, 김덕사님! 서울시가 중장년층...",
                            "created_at" : "2025-08-10 03:12:48"
                        }
                    ],
                    "message_count": 2
                }
            }
        }
    ),
    400: openapi.Response(description="잘못된 요청"),
    401: openapi.Response(description="인증 실패"),
    403: openapi.Response(description="권한 없음"),
    404: openapi.Response(description="리소스를 찾을 수 없음"),
    500: openapi.Response(description="서버 내부 오류"),
},
    tags=['챗봇']
)
@api_view(['POST'])
@permission_classes([AllowAny])
@transaction.atomic
def session_create(request):
    try:
        user       = get_current_user()
        serializer = ChatbotSessionCreateSerializer(data=request.data)

        if not serializer.is_valid():
            return Response(
                create_error_response("세션 생성 실패", serializer.errors),
                status=status.HTTP_400_BAD_REQUEST
            )

        validated_data = serializer.validated_data
        document       = get_object_or_404(Document, id=validated_data['document_id'])

        if ChatbotSession.objects.filter(user=user, document=document).exists():
            return Response(
                create_error_response("해당 공문에 대한 세션이 이미 존재"),
                status=status.HTTP_409_CONFLICT
            )

        session = ChatbotSession.objects.create(
            user=user,
            document=document,
            is_active=True
        )

        initial_message = validated_data.get('initial_message')
        if initial_message:
            ChatbotMessage.objects.create(
                chatbot_session=session,
                speaker=SpeakerChoices.USER,
                content=initial_message
            )
            try:
                chat_service = GeminiChatService()
                context      = {
                    'document'   : document,
                    'categories' : [c.category_name for c in document.categories.all()],
                    'user'       : user
                }
                ai_response  = chat_service.generate_response(
                    message=initial_message,
                    context=context
                )
                ChatbotMessage.objects.create(
                    chatbot_session=session,
                    speaker=SpeakerChoices.AI,
                    content=ai_response
                )
            except Exception as error:
                print(f"gemini_error_occurred: {error}")
                ChatbotMessage.objects.create(
                    chatbot_session=session,
                    speaker=SpeakerChoices.AI,
                    content="죄송합니다. 일시적인 오류가 발생했습니다. 다시 시도해주세요."
                )

        data = {
            "id"            : session.id,
            "is_active"     : session.is_active,
            "created_at"    : session.created_at.strftime("%Y-%m-%d %H:%M:%S"),
            "user"          : user.id,
            "user_name"     : user.name,
            "document"      : {
                "id"    : document.id,
                "title" : document.doc_title
            },
            "messages"      : ChatbotMessageSerializer(session.messages.all(), many=True).data,
            "message_count" : session.messages.count()
        }

        return Response(
            create_success_response("세션 생성 성공", data),
            status=status.HTTP_201_CREATED
        )

    except Exception as error:
        return Response(
            create_error_response(f"세션 생성 실패: {error}"),
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )


@swagger_auto_schema(
    method='get',
    operation_summary="챗봇 세션 상세 조회",
    operation_description="""
    특정 챗봇 세션의 상세 정보와 모든 메시지 내역을 조회합니다.

    **응답 예시:**
    - **id**
    - **title**
    - **is_active**
    - **created_at**
    - **user**
    - **user_name**
    - **document**: { "id", "title" }
    - **messages**: 메시지 배열
        - **id** (int) : 메시지 ID
        - **speaker** (string) : "USER" 또는 "AI"
        - **content** (string) : 메시지 내용
        - **created_at** (string) : 메시지 작성 시각 (YYYY-MM-DD HH:MM:SS)
    - **message_count**
    """,
    responses = {
    200: openapi.Response(
        description="세션 조회 성공",
        examples={
            "application/json": {
                "success" : True,
                "message" : "세션 조회 성공",
                "data"    : {
                    "id"           : 1,
                    "is_active"    : True,
                    "created_at"   : "2025-08-09 18:18:45",
                    "user"         : 1,
                    "user_name"    : "김덕사",
                    "document"     : {
                        "id"    : 1,
                        "title" : "서울시, 중장년 기술창업 지원 강화…입주기업 70% 쿼터제 첫 도입"
                    },
                    "messages"     : [
                        {
                            "id"         : 1,
                            "speaker"    : "USER",
                            "content"    : "중장년층들에게 얼만큼 도움 돼?",
                            "created_at" : "2025-08-10 03:18:45"
                        },
                        {
                            "id"         : 2,
                            "speaker"    : "AI",
                            "content"    : "안녕하세요, 김덕사님! 서울시에서 중장년층...",
                            "created_at" : "2025-08-10 03:18:46"
                        },
                        {
                            "id"         : 3,
                            "speaker"    : "USER",
                            "content"    : "지금 나도 받을 수 있는 혜택이야?",
                            "created_at" : "2025-08-10 03:19:07"
                        },
                        {
                            "id"         : 4,
                            "speaker"    : "AI",
                            "content"    : "만 40세 이상이면 서울시의 중장년...",
                            "created_at" : "2025-08-10 03:19:08"
                        }
                    ],
                    "message_count": 4
                }
            }
        }
    ),
    400: openapi.Response(description="잘못된 요청"),
    401: openapi.Response(description="인증 실패"),
    403: openapi.Response(description="권한 없음"),
    404: openapi.Response(description="리소스를 찾을 수 없음"),
    500: openapi.Response(description="서버 내부 오류"),
},
    tags=['챗봇']
)
@swagger_auto_schema(
    method='delete',
    operation_summary="챗봇 세션 삭제",
    operation_description="""
    챗봇 세션과 모든 메시지를 삭제합니다. 삭제된 데이터는 복구할 수 없습니다.
    (해당 기능이 피그마에는 없는 것 같은데... 일단 혹시 모르니까 만들어 두었습니다.)
    (테스트할 때 사용하시면 편할 듯 합니다.)
    """,
    responses={
        200: openapi.Response(description="삭제 성공"),
        404: openapi.Response(description="세션을 찾을 수 없음"),
    },
    tags=['챗봇']
)
@api_view(['GET', 'DELETE'])
@permission_classes([AllowAny])
def session_detail(request, session_id):
    try:
        user    = get_current_user()
        session = ChatbotSession.objects.filter(id=session_id, user=user).first()

        if not session:
            return Response(
                create_error_response("세션을 찾을 수 없습니다."),
                status=status.HTTP_404_NOT_FOUND
            )

        if request.method == 'GET':
            document = session.document
            data = {
                "id"            : session.id,
                "is_active"     : session.is_active,
                "created_at"    : session.created_at.strftime("%Y-%m-%d %H:%M:%S"),
                "user"          : session.user.id,
                "user_name"     : session.user.name,
                "document"      : {
                    "id"    : document.id,
                    "title" : document.doc_title
                },
                "messages"      : ChatbotMessageSerializer(session.messages.all(), many=True).data,
                "message_count" : session.messages.count()
            }
            return Response(
                create_success_response("세션 조회 성공", data),
                status=status.HTTP_200_OK
            )

        elif request.method == 'DELETE':
            session.delete()
            return Response(
                create_success_response("세션 삭제 성공"),
                status=status.HTTP_200_OK
            )

    except Exception as error:
        return Response(
            create_error_response(f"세션 처리 중 오류 발생: {error}"),
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )


@swagger_auto_schema(
    method='post',
    operation_summary="챗봇 메시지 전송",
    operation_description="""
    챗봇 세션에 메시지를 전송하고 AI 응답을 받습니다.
    **요청 바디:**
    - **message** (string, 필수): 사용자 메시지 (1~1000자)

    **응답 데이터:**
    - **user_message** (object)
        - **id** (int)
        - **speaker** (string)
        - **content** (string)
        - **created_at** (string)
    - **ai_message** (object)
        - **id** (int)
        - **speaker** (string)
        - **content** (string)
        - **created_at** (string)
    """,
    request_body=ChatbotMessageCreateSerializer,
    responses = {
    201: openapi.Response(
        description="메시지 전송 성공",
        examples={
            "application/json": {
                "success"     : True,
                "message"     : "메시지 전송 성공",
                "data"        : {
                    "user_message": {
                        "id"         : 3,
                        "speaker"    : "USER",
                        "content"    : "나도 포함 돼?",
                        "created_at" : "2025-08-10 00:47:15",
                    },
                    "ai_message"  : {
                        "id"         : 4,
                        "speaker"    : "AI",
                        "content"    : "만 40세 이상이면...",
                        "created_at" : "2025-08-10 00:47:17",
                    }
                }
            }
        }
    ),
    400: openapi.Response(description="잘못된 요청"),
    401: openapi.Response(description="인증 실패"),
    403: openapi.Response(description="권한 없음"),
    404: openapi.Response(description="리소스를 찾을 수 없음"),
    500: openapi.Response(description="서버 내부 오류"),
},
    tags=['챗봇']
)
@api_view(['POST'])
@permission_classes([AllowAny])
@transaction.atomic
def send_message(request, session_id):
    try:
        user    = get_current_user()
        session = ChatbotSession.objects.filter(
            id=session_id,
            user=user,
            is_active=True
        ).first()

        if not session:
            return Response(
                create_error_response("세션을 찾을 수 없습니다."),
                status=status.HTTP_404_NOT_FOUND
            )

        serializer = ChatbotMessageCreateSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(
                create_error_response("메시지 전송 실패", serializer.errors),
                status=status.HTTP_400_BAD_REQUEST
            )

        validated_data = serializer.validated_data
        user_message   = ChatbotMessage.objects.create(
            chatbot_session=session,
            speaker=SpeakerChoices.USER,
            content=validated_data['message']
        )

        try:
            chat_service = GeminiChatService()
            context = {
                'document'   : session.document,
                'categories' : [c.category_name for c in session.document.categories.all()],
                'user'       : user
            }
            recent_messages = session.messages.order_by('-created_at')[:10]
            history = [
                {'speaker': msg.speaker, 'content': msg.content}
                for msg in reversed(recent_messages)
            ][:-1]

            ai_response = chat_service.generate_response(
                message=validated_data['message'],
                context=context,
                history=history
            )

            ai_message = ChatbotMessage.objects.create(
                chatbot_session=session,
                speaker=SpeakerChoices.AI,
                content=ai_response
            )

        except Exception as error:
            print(f"gemini_error_occurred: {error}")
            ai_message = ChatbotMessage.objects.create(
                chatbot_session=session,
                speaker=SpeakerChoices.AI,
                content="죄송합니다. 일시적인 오류가 발생했습니다. 다시 시도해주세요."
            )

        return Response(
            create_success_response(
                "메시지 전송 성공",
                {
                    "user_message": ChatbotMessageSerializer(user_message).data,
                    "ai_message"  : ChatbotMessageSerializer(ai_message).data
                }
            ),
            status=status.HTTP_201_CREATED
        )

    except Exception as error:
        return Response(
            create_error_response(f"메시지 처리 중 오류 발생: {error}"),
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )