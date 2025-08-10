"""
배포 환경 설정
"""
from .base import *
from django.core.exceptions import ImproperlyConfigured

# 배포 환경용 .env 파일 로드
if not load_env_file('.env'):
    raise ImproperlyConfigured(".env 파일을 찾을 수 없습니다. 배포 서버에 .env 파일을 생성해 주세요.")

# 공통 환경변수 설정
setup_common_env_vars()

DEBUG = False
SECRET_KEY = env('SECRET_KEY')

# 배포 서버
ALLOWED_HOSTS = env.list('ALLOWED_HOSTS', default=[
    '54.180.238.184', 
    'villit.o-r.kr',
    'localhost',
    '127.0.0.1',
    '0.0.0.0',
])

# Database - AWS RDS MySQL
DATABASES = {
    'default': env.db() 
}

# AWS S3
DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
STATICFILES_STORAGE = 'storages.backends.s3boto3.S3StaticStorage'

AWS_ACCESS_KEY_ID = env('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = env('AWS_SECRET_ACCESS_KEY')
AWS_STORAGE_BUCKET_NAME = env('AWS_STORAGE_BUCKET_NAME')
AWS_S3_REGION_NAME = env('AWS_S3_REGION_NAME', default='ap-northeast-2')
AWS_S3_CUSTOM_DOMAIN = f'{AWS_STORAGE_BUCKET_NAME}.s3.{AWS_S3_REGION_NAME}.amazonaws.com'
AWS_S3_OBJECT_PARAMETERS = {
    'CacheControl': 'max-age=86400',
}

STATIC_URL = f'https://{AWS_S3_CUSTOM_DOMAIN}/static/'
MEDIA_URL = f'https://{AWS_S3_CUSTOM_DOMAIN}/media/'

# CORS
CORS_ALLOWED_ORIGINS = env.list('CORS_ALLOWED_ORIGINS', default=[
    "https://villit.o-r.kr",
    "https://www.villit.o-r.kr",
    "http://localhost:3000",
    "http://localhost:5173",
])

# Swagger
SWAGGER_SETTINGS['DEFAULT_API_URL'] = 'https://villit.o-r.kr'

# 보안
SECURE_SSL_REDIRECT = env.bool('SECURE_SSL_REDIRECT', default=False)  
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'

# 로깅
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'file': {
            'level': 'INFO',
            'class': 'logging.FileHandler',
            'filename': '/var/log/django/debug.log',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file'],
            'level': 'INFO',
            'propagate': True,
        },
    },
}