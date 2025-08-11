from django.contrib import admin
from .models         import ChatbotScrap, DocumentScrap

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

@admin.register(DocumentScrap)
class DocumentScrapAdmin(admin.ModelAdmin):
    """공문 스크랩 관리자"""
    list_display = [
        'id', 'get_user_name', 'get_document_title', 
        'get_document_type', 'created_at'
    ]
    list_filter = [
        'document__doc_type', 'created_at', 
        'document__categories'
    ]
    search_fields = [
        'user__name', 'user__user_id', 
        'document__doc_title'
    ]
    date_hierarchy = 'created_at'
    ordering       = ['-created_at']
    
    readonly_fields = ['created_at']
    
    def get_user_name(self, obj):
        return obj.user.name
    get_user_name.short_description = '사용자'
    get_user_name.admin_order_field = 'user__name'
    
    def get_document_title(self, obj):
        return obj.document.doc_title
    get_document_title.short_description = '공문 제목'
    get_document_title.admin_order_field = 'document__doc_title'
    
    def get_document_type(self, obj):
        return obj.document.get_doc_type_display()
    get_document_type.short_description = '공문 타입'
    get_document_type.admin_order_field = 'document__doc_type'