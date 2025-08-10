"""
개발 환경 설정
"""
from .base import *
from django.core.exceptions import ImproperlyConfigured

# 개발 환경용 .env.local 파일 로드
if not load_env_file('.env.local'):
    raise ImproperlyConfigured(".env.local 파일을 찾을 수 없습니다. 프로젝트 루트에 생성해 주세요.")

# 공통 환경변수 설정
setup_common_env_vars()

DEBUG = True
SECRET_KEY = env('SECRET_KEY')

ALLOWED_HOSTS = ['*']

# Database
DATABASES = {
    'default': env.db_url('DATABASE_URL')
}

# Static files
STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

# CORS
CORS_ALLOW_ALL_ORIGINS = True

# Swagger 설정 - 개발 환경
SWAGGER_SETTINGS['DEFAULT_API_URL'] = 'http://localhost:8000'

# 로깅 설정 - SQL 쿼리 출력
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
        },
    },
    'loggers': {
        'django.db.backends': {
            'handlers': ['console'],
            'level': 'DEBUG',
            'propagate': False,
        },
    },
}