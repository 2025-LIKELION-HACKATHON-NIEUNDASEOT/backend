from django.shortcuts           import redirect
from django.contrib             import admin
from django.urls                import path, re_path, include
from django.conf                import settings
from django.conf.urls.static    import static
from rest_framework             import permissions
from drf_yasg.views             import get_schema_view
from drf_yasg                   import openapi
from django.contrib.auth.models import AnonymousUser

# 사용자에 따라 OpenAPI 키를 반환하는 함수
def get_openapi_key_for_user(user):
    if user is None or isinstance(user, AnonymousUser) or not getattr(user, 'is_authenticated', False):
        # 익명 사용자는 도봉구 키 사용
        return settings.DOBONG_OPENAPI_KEY
    
    region = None
    if hasattr(user, 'profile'):
        region = getattr(user.profile, 'region', None)
        if isinstance(region, dict):
            if region.get('city') == '경기도':
                return settings.GYEONGGI_OPENAPI_KEY
    return settings.DOBONG_OPENAPI_KEY

def swagger_with_token(request):
    token = get_openapi_key_for_user(request.user)
    bearer_token = f"Bearer {token}"
    response = schema_view.with_ui('swagger', cache_timeout=0)(request)
    response.render()
    response.content = response.content.replace(
        b"SwaggerUIBundle({",
        f"SwaggerUIBundle({{requestInterceptor: function(req) {{req.headers['Authorization'] = '{bearer_token}'; return req;}}}},".encode()
    )
    return response

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

urlpatterns = [
    # 루트와 관리자
    path('', home_redirect, name='home'),
    path('admin/', admin.site.urls),
    
    # 앱 URL
    path('api/user/', include('user.urls')),
    path('api/chatbot/', include('chatbot.urls')),
    path('api/scrap/', include('scrap.urls')),
    path('api/region/', include('region.urls')), 
    path('api/documents/', include('document.urls')),
    path('api/notification/', include('notification.urls')),
    
    # DRF-yasg
    re_path(r'^swagger(?P<format>\.json|\.yaml)$', schema_view.without_ui(cache_timeout=0), name='schema-json'),
    #re_path(r'^swagger/$', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),    
    path('swagger/', swagger_with_token, name='schema-swagger-ui'),  # 관심지역별 키 자동 적용

    re_path(r'^redoc/$', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)