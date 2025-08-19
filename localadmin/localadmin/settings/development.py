from .base import *
import os
from environ import Env
from django.core.exceptions import ImproperlyConfigured

env = Env()
env_file = os.path.join(BASE_DIR, '.env.local')
if os.path.exists(env_file):
    env.read_env(env_file)
else:
    raise ImproperlyConfigured(".env.local 파일이 없습니다.")

DEBUG      = True
SECRET_KEY = env('SECRET_KEY')


# 키 설정
SGIS_CONSUMER_KEY    = env('SGIS_CONSUMER_KEY', default=None)
SGIS_CONSUMER_SECRET = env('SGIS_CONSUMER_SECRET', default=None)
GEMINI_API_KEY       = env('GEMINI_API_KEY', default=None)
if GEMINI_API_KEY:
    os.environ['GEMINI_API_KEY'] = GEMINI_API_KEY
DOBONG_OPENAPI_KEY   = env('DOBONG_OPENAPI_KEY', default=None)
GYEONGGI_OPENAPI_KEY = env('GYEONGGI_OPENAPI_KEY', default=None)
JONGNO_OPENAPI_KEY = env ('JONGNO_OPENAPI_KEY', default=None)
FIREBASE_CREDENTIALS_PATH = env('FIREBASE_CREDENTIALS_PATH')


ALLOWED_HOSTS          = ['*']
CORS_ALLOW_ALL_ORIGINS = True

DATABASES = {
    'default': env.db_url('DATABASE_URL')
}

SWAGGER_SETTINGS['DEFAULT_API_URL'] = "http://localhost:8000"

LOGGING = {
    'version'                 : 1,
    'disable_existing_loggers': False,
    'handlers'                : {
        'console': {'class': 'logging.StreamHandler'},
    },
    'loggers': {
        'django.db.backends': {
            'handlers' : ['console'],
            'level'    : 'INFO', #원래 DEBUG
            'propagate': False,
        },
    },
}
