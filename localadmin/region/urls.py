from django.urls import path
from .views import RegionListAPIView

urlpatterns = [
    # 전체 지역 목록 조회 및 검색만
    path('regions/', RegionListAPIView.as_view(), name='region-list'),
]