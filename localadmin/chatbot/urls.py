from django.urls import path
from . import views

app_name = 'chatbot'

urlpatterns = [
    # 세션
    path('sessions/', views.session_create, name='session-create'),
    path('sessions/<int:session_id>/', views.session_detail, name='session-detail'),
    
    # 메시지 
    path('sessions/<int:session_id>/messages/', views.send_message, name='send-message'),
]