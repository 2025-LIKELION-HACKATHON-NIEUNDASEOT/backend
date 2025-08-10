from rest_framework import serializers
from .models        import ChatbotSession, ChatbotMessage
from document.models import Document, Category


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model  = Category
        fields = ['id', 'category_name']


class DocumentInfoSerializer(serializers.ModelSerializer):
    categories = CategorySerializer(many=True, read_only=True)
    pub_date   = serializers.DateTimeField(format='%Y-%m-%d', read_only=True)
    dead_date  = serializers.DateTimeField(format='%Y-%m-%d', read_only=True)

    class Meta:
        model  = Document
        fields = [
            'id',
            'doc_title',
            'doc_content',
            'doc_type',
            'categories',   
            'pub_date',
            'dead_date',
            'region_id'
        ]


class ChatbotMessageSerializer(serializers.ModelSerializer):
    created_at = serializers.DateTimeField(format='%Y-%m-%d %H:%M:%S', read_only=True)

    class Meta:
        model  = ChatbotMessage
        fields = ['id', 'speaker', 'content', 'created_at']
        read_only_fields = ['id', 'created_at']


class ChatbotSessionSerializer(serializers.ModelSerializer):
    messages      = ChatbotMessageSerializer(many=True, read_only=True)
    created_at    = serializers.DateTimeField(format='%Y-%m-%d %H:%M:%S', read_only=True)
    user_name     = serializers.CharField(source='user.name', read_only=True)
    message_count = serializers.IntegerField(source='messages.count', read_only=True)
    title         = serializers.CharField(read_only=True)
    document      = DocumentInfoSerializer(read_only=True)

    class Meta:
        model  = ChatbotSession
        fields = [
            'id', 'title', 'is_active', 'created_at', 'user', 'user_name',
            'document', 'messages', 'message_count'
        ]
        read_only_fields = ['id', 'created_at', 'user']


class ChatbotSessionListSerializer(serializers.ModelSerializer):
    created_at    = serializers.DateTimeField(format='%Y-%m-%d %H:%M:%S', read_only=True)
    user_name     = serializers.CharField(source='user.name', read_only=True)
    message_count = serializers.IntegerField(source='messages.count', read_only=True)
    title         = serializers.CharField(read_only=True)
    categories    = serializers.SerializerMethodField()
    last_message  = serializers.SerializerMethodField()

    class Meta:
        model  = ChatbotSession
        fields = [
            'id', 'title', 'is_active', 'created_at', 'user_name',
            'categories', 'message_count', 'last_message'
        ]

    def get_categories(self, obj):
        if obj.document:
            return [{'id': c.id, 'name': c.category_name} for c in obj.document.categories.all()]
        return []

    def get_last_message(self, obj):
        last_msg = obj.messages.last()
        if last_msg:
            return {
                'speaker'    : last_msg.speaker,
                'content'    : last_msg.content[:50] + '...' if len(last_msg.content) > 50 else last_msg.content,
                'created_at' : last_msg.created_at.strftime('%Y-%m-%d %H:%M:%S')
            }
        return None


class ChatbotMessageCreateSerializer(serializers.Serializer):
    message = serializers.CharField(
        required   = True,
        min_length = 1,
        max_length = 1000,
        help_text  = "사용자 메시지"
    )

    def validate_message(self, value):
        if not value.strip():
            raise serializers.ValidationError("메시지는 비어있을 수 없습니다.")
        return value.strip()


class ChatbotSessionCreateSerializer(serializers.Serializer):
    document_id     = serializers.IntegerField(
        required     = True,
        help_text    = "연결할 공문 ID"
    )
    initial_message = serializers.CharField(
        required     = False,
        allow_null   = False,
        trim_whitespace = True, 
        max_length   = 1000,
        help_text    = "초기 메시지"
    )

    def validate_document_id(self, value):
        if not Document.objects.filter(id=value, is_active=True).exists():
            raise serializers.ValidationError("존재하지 않거나 비활성화된 공문입니다.")
        return value

    def validate_initial_message(self, value):
        if not value.strip():
            raise serializers.ValidationError("메시지는 비어 있을 수 없습니다.")
        return value.strip()