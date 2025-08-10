from django.contrib import admin
from .models         import ChatbotScrap

@admin.register(ChatbotScrap)
class ChatbotScrapAdmin(admin.ModelAdmin):
    """챗봇 스크랩 관리자"""
    list_display = [
        'id',
        'user',
        'summary',
        'chatbot_session',
        'created_at'
    ]
    list_filter = [
        'created_at',
        'user'
    ]
    search_fields = [
        'summary',
        'user__username'
    ]
    ordering = ['-created_at']
    readonly_fields = [
        'created_at',
        'user_message',
        'ai_message'
    ]
    fieldsets = (
        ('기본 정보', {
            'fields': (
                'user',
                'summary'
            )
        }),
        ('세션 정보', {
            'fields': (
                'chatbot_session',
                'user_message',
                'ai_message'
            )
        }),
        ('시스템 정보', {
            'fields': ('created_at',)
        })
    )
