from rest_framework           import serializers
from .models                  import ChatbotScrap
from document.models          import Category

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