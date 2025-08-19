from rest_framework           import serializers
from .models                  import ChatbotScrap, DocumentScrap
from document.models          import Category, Document, DocumentTypeChoices
from region.models            import Region

# 마감일 가까운 공문
from django.utils import timezone
from document.serializers import DocumentSerializer
from .models import DocumentScrap

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model  = Category
        fields = ['id', 'category_name']

class ChatbotScrapSerializer(serializers.ModelSerializer):
    user_message_content = serializers.CharField(source='user_message.content', read_only=True)
    ai_message_content   = serializers.CharField(source='ai_message.content', read_only=True)
    user_name            = serializers.CharField(source='user.name', read_only=True)
    session_title        = serializers.CharField(source='chatbot_session.title', read_only=True)
    created_at           = serializers.DateTimeField(format='%Y-%m-%d %H:%M:%S', read_only=True)
    categories           = CategorySerializer(many=True, read_only=True)

    class Meta:
        model  = ChatbotScrap
        fields = [
            'id',
            'summary',
            'created_at',
            'user',
            'user_name',
            'chatbot_session',
            'session_title',
            'user_message',
            'user_message_content',
            'ai_message',
            'ai_message_content',
            'categories'
        ]
        read_only_fields = [
            'id', 'created_at', 'user', 'summary', 'categories'
        ]


class ChatbotScrapCreateSerializer(serializers.Serializer):
    user_message_id = serializers.IntegerField(
        required  = True,
        help_text = "사용자 메시지 ID"
    )
    ai_message_id   = serializers.IntegerField(
        required  = True,
        help_text = "AI 메시지 ID"
    )

    def validate(self, data):
        from chatbot.models import ChatbotMessage, SpeakerChoices
        try:
            user_msg = ChatbotMessage.objects.get(id=data['user_message_id'])
            ai_msg   = ChatbotMessage.objects.get(id=data['ai_message_id'])
        except ChatbotMessage.DoesNotExist:
            raise serializers.ValidationError("존재하지 않는 메시지 ID입니다.")
        if user_msg.speaker != SpeakerChoices.USER:
            raise serializers.ValidationError("user_message_id는 USER 타입 메시지여야 합니다.")
        if ai_msg.speaker != SpeakerChoices.AI:
            raise serializers.ValidationError("ai_message_id는 AI 타입 메시지여야 합니다.")
        if user_msg.chatbot_session_id != ai_msg.chatbot_session_id:
            raise serializers.ValidationError("두 메시지는 같은 세션에 속해야 합니다.")
        data['user_message']    = user_msg
        data['ai_message']      = ai_msg
        data['chatbot_session'] = user_msg.chatbot_session
        return data


class ChatbotScrapListSerializer(serializers.ModelSerializer):
    created_at            = serializers.DateTimeField(format='%Y-%m-%d %H:%M:%S', read_only=True)
    user_message_preview  = serializers.SerializerMethodField()
    ai_message_preview    = serializers.SerializerMethodField()
    categories            = CategorySerializer(many=True, read_only=True)
    session_info          = serializers.SerializerMethodField()

    class Meta:
        model  = ChatbotScrap
        fields = [
            'id',
            'summary',
            'created_at',
            'user_message_preview',
            'ai_message_preview',
            'categories',
            'session_info'
        ]

    def get_user_message_preview(self, obj):
        if obj.user_message and obj.user_message.content:
            content = obj.user_message.content
            return content[:50] + '...' if len(content) > 50 else content
        return None

    def get_ai_message_preview(self, obj):
        return obj.summary or "요약 없음"

    def get_session_info(self, obj):
        if obj.chatbot_session:
            return {
                'id'   : obj.chatbot_session.id,
                'title': obj.chatbot_session.title
            }
        return None

class RegionSimpleSerializer(serializers.ModelSerializer):
    full_name = serializers.SerializerMethodField()
    
    class Meta:
        model  = Region
        fields = ['id', 'city', 'district', 'full_name']
    
    def get_full_name(self, obj):
        if obj.district:
            return f"{obj.city} {obj.district}"
        return obj.city


class DocumentScrapListSerializer(serializers.ModelSerializer):
    # 공문 스크랩 목록
    document         = serializers.IntegerField(source='document.id', read_only=True)
    doc_title        = serializers.CharField(source='document.doc_title', read_only=True)
    doc_type         = serializers.CharField(source='document.doc_type', read_only=True)
    doc_type_display = serializers.CharField(source='document.get_doc_type_display', read_only=True)
    pub_date         = serializers.DateTimeField(source='document.pub_date', read_only=True)
    region           = serializers.SerializerMethodField()
    categories       = serializers.SerializerMethodField()
    image_url        = serializers.CharField(source='document.image_url', read_only=True)
    # 마감일 가까운 공문용 필드
    dead_date = serializers.DateTimeField(source='document.dead_date', read_only=True)

    class Meta:
        model  = DocumentScrap
        fields = [
            'id', 'document',  'doc_title', 'doc_type', 'doc_type_display', 
            'pub_date', 'region', 'categories', 'image_url', 'created_at'
        ]
    
    def get_region(self, obj):
        try:
            region = Region.objects.get(id=obj.document.region_id)
            return RegionSimpleSerializer(region).data
        except Region.DoesNotExist:
            return None
    
    def get_categories(self, obj):
        return CategorySerializer(obj.document.categories.all(), many=True).data


class DocumentScrapCreateSerializer(serializers.Serializer):
    # 공문 스크랩 생성
    document_id = serializers.IntegerField(help_text="스크랩할 공문 ID")
    
    def validate_document_id(self, value):
        try:
            document = Document.objects.get(id=value, is_active=True)
            return value
        except Document.DoesNotExist:
            raise serializers.ValidationError("존재하지 않거나 비활성화된 공문입니다.")


class DocumentScrapSerializer(serializers.ModelSerializer):
    # 공문 스크랩 상세
    doc_title        = serializers.CharField(source='document.doc_title', read_only=True)
    doc_type         = serializers.CharField(source='document.doc_type', read_only=True)
    doc_type_display = serializers.CharField(source='document.get_doc_type_display', read_only=True)
    pub_date         = serializers.DateTimeField(source='document.pub_date', read_only=True)
    region           = serializers.SerializerMethodField()
    categories       = serializers.SerializerMethodField()
    user_name        = serializers.CharField(source='user.name', read_only=True)
    image_url        = serializers.CharField(source='document.image_url', read_only=True)

    class Meta:
        model  = DocumentScrap
        fields = [
            'id', 'user', 'user_name', 'document', 'doc_title', 
            'doc_type', 'doc_type_display', 'pub_date', 'region', 
            'categories', 'image_url', 'created_at'
        ]
        read_only_fields = ['user', 'document']
    
    def get_region(self, obj):
        try:
            region = Region.objects.get(id=obj.document.region_id)
            return RegionSimpleSerializer(region).data
        except Region.DoesNotExist:
            return None
    
    def get_categories(self, obj):
        return CategorySerializer(obj.document.categories.all(), many=True).data