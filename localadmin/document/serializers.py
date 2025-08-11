from rest_framework import serializers
from .models import Document
from user.models import Category


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name']


class DocumentSerializer(serializers.ModelSerializer):
    categories = CategorySerializer(many=True, read_only=True)
    doc_type_display = serializers.CharField(source='get_doc_type_display', read_only=True)
    days_until_deadline = serializers.SerializerMethodField()
    
    class Meta:
        model = Document
        fields = [
            'id', 'doc_title', 'doc_content', 'doc_type', 'doc_type_display',
            'pub_date', 'dead_date', 'days_until_deadline', 'is_active', 
            'region_id', 'categories', 'image_url', 'created_at', 'updated_at'
        ]
    
    def get_days_until_deadline(self, obj):
        if not obj.dead_date:
            return None
        
        from django.utils import timezone
        diff = obj.dead_date.date() - timezone.now().date()
        return diff.days if diff.days >= 0 else -1


class DocumentListSerializer(serializers.ModelSerializer):
    """목록용 간소화된 시리얼라이저"""
    categories = CategorySerializer(many=True, read_only=True)
    doc_type_display = serializers.CharField(source='get_doc_type_display', read_only=True)
    is_urgent = serializers.SerializerMethodField()
    
    class Meta:
        model = Document
        fields = [
            'id', 'doc_title', 'doc_type', 'doc_type_display',
            'pub_date', 'dead_date', 'is_urgent', 'region_id', 'categories'
        ]
    
    def get_is_urgent(self, obj):
        """마감일이 7일 이내인지 확인"""
        if not obj.dead_date:
            return False
        
        from django.utils import timezone
        from datetime import timedelta
        
        return obj.dead_date <= timezone.now() + timedelta(days=7)