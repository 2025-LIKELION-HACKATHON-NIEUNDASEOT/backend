from django.contrib import admin

from .models import FCMDevice, Notification


@admin.register(FCMDevice)
class FCMDeviceAdmin(admin.ModelAdmin):
    list_display      = (
        'id',
        'user',
        'device_type',
        'registration_token',
        'is_active',
        'created_at',
    )
    list_filter       = (
        'device_type',
        'is_active',
        'created_at',
    )
    search_fields     = (
        'user__name',
        'registration_token',
    )
    readonly_fields   = (
        'created_at',
    )


@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    exclude = ('title','content')
    list_display      = (
        'id',
        'title',
        'content',
        'is_read',
        'notification_time',
        'read_time',
        'user',
        'document',
    )
    list_filter       = (
        'is_read',
        'notification_time',
        'user',
        'document',
    )
    search_fields     = (
        'title',
        'content',
        'user__name',
        'document__doc_title',
    )
    readonly_fields   = (
        'notification_time',
        'read_time',
        'created_at',
    )
    def save_model(self, request, obj, form, change):
        if not change and not obj.title:
            obj.title = obj.document.doc_title
        super().save_model(request, obj, form, change)
