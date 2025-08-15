from django.urls import path
from . import views

urlpatterns = [
    # 공문 데이터 저장
    path('bulk-save/', views.save_documents_from_api, name='bulk_save_documents'),
    
    # 공문 조회 (최신순 + 필터링)
    path('', views.DocumentListView.as_view(), name='document_list'),
    path('<int:pk>/', views.DocumentDetailView.as_view(), name='document_detail'),
    
    path('region/<int:region_id>/recent/', views.get_recent_region_news, name='recent_region_news'),
    path('categories/recent-alerts/', views.get_recent_category_alerts, name='recent_category_alerts'),
    
    path('upcoming-deadlines/', views.upcoming_deadlines_api, name='upcoming_document_deadlines'),
    path('search/', views.all_documents_search_api, name='all_documents_search'),
]
