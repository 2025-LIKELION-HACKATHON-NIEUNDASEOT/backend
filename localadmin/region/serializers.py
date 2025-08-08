from rest_framework import serializers
from .models import Region

class RegionSerializer(serializers.ModelSerializer):
    full_name = serializers.SerializerMethodField()

    class Meta:
        model = Region
        # '구'가 있는 지역만 선택 가능하므로, district가 있는 경우만 필터링합니다.
        fields = ['region_code', 'city', 'district', 'full_name']

    def get_full_name(self, obj):
        if obj.district:
            return f"{obj.city} {obj.district}"
        return f"{obj.city}"