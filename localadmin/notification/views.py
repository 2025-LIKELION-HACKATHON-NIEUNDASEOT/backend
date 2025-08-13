from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django.shortcuts import get_object_or_404
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
import logging

from .models import Notification, FCMDevice
from .serializers import NotificationListSerializer
from .firebase_service import NotificationService
from user.models import User


logger = logging.getLogger(__name__)


class NotificationListView(generics.ListAPIView):
    """알림 목록 조회"""
    serializer_class = NotificationListSerializer
    
    @swagger_auto_schema(
        operation_summary="알림 목록 조회",
        operation_description="""
        사용자의 알림 목록을 최신순으로 조회합니다.

        **요청 파라미터:**
        - **user_id** (string, 필수) : 조회할 사용자 ID (GUEST1로 고정입니다)
        - **doc_type** (string, 선택) : PARTICIPATION, NOTICE, REPORT, ANNOUNCEMENT
        - **region_ids** (string, 선택) : 지역 ID 여러 개 (쉼표 구분)
        - **category_ids** (string, 선택) : 카테고리 ID 여러 개 (쉼표 구분)

        **응답 데이터:**
        - count: 전체 알림 개수
        - results: 알림 목록 (최신순)
        """,
        manual_parameters=[
            openapi.Parameter(
                'user_id', openapi.IN_QUERY,
                description="사용자 ID (필수)",
                type=openapi.TYPE_STRING,
                required=True
            ),
            openapi.Parameter(
                'doc_type', openapi.IN_QUERY,
                description="1차 필터: 공문 타입",
                type=openapi.TYPE_STRING,
                enum=['PARTICIPATION', 'NOTICE', 'REPORT', 'ANNOUNCEMENT']
            ),
            openapi.Parameter(
                'region_ids', openapi.IN_QUERY,
                description="2차 필터: 지역 ID (쉼표구분: 1,2,3)",
                type=openapi.TYPE_STRING
            ),
            openapi.Parameter(
                'category_ids', openapi.IN_QUERY,
                description="2차 필터: 카테고리 ID (쉼표구분: 1,2,3)",
                type=openapi.TYPE_STRING
            ),
        ],
        responses={
            200: openapi.Response(
                description="알림 목록 조회 성공",
                examples={
                    "application/json": {
                        "success": True,
                        "message": "알림 목록 조회 성공",
                        "data": {
                            "count": 1,
                            "results": [
                                {
                                    "id": 8,
                                    "title": "testtest",
                                    "content": "",
                                    "is_read": False,
                                    "notification_time": "2025-08-13T19:59:55.978229+09:00",
                                    "read_time": None,
                                    "time_since": "1분",
                                    "document_info": {
                                        "id": 208,
                                        "doc_title": "testtest",
                                        "doc_type": "PARTICIPATION",
                                        "doc_type_display": "참여",
                                        "pub_date": "2025-08-13T10:59:55Z",
                                        "image_url": None,
                                        "region_id": 11,
                                        "region_tags": ["서울특별시 도봉구"],
                                        "category_tags": ["교통"]
                                    }
                                }
                            ]
                        }
                    }
                }
            )
        },
        tags=['알림 관리']
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)
    
    def get_queryset(self):
        user_id = self.request.query_params.get('user_id')
        if not user_id:
            return Notification.objects.none()
        
        try:
            user = User.objects.get(user_id=user_id)
        except User.DoesNotExist:
            return Notification.objects.none()
        
        doc_type = self.request.query_params.get('doc_type')
        
        region_ids = None
        region_ids_str = self.request.query_params.get('region_ids', '')
        if region_ids_str:
            try:
                region_ids = [int(rid.strip()) for rid in region_ids_str.split(',') if rid.strip().isdigit()]
            except ValueError:
                pass
        
        category_ids = None
        category_ids_str = self.request.query_params.get('category_ids', '')
        if category_ids_str:
            try:
                category_ids = [int(cid.strip()) for cid in category_ids_str.split(',') if cid.strip().isdigit()]
            except ValueError:
                pass
        
        return NotificationService.get_user_notifications(
            user=user,
            doc_type=doc_type,
            region_ids=region_ids,
            category_ids=category_ids
        )
    
    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        
        return Response({
            "success": True,
            "message": "알림 목록 조회 성공",
            "data": {
                "count": queryset.count(),
                "results": serializer.data
            }
        })


@swagger_auto_schema(
    method='patch',
    operation_summary="알림 읽음 처리",
    operation_description="""
    특정 알림 하나를 읽음 상태로 처리합니다.
    
    **요청 바디:**
    - **user_id** (string, 필수) : 알림을 읽음 처리할 사용자 ID GUEST1로 고정입니다.

    **응답 데이터 (data):**
    - **id** (int) : 읽음 처리된 알림 ID
    - **is_read** (boolean) : 읽음 상태(True)
    """,
    request_body=openapi.Schema(
        type=openapi.TYPE_OBJECT,
        required=['user_id'],
        properties={
            'user_id': openapi.Schema(type=openapi.TYPE_STRING, description='사용자 ID')
        }
    ),
    responses={
        200: openapi.Response(
            description="알림 읽음 처리 성공",
            examples={
                "application/json": {
                    "success": True,
                    "message": "알림을 읽음으로 처리했습니다.",
                    "data": {
                        "id": 1,
                        "is_read": True
                    }
                }
            }
        ),
        403: "권한 없음",
        404: "알림을 찾을 수 없음"
    },
    tags=['알림 관리']
)
@api_view(['PATCH'])
def mark_notification_as_read(request, notification_id):
    """알림 읽음 처리"""
    try:
        user_id = request.data.get('user_id')
        if not user_id:
            return Response({
                "success": False,
                "message": "user_id가 필요합니다."
            }, status=status.HTTP_400_BAD_REQUEST)
        
        user = get_object_or_404(User, user_id=user_id)
        notification = get_object_or_404(Notification, id=notification_id, user=user)
        
        notification.mark_as_read()
        
        return Response({
            "success": True,
            "message": "알림을 읽음으로 처리했습니다.",
            "data": {
                "id": notification.id,
                "is_read": True
            }
        })
        
    except Exception as error:
        logger.error(f"알림 읽음 처리 실패: {error}")
        return Response({
            "success": False,
            "message": "알림 처리 중 오류가 발생했습니다."
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@swagger_auto_schema(
    method='post',
    operation_summary="FCM 토큰 등록",
        operation_description="""
    사용자의 FCM 토큰을 등록하거나 이미 등록된 경우 업데이트합니다.
    
    **요청 바디:**
    - **user_id** (string, 필수) : 토큰을 등록할 사용자 ID (GUEST1)
    - **registration_token** (string, 필수) : Firebase에서 발급받은 FCM 등록 토큰
    - **device_type** (string, 선택) : 디바이스 타입 (android, ios, web)
    
    **응답 데이터 (data):**
    - **fcm_device_id** (int) : 등록된 FCM 디바이스의 ID
    - **device_type** (string) : 디바이스 타입 (android, ios, web)
    - **is_active** (boolean) : 해당 FCM 디바이스의 활성 상태
    
    **주의:**
    - 유저가 한 명밖에 없는데, id는 **GUEST1**로 고정입니다. 다른 아이디는 먹히지 않습니다.
    """,
    request_body=openapi.Schema(
        type=openapi.TYPE_OBJECT,
        required=['user_id', 'registration_token'],
        properties={
            'user_id': openapi.Schema(type=openapi.TYPE_STRING, description='사용자 ID'),
            'registration_token': openapi.Schema(type=openapi.TYPE_STRING, description='FCM 등록 토큰'),
            'device_type': openapi.Schema(
                type=openapi.TYPE_STRING, 
                description='디바이스 타입',
                enum=['android', 'ios', 'web'],
                default='android'
            )
        }
    ),
    responses={
        201: openapi.Response(
            description="FCM 토큰 등록 성공",
            examples={
                "application/json": {
                    "success": True,
                    "message": "FCM 토큰 등록 완료",
                    "data": {
                        "fcm_device_id": 1,
                        "device_type": "web",
                        "is_active": True
                    }
                }
            }
        ),
        400: "잘못된 요청"
    },
    tags=['푸시 알림 FCM 관리']
)
@api_view(['POST'])
def register_fcm_token(request):
    """FCM 토큰 등록"""
    try:
        user_id = request.data.get('user_id')
        registration_token = request.data.get('registration_token')
        device_type = request.data.get('device_type', 'android')
        
        if not user_id or not registration_token:
            return Response({
                "success": False,
                "message": "user_id와 registration_token이 필요합니다."
            }, status=status.HTTP_400_BAD_REQUEST)
        
        user = get_object_or_404(User, user_id=user_id)
        
        # FCM 토큰 등록/업데이트
        fcm_device, created = FCMDevice.objects.update_or_create(
            user=user,
            registration_token=registration_token,
            defaults={
                'device_type': device_type,
                'is_active': True
            }
        )
        
        action = "등록" if created else "업데이트"
        
        return Response({
            "success": True,
            "message": f"FCM 토큰 {action} 완료",
            "data": {
                "fcm_device_id": fcm_device.id,
                "device_type": fcm_device.device_type,
                "is_active": fcm_device.is_active
            }
        }, status=status.HTTP_201_CREATED)
        
    except Exception as error:
        logger.error(f"FCM 토큰 등록 실패: {error}")
        return Response({
            "success": False,
            "message": "FCM 토큰 등록 중 오류가 발생했습니다."
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@swagger_auto_schema(
    method='post',
    operation_summary="푸시 알림 테스트",
    operation_description="사용자의 가장 최신 알림을 기반으로 테스트 푸시 알림을 전송합니다. 입력되는 user_id는 GUEST1 고정입니다.",
    request_body=openapi.Schema(
        type=openapi.TYPE_OBJECT,
        required=['user_id'],
        properties={
            'user_id': openapi.Schema(type=openapi.TYPE_STRING, description='사용자 ID')
        }
    ),
    responses={
        200: "테스트 푸시 전송 성공",
        400: "잘못된 요청",
        404: "사용자 또는 알림 없음"
    },
    tags=['푸시 알림 FCM 관리']
)
@api_view(['POST'])
def send_test_push_notification(request):
    """테스트 푸시 알림 전송"""
    try:
        user_id = request.data.get('user_id')
        if not user_id:
            return Response({
                "success": False,
                "message": "user_id가 필요합니다."
            }, status=status.HTTP_400_BAD_REQUEST)
        
        user = get_object_or_404(User, user_id=user_id)
        
        # 테스트 푸시 전송
        success = NotificationService.send_test_push_notification(user)
        
        if success:
            return Response({
                "success": True,
                "message": "테스트 푸시 알림을 전송했습니다."
            })
        else:
            return Response({
                "success": False,
                "message": "테스트 푸시 알림 전송에 실패했습니다. (토큰 없음 또는 알림 없음)"
            }, status=status.HTTP_400_BAD_REQUEST)
            
    except Exception as error:
        logger.error(f"테스트 푸시 전송 실패: {error}")
        return Response({
            "success": False,
            "message": "테스트 푸시 전송 중 오류가 발생했습니다."
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
