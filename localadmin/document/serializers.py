from rest_framework import serializers
from .models import Document
from user.models import Category
from scrap.models import DocumentScrap
from django.utils import timezone

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'category_name']

# 공문 목록 조회 시 필드 정의
class DocumentListSerializer(serializers.ModelSerializer):
    categories = CategorySerializer(many=True, read_only=True)
    doc_type_display = serializers.CharField(source='get_doc_type_display', read_only=True)
    has_deadline = serializers.SerializerMethodField()
    
    class Meta:
        model = Document
        fields = ('id', 'doc_title', 'doc_content', 'doc_type', 'doc_type_display', 'pub_date', 'dead_date', 'has_deadline', 'categories', 'region_id', 'image_url')
    
    def get_has_deadline(self, obj):
        return obj.dead_date is not None

# 공문 상세 정보 포함 (마감일, 디데이 필드 포함)
class DocumentSerializer(serializers.ModelSerializer):
    categories = CategorySerializer(many=True, read_only=True)
    doc_type_display = serializers.CharField(source='get_doc_type_display', read_only=True)
    days_until_deadline = serializers.SerializerMethodField()
    # 계산 필드->수동 추가
    summary = serializers.CharField(read_only=True)
    
    class Meta:
        model = Document
        fields = ('id', 'categories', 'doc_type_display', 'days_until_deadline', 
                  'summary', 'created_at', 'doc_title', 'doc_content', 'doc_type', 
                  'pub_date', 'dead_date', 'is_active', 'region_id', 'image_url', 
                  'link_url', 'keywords', 'related_departments', 'purpose')
        # 전체 필드
        # fields = tuple(f.name for f in Document._meta.fields)
    
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
    image_url = serializers.URLField(allow_null=True) # image_url 필드 추가

# documentserializer 상속 - 유사 공문 목록, 챗봇 세션 id 필드 추가해서 리턴
class DocumentDetailWithSimilarSerializer(DocumentSerializer):
    similar_documents = SimilarDocumentSerializer(many=True, read_only=True)
    chatbot_session_id = serializers.SerializerMethodField()
    
    class Meta:
        model = Document
        fields = DocumentSerializer.Meta.fields + ('similar_documents', 'chatbot_session_id',)

    def get_chatbot_session_id(self, obj):
        return self.context.get('chatbot_session_id')

    # class Meta:
    #     model = Document
    #     fields = '__all__'

class DocumentScrapUpcomingSerializer(serializers.ModelSerializer):
    #document = DocumentSerializer(read_only=True)
    document = DocumentListSerializer(read_only=True)

    class Meta:
        model = DocumentScrap
        fields = ['id', 'created_at', 'document']
