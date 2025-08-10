from django.urls import path
from . import views

app_name = 'scrap'

urlpatterns = [
    path('chatbot/',views.scrap_list_create,name='chatbot-scrap-list-create'),
    path('chatbot/<int:scrap_id>/',views.scrap_detail,name='chatbot-scrap-detail'),
]