from rest_framework import serializers

from .models import Notification


class NotificationListSerializer(serializers.ModelSerializer):
    """알림 목록 직렬화"""
    document_info = serializers.SerializerMethodField()
    time_since    = serializers.SerializerMethodField()
    

    class Meta:
        model  = Notification
        fields = [
            'id', 'title', 'content', 'is_read', 
            'notification_time', 'read_time', 'time_since',
            'document_info'
        ]


    def get_document_info(self, obj):
        """공문 기본 정보 포함"""
        from region.models import Region
        
        # 지역 정보 조회
        try:
            region = Region.objects.get(id=obj.document.region_id)
            region_name = region.city if not region.district else f"{region.city} {region.district}"
        except Region.DoesNotExist:
            region_name = "지역정보없음"
        
        # 카테고리 정보
        categories = obj.document.categories.all()
        category_names = [cat.category_name for cat in categories]
        
        return {
            'id'              : obj.document.id,
            'doc_title'       : obj.document.doc_title,
            'doc_type'        : obj.document.doc_type,
            'doc_type_display': obj.document.get_doc_type_display(),
            'pub_date'        : obj.document.pub_date,
            'image_url'       : obj.document.image_url,
            'region_id'       : obj.document.region_id,
            'region_tags'     : [region_name],
            'category_tags'   : category_names
        }


    def get_time_since(self, obj):
        """알림 생성 후 경과 시간"""
        from django.utils import timezone
        from django.utils.timesince import timesince
        
        return timesince(obj.notification_time, timezone.now())
