"""
개발 환경 설정
"""
from .base import *
from environ import Env as Environ
from django.core.exceptions import ImproperlyConfigured

# django-environ
env = Environ()
env_file = os.path.join(BASE_DIR, '.env.local')
if os.path.exists(env_file):
    env.read_env(env_file)
else:
    raise ImproperlyConfigured(".env.local 파일을 찾을 수 없습니다. 프로젝트 루트에 생성해 주세요.")


DEBUG = True
SECRET_KEY = env('SECRET_KEY')

# Gemini API 설정
GEMINI_API_KEY = env('GEMINI_API_KEY')
os.environ['GEMINI_API_KEY'] = GEMINI_API_KEY


ALLOWED_HOSTS = ['*']

# Database
# .env.local
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