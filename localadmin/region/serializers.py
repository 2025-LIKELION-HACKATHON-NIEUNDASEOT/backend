from rest_framework import serializers
from .models import Region

class RegionSerializer(serializers.ModelSerializer):
    full_name = serializers.SerializerMethodField()

    class Meta:
        model = Region
        fields = ['region_code', 'city', 'district', 'full_name']  
        
    # district가 있으면 city+district
    def get_full_name(self, obj):
        if obj.district:
            return f"{obj.city} {obj.district}"
        return f"{obj.city}"