from rest_framework import serializers
from .models import Document
from user.models import Category


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'category_name']


class DocumentListSerializer(serializers.ModelSerializer):
    # 목록용
    categories = CategorySerializer(many=True, read_only=True)
    doc_type_display = serializers.CharField(source='get_doc_type_display', read_only=True)
    has_deadline = serializers.SerializerMethodField()
    
    class Meta:
        model = Document
        fields = [
            'id', 'doc_title', 'doc_type', 'doc_type_display',
            'pub_date', 'dead_date', 'has_deadline',
            'region_id', 'categories'
        ]
    
    def get_has_deadline(self, obj):
        """마감일 존재 여부 (참여형 공문용)"""
        return obj.dead_date is not None


class DocumentSerializer(serializers.ModelSerializer):
    # 상세 조회
    categories = CategorySerializer(many=True, read_only=True)
    doc_type_display = serializers.CharField(source='get_doc_type_display', read_only=True)
    days_until_deadline = serializers.SerializerMethodField()
    
    class Meta:
        model = Document
        fields = [
            'id', 'doc_title', 'doc_content', 'doc_type', 'doc_type_display',
            'pub_date', 'dead_date', 'days_until_deadline',
            'region_id', 'categories', 'image_url',
            'created_at'
        ]
    
    def get_days_until_deadline(self, obj):
        # 마감일
        if not obj.dead_date:
            return None
        
        diff = obj.dead_date.date() - timezone.now().date()
        return diff.days if diff.days >= 0 else -1