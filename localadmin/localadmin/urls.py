from django.shortcuts           import redirect
from django.contrib             import admin
from django.urls                import path, re_path, include
from django.conf                import settings
from django.conf.urls.static    import static
from rest_framework             import permissions
from drf_yasg.views             import get_schema_view
from drf_yasg                   import openapi

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
    path('api/', include('region.urls')), 
    
    # DRF-yasg
    re_path(r'^swagger(?P<format>\.json|\.yaml)$', schema_view.without_ui(cache_timeout=0), name='schema-json'),
    re_path(r'^swagger/$', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    re_path(r'^redoc/$', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
