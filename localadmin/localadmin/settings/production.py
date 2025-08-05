"""
배포 환경 설정
"""
from .base import *
import environ

# django-environ 설정
env = environ.Env()
environ.Env.read_env(os.path.join(BASE_DIR, '.env'))

DEBUG = False
SECRET_KEY = env('SECRET_KEY')

# 배포 서버 설정
ALLOWED_HOSTS = env.list('ALLOWED_HOSTS', default=['54.180.238.184', 'api.villit.o-r.kr', 'villit.o-r.kr'])

# Database - AWS RDS MySQL
DATABASES = {
    'default': env.db() 
}

# AWS S3 설정
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

# CORS 설정
CORS_ALLOWED_ORIGINS = env.list('CORS_ALLOWED_ORIGINS', default=[
    "https://villit.o-r.kr",
    "https://www.villit.o-r.kr",
    "http://localhost:3000",
    "http://localhost:5173",
])

# Swagger 설정
SWAGGER_SETTINGS['DEFAULT_API_URL'] = 'https://api.villit.o-r.kr'

# 보안 설정
SECURE_SSL_REDIRECT = env.bool('SECURE_SSL_REDIRECT', default=False)  
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'

# 로깅 설정
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