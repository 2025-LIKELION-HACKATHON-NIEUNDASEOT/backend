from django.urls import path
from . import views

app_name = 'notification'

urlpatterns = [
    # 알림 
    path('notification/', views.NotificationListView.as_view(), name='notification-list'),
    path('notification/<int:notification_id>/read/', views.mark_notification_as_read, name='notification-mark-read'),
    
    # FCM 푸시 알림
    path('fcm/register/', views.register_fcm_token, name='fcm-register'),
    path('fcm/test/', views.send_test_push_notification, name='fcm-test'),
]
