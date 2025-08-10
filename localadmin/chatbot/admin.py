from django.contrib import admin
from .models        import ChatbotSession, ChatbotMessage


@admin.register(ChatbotSession)
class ChatbotSessionAdmin(admin.ModelAdmin):
    list_display      = [
        'id',
        'title',
        'user',
        'is_active',
        'created_at',
        'message_count'
    ]
    list_filter       = [
        'is_active',
        'created_at'
    ]
    search_fields     = [
        'title',
        'user__name',
        'user__user_id'
    ]
    ordering          = ['-created_at']
    readonly_fields   = ['created_at']

    def message_count(self, obj):
        return obj.messages.count()
    message_count.short_description = '메시지 수'


@admin.register(ChatbotMessage)
class ChatbotMessageAdmin(admin.ModelAdmin):
    list_display     = [
        'id',
        'chatbot_session',
        'speaker',
        'content_preview',
        'created_at'
    ]
    list_filter      = [
        'speaker',
        'created_at'
    ]
    search_fields    = [
        'content',
        'chatbot_session__title'
    ]
    ordering         = ['-created_at']
    readonly_fields  = ['created_at']

    def content_preview(self, obj):
        if obj.content:
            return obj.content[:50] + '...' if len(obj.content) > 50 else obj.content
        return '-'
    content_preview.short_description = '내용'