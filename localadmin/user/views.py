from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from django.db import transaction
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
from region.models import Region

from .models import User, Category, UserCategory, UserRegion
from .serializers import UserProfileSerializer, UserProfileUpdateSerializer
from .utils import (
    get_current_user,
    create_success_response,
    create_error_response
)


@swagger_auto_schema(
    methods=['get'],
    operation_summary="사용자 프로필 조회",
    operation_description="현재 게스트 사용자의 프로필 정보를 조회합니다.",
    responses={
        200: "프로필 조회 성공",
        404: "사용자를 찾을 수 없음"
    },
    tags=['사용자 프로필']
)
@swagger_auto_schema(
    methods=['put'],
    operation_summary="사용자 프로필 수정",
    operation_description="""
    사용자 프로필 정보를 수정합니다. 
    
    **수정 가능한 필드:**
    - name: 사용자 이름
    - birth: 생년월일 (YYYY-MM-DD)
    - gender: 성별 (M, F, OTHER)
    - category_ids: 관심 주제 ID 배열 (기존 데이터 전체 교체)
    - regions: 관심 지역 배열 (기존 데이터 전체 교체) 
        - region_id만 입력해도 region 관련 모든 정보가 return됩니다.
        - type은 "거주지"와 "관심지역"
    
    **주의사항:**
    - 관심 주제와 지역은 수정 시, 기존에 선택된 항목과 새로 선택된 항목을 모두 포함한 전체 배열로 전달해야 합니다.
    - 빈 배열을 전달하면 해당 데이터를 모두 삭제합니다.
    
    **가능한 category_ids 목록:**
    - 왼쪽부터 순서대로 id 1, 2, 3... 입니다.
    - 교통, 문화, 주택, 경제, 환경, 안전, 복지, 행정
    """,
    request_body=openapi.Schema(
        type=openapi.TYPE_OBJECT,
        properties={
            'name': openapi.Schema(
                type=openapi.TYPE_STRING,
                example="김덕사",
                description="사용자 이름"
            ),
            'birth': openapi.Schema(
                type=openapi.TYPE_STRING,
                format='date',
                example="1995-03-15",
                description="생년월일 (YYYY-MM-DD 형식)"
            ),
            'gender': openapi.Schema(
                type=openapi.TYPE_STRING,
                example="M",
                enum=['M', 'F', 'OTHER'],
                description="성별 (M: 남성, F: 여성, OTHER: 기타)"
            ),
            'category_ids': openapi.Schema(
                type=openapi.TYPE_ARRAY,
                items=openapi.Schema(type=openapi.TYPE_INTEGER),
                example=[1, 2, 3],
                description="관심 주제 카테고리 ID 배열"
            ),
            'regions': openapi.Schema(
                type=openapi.TYPE_ARRAY,
                items=openapi.Schema(
                    type=openapi.TYPE_OBJECT,
                    properties={
                        'region_id': openapi.Schema(
                            type=openapi.TYPE_INTEGER,
                            example=2,
                            description="Region 테이블의 PK(ID)"
                        ),
                        'type': openapi.Schema(
                            type=openapi.TYPE_STRING,
                            example="거주지",
                            enum=["거주지", "관심지역"]
                        )
                    }
                ),
                example=[
                    {"region_id": 2, "type": "거주지"},
                    {"region_id": 5, "type": "관심지역"}
                ],
                description="관심 지역 배열 (Region 테이블 PK 기반)"
            )
        }
    ),
    responses={
        200: "수정 성공",
        400: "잘못된 요청 데이터",
        404: "사용자를 찾을 수 없음"
    },
    tags=['사용자 프로필']
)
@api_view(['GET', 'PUT'])
@permission_classes([AllowAny])
def profile_view(request):
    """프로필 조회/수정을 처리하는 통합 뷰"""
    if request.method == 'GET':
        return _handle_get_profile(request)
    elif request.method == 'PUT':
        return _handle_update_profile(request)


def _handle_get_profile(request):
    """GET 요청 처리 - 프로필 조회"""
    try:
        user       = get_current_user()
        serializer = UserProfileSerializer(user)
        
        return Response(
            create_success_response("프로필 조회 성공", serializer.data),
            status=status.HTTP_200_OK
        )
        
    except User.DoesNotExist:
        return Response(
            create_error_response("프로필 조회 실패", "사용자를 찾을 수 없습니다."),
            status=status.HTTP_404_NOT_FOUND
        )
    except Exception as e:
        return Response(
            create_error_response("프로필 조회 실패", "서버 내부 오류가 발생했습니다."),
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )



def _handle_update_profile(request):
    """PUT 요청 처리 - 프로필 수정"""
    try:
        user       = get_current_user()
        serializer = UserProfileUpdateSerializer(data=request.data)
        
        if not serializer.is_valid():
            return Response(
                create_error_response("프로필 수정 실패", serializer.errors),
                status=status.HTTP_400_BAD_REQUEST
            )
        
        _update_user_profile(user, serializer.validated_data)
        
        refreshed_user = get_current_user()
        
        response_serializer = UserProfileSerializer(refreshed_user)
        return Response(
            create_success_response("프로필 수정 성공", response_serializer.data),
            status=status.HTTP_200_OK
        )
        
    except User.DoesNotExist:
        return Response(
            create_error_response("프로필 수정 실패", "사용자를 찾을 수 없습니다."),
            status=status.HTTP_404_NOT_FOUND
        )
    except Exception as e:
        return Response(
            create_error_response("프로필 수정 실패", "서버 내부 오류가 발생했습니다."),
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@transaction.atomic
def _update_user_profile(user, validated_data):
    """사용자 프로필 및 관련 데이터 업데이트"""
    category_ids = validated_data.pop('category_ids', None)
    regions      = validated_data.pop('regions', None)
    
    for field, value in validated_data.items():
        setattr(user, field, value)
    
    if validated_data: 
        user.full_clean()
        user.save()
    
    if category_ids is not None:
        _update_user_categories(user, category_ids)

    if regions is not None:
        _update_user_regions(user, regions)
    
    return user


def _update_user_categories(user, category_ids):
    """사용자 관심 주제 업데이트"""
    # 기존 관계 삭제
    UserCategory.objects.filter(user=user).delete()
    
    if not category_ids:
        return
    
    valid_ids = [
        int(cid) for cid in category_ids
        if str(cid).isdigit()
    ]

    if not valid_ids:
        return

    categories = Category.objects.filter(
        id__in=valid_ids,
        is_active=True
    )

    user_categories = [
        UserCategory(user=user, category=category)
        for category in categories
    ]
    
    UserCategory.objects.bulk_create(user_categories)


def _update_user_regions(user, regions):
    """사용자 관심 지역 업데이트"""
    UserRegion.objects.filter(user=user).delete()

    if not regions:
        return

    user_regions = []
    for region_data in regions:
        region_obj = Region.objects.get(id=region_data['region_id'])
        user_region = UserRegion(
            user   = user,
            region = region_obj,
            type   = region_data['type']
        )
        user_regions.append(user_region)

    UserRegion.objects.bulk_create(user_regions)