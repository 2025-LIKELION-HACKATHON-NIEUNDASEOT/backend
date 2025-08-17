from rest_framework import serializers
from .models import Document
from user.models import Category
from scrap.models import DocumentScrap
from django.utils import timezone

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
        fields = '__all__'
    
    def get_has_deadline(self, obj):
        # 마감일 존재 여부 (참여형 공문용)
        return obj.dead_date is not None


class DocumentSerializer(serializers.ModelSerializer):
    # 상세 조회
    categories = CategorySerializer(many=True, read_only=True)
    doc_type_display = serializers.CharField(source='get_doc_type_display', read_only=True)
    days_until_deadline = serializers.SerializerMethodField()
    
    class Meta:
        model = Document
        fields = '__all__'
    
    def get_days_until_deadline(self, obj):
        # 마감일
        if not obj.dead_date:
            return None
        
        diff = obj.dead_date.date() - timezone.now().date()
        return diff.days if diff.days >= 0 else -1

# 유사 공문 추천
class SimilarDocumentSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    doc_title = serializers.CharField(max_length=255)
    preview_content = serializers.CharField()
    pub_date = serializers.DateTimeField()
    score = serializers.FloatField()

class DocumentDetailWithSimilarSerializer(DocumentSerializer):
    similar_documents = SimilarDocumentSerializer(many=True, read_only=True)

    # class Meta(DocumentSerializer.Meta):
    #     fields = DocumentSerializer.Meta.fields + ('similar_documents',)

    class Meta:
        model = Document
        fields = '__all__'

class DocumentScrapUpcomingSerializer(serializers.ModelSerializer):
    document = DocumentSerializer(read_only=True)

    class Meta:
        model = DocumentScrap
        fields = ['id', 'created_at', 'document']
