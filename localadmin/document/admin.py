from django.contrib import admin
from .models         import Document, DocumentScrap


@admin.register(Document)
class DocumentAdmin(admin.ModelAdmin):
    """공문 관리자"""

    list_display     = [
        'id',
        'doc_title',
        'doc_type',
        'get_categories',     
        'region_id',
        'pub_date',
        'dead_date',
        'is_active',
        'scrap_count'
    ]
    list_filter      = [
        'doc_type',
        'categories',          
        'is_active',
        'pub_date'
    ]
    search_fields    = [
        'doc_title',
        'doc_content',
        'categories__category_name'
    ]
    ordering         = ['-pub_date']
    readonly_fields  = ['id', 'created_at']

    fieldsets        = (
        ('기본 정보', {
            'fields': ('doc_title', 'doc_content', 'doc_type')
        }),
        ('분류 정보', {
            'fields': ('categories', 'region_id') 
        }),
        ('일정 정보', {
            'fields': ('pub_date', 'dead_date', 'is_active')
        }),
        ('시스템 정보', {
            'fields': ('id', 'created_at'),
            'classes': ('collapse',)
        })
    )

    def scrap_count(self, obj):
        # 스크랩 수 표시
        return obj.scraps.count()
    scrap_count.short_description = '스크랩 수'

    actions = ['make_active', 'make_inactive']

    def make_active(self, request, queryset):
        updated = queryset.update(is_active=True)
        self.message_user(request, f'{updated}개 공문이 활성화되었습니다.')
    make_active.short_description = '선택한 공문 활성화'

    def make_inactive(self, request, queryset):
        updated = queryset.update(is_active=False)
        self.message_user(request, f'{updated}개 공문이 비활성화되었습니다.')
    make_inactive.short_description = '선택한 공문 비활성화'

    def get_categories(self, obj):
        # 공문의 모든 카테고리 이름을 쉼표로 연결해서 반환 
        return ", ".join([c.category_name for c in obj.categories.all()])
    get_categories.short_description = '카테고리'


@admin.register(DocumentScrap)
class DocumentScrapAdmin(admin.ModelAdmin):
    """공문 스크랩 관리자"""

    list_display     = [
        'id',
        'get_user_name',
        'get_document_title',
        'get_document_type',
        'get_document_categories'    
    ]
    list_filter      = [
        'document__doc_type',
        'document__categories'     
    ]
    search_fields    = [
        'user__name',
        'user__user_id',
        'document__doc_title'
    ]
    ordering         = ['-id']
    readonly_fields  = ['id']

    def get_user_name(self, obj):
        return f"{obj.user.name} ({obj.user.user_id})"
    get_user_name.short_description = '사용자'

    def get_document_title(self, obj):
        title = obj.document.doc_title
        return title[:50] + '...' if len(title) > 50 else title
    get_document_title.short_description = '공문 제목'

    def get_document_type(self, obj):
        return obj.document.get_doc_type_display()
    get_document_type.short_description = '공문 타입'

    def get_document_categories(self, obj):
        categories = obj.document.categories.all()
        return ", ".join([c.category_name for c in categories])
    get_document_categories.short_description = '카테고리'
