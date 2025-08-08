from django.shortcuts import render

from rest_framework import viewsets, filters
from django_filters.rest_framework import DjangoFilterBackend
from .models import Region
from .serializers import RegionSerializer
from django.db.models import Q

class RegionViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Region.objects.all()
    serializer_class = RegionSerializer
    # 검색 필터 백엔드 설정
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    # 'city'와 'district' 필드에서 검색 가능하도록 설정
    search_fields = ['city', 'district']

    def get_queryset(self):
        # 구 단위까지만 선택 가능하도록, district 필드가 존재하는 객체만 필터링합니다.
        queryset = super().get_queryset().filter(district__isnull=False)

        # '서울' 검색 시 구 단위 표시 로직
        search_query = self.request.query_params.get('search', None)
        if search_query:
            if search_query == '서울':
                queryset = Region.objects.filter(city='서울특별시', district__isnull=False)
                return queryset
            elif search_query == '도봉':
                # '도봉' 검색 시 '서울시 도봉구' 표시 (serializer에서 처리)
                return Region.objects.filter(Q(city__icontains=search_query) | Q(district__icontains=search_query))

        return queryset