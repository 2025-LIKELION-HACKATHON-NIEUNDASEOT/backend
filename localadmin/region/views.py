from rest_framework import generics, filters
from django_filters.rest_framework import DjangoFilterBackend
from django.db.models import Q
from .models import Region
from .serializers import RegionSerializer

class RegionListAPIView(generics.ListAPIView):
    queryset = Region.objects.all()
    serializer_class = RegionSerializer
    # 검색 필터 설정
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    search_fields = ['city', 'district']

    def get_queryset(self):
        # district 필드가 존재하는 객체만 필터링>구 단위까지만 선택
        queryset = super().get_queryset().filter(district__isnull=False)

        search_query = self.request.query_params.get('search', None)
        if search_query:
            is_city_name = Region.objects.filter(city__icontains=search_query, district__isnull=True).exists()
            
            if is_city_name:
                return self.queryset.filter(city__icontains=search_query, district__isnull=False)
            else:
                return self.queryset.filter(
                    Q(city__icontains=search_query) | Q(district__icontains=search_query)
                )
        
        return queryset