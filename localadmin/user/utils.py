from django.shortcuts import get_object_or_404
from .models import User

# 하드코딩 게스트 유저 ID
GUEST_USER_ID = "GUEST1"


def get_current_user():
    # 설정된 게스트 사용자 조회
    return get_object_or_404(
        User.objects.prefetch_related('user_categories__category', 'user_regions'),
        user_id=GUEST_USER_ID
    )


def create_success_response(message, data=None):
    # 성공 응답 생성 헬퍼
    response_data = {
        "success": True,
        "message": message
    }
    if data is not None:
        response_data["data"] = data
    return response_data


def create_error_response(message, errors=None):
    # 오류 응답 생성 헬퍼
    response_data = {
        "success": False,
        "message": message
    }
    if errors is not None:
        response_data["errors"] = errors
    return response_data