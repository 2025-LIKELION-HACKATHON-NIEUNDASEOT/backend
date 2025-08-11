from django.urls import path
from .views import *

app_name = 'scrap'

urlpatterns = [
    # 챗봇 스크랩
    path('chatbot/', scrap_list_create,name='chatbot-scrap-list-create'),
    path('chatbot/<int:scrap_id>/', scrap_detail,name='chatbot-scrap-detail'),
    
    # 공문 스크랩
    path('documents/', document_scrap_list_create, name='document-scrap-list-create'),
    path('documents/<int:scrap_id>/', document_scrap_delete, name='document-scrap-delete'),
]