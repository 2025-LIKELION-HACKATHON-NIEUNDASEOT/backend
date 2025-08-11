from django.urls import path
from . import views

urlpatterns = [
    # 데이터 저장
    path('save/', views.save_single_document, name='save_document'),
    path('bulk-save/', views.save_documents_from_api, name='bulk_save_documents'),
    
    # 조회
    path('', views.DocumentListView.as_view(), name='document_list'),
    path('<int:pk>/', views.DocumentDetailView.as_view(), name='document_detail'),
    path('region/<int:region_id>/', views.get_documents_by_region, name='documents_by_region'),
    path('urgent/', views.get_urgent_documents, name='urgent_documents'),
]