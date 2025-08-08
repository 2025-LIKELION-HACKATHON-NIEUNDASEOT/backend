from django.shortcuts import redirect
from django.contrib import admin
from django.urls import path, re_path, include

from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from django.conf import settings
from django.conf.urls.static import static
from rest_framework import permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from drf_yasg.utils import swagger_auto_schema

def home_redirect(request):
    return redirect('/swagger/')

schema_view = get_schema_view(
    openapi.Info(
        title="Villit API",
        default_version='v1',
        description="Villit API documentation",
        terms_of_service="https://www.google.com/policies/terms/",
        contact=openapi.Contact(email="contact@villit.local"),
        license=openapi.License(name="BSD License"),
    ),
    public=True,
    permission_classes=(permissions.AllowAny,),
)

@swagger_auto_schema(
    method='get',
    operation_description="서버 상태 확인",
    responses={200: openapi.Response('서버 정상', openapi.Schema(
        type=openapi.TYPE_OBJECT,
        properties={
            'status': openapi.Schema(type=openapi.TYPE_STRING, description='서버 상태'),
        }
    ))}
)
@api_view(['GET'])
@permission_classes([permissions.AllowAny])
def health_check(request):
    # 서버 헬스 체크 api
    return Response({"status": "OK"})

urlpatterns = [
    # 루트 URL (swagger)
    path('', home_redirect, name='home'),
    
    # 관리자 페이지
    path('admin/', admin.site.urls),
    
    # 앱 URL
    path('api/user/', include('user.urls')),
    path('api/', include('region.urls')), # region 앱
    
    # DRF-yasg
    re_path(r'^swagger(?P<format>\.json|\.yaml)$', schema_view.without_ui(cache_timeout=0), name='schema-json'),
    re_path(r'^swagger/$', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    re_path(r'^redoc/$', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
    
    # 헬스체크
    path('actuator/health', health_check, name='health-check'),
]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
