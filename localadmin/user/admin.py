from django.contrib import admin
from .models import User, Category, UserCategory, UserRegion


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    # 사용자 관리 페이지
    list_display = ['user_id', 'name', 'birth', 'gender', 'age', 'created_at']  
    list_filter = ['gender', 'created_at']
    search_fields = ['user_id', 'name'] 
    readonly_fields = ['created_at', 'age']
    
    fieldsets = (
        ('기본 정보', {
            'fields': ('user_id', 'name', 'birth', 'gender')  
        }),
        ('시스템 정보', {
            'fields': ('created_at', 'age'),
            'classes': ('collapse',)
        }),
    )
    
    def age(self, obj):
        return obj.age
    age.short_description = '나이'


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    # 카테고리 관리 페이지
    list_display = ['category_id', 'category_name', 'is_active', 'user_count']
    list_filter = ['is_active']
    search_fields = ['category_id', 'category_name']
    actions = ['make_active', 'make_inactive']
    
    def user_count(self, obj):
        return UserCategory.objects.filter(category=obj).count()
    user_count.short_description = '사용자 수'
    
    def make_active(self, request, queryset):
        updated = queryset.update(is_active=True)
        self.message_user(request, f'{updated}개 카테고리가 활성화되었습니다.')
    make_active.short_description = '선택한 카테고리 활성화'
    
    def make_inactive(self, request, queryset):
        updated = queryset.update(is_active=False)
        self.message_user(request, f'{updated}개 카테고리가 비활성화되었습니다.')
    make_inactive.short_description = '선택한 카테고리 비활성화'


@admin.register(UserCategory)
class UserCategoryAdmin(admin.ModelAdmin):
    # 사용자-카테고리 관계 관리 페이지
    list_display = ['id', 'get_user_id', 'get_category_name', 'created_at']
    list_filter = ['category', 'created_at']
    search_fields = ['user__user_id', 'category__category_name']
    readonly_fields = ['id', 'created_at']
    
    def get_user_id(self, obj):
        return obj.user.user_id
    get_user_id.short_description = '사용자 ID'
    
    def get_category_name(self, obj):
        return obj.category.category_name
    get_category_name.short_description = '카테고리'


@admin.register(UserRegion)
class UserRegionAdmin(admin.ModelAdmin):
    # 사용자-지역 관계 관리 페이지
    list_display = ['id', 'get_user_id', 'region_id', 'type', 'created_at']
    list_filter = ['type', 'created_at']
    search_fields = ['user__user_id', 'region_id']
    readonly_fields = ['id', 'created_at']
    
    def get_user_id(self, obj):
        return obj.user.user_id
    get_user_id.short_description = '사용자 ID'


# Admin 사이트 헤더 커스터마이징
admin.site.site_header = "Villit 관리자 페이지"
admin.site.site_title = "Villit Admin"
admin.site.index_title = "사용자 프로필 관리"