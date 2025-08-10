from .base import *
import os
import environ

env = environ.Env(DEBUG=(bool, False))
env.read_env(os.path.join(BASE_DIR, '.env'))

DEBUG      = False
SECRET_KEY = env('SECRET_KEY')


# 키 설정
SGIS_CONSUMER_KEY    = env('SGIS_CONSUMER_KEY', default=None)
SGIS_CONSUMER_SECRET = env('SGIS_CONSUMER_SECRET', default=None)
GEMINI_API_KEY       = env('GEMINI_API_KEY', default=None)
if GEMINI_API_KEY:
    os.environ['GEMINI_API_KEY'] = GEMINI_API_KEY


ALLOWED_HOSTS = env.list('ALLOWED_HOSTS', default=[
    '54.180.238.184',
    'villit.o-r.kr',
    'localhost',
    '127.0.0.1',
    '0.0.0.0',
])

DATABASES = {
    'default': env.db()
}

DEFAULT_FILE_STORAGE    = 'storages.backends.s3boto3.S3Boto3Storage'
STATICFILES_STORAGE     = 'storages.backends.s3boto3.S3StaticStorage'
AWS_ACCESS_KEY_ID       = env('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY   = env('AWS_SECRET_ACCESS_KEY')
AWS_STORAGE_BUCKET_NAME = env('AWS_STORAGE_BUCKET_NAME')
AWS_S3_REGION_NAME      = env('AWS_S3_REGION_NAME', default='ap-northeast-2')
AWS_S3_CUSTOM_DOMAIN    = f'{AWS_STORAGE_BUCKET_NAME}.s3.{AWS_S3_REGION_NAME}.amazonaws.com'
AWS_S3_OBJECT_PARAMETERS = {'CacheControl': 'max-age=86400'}

STATIC_URL = f'https://{AWS_S3_CUSTOM_DOMAIN}/static/'
MEDIA_URL  = f'https://{AWS_S3_CUSTOM_DOMAIN}/media/'

CORS_ALLOWED_ORIGINS = env.list('CORS_ALLOWED_ORIGINS', default=[])

SWAGGER_SETTINGS['DEFAULT_API_URL'] = 'https://villit.o-r.kr'

SECURE_SSL_REDIRECT         = env.bool('SECURE_SSL_REDIRECT', default=False)
SESSION_COOKIE_SECURE       = True
CSRF_COOKIE_SECURE          = True
SECURE_BROWSER_XSS_FILTER   = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS             = 'DENY'

LOGGING = {
    'version'                 : 1,
    'disable_existing_loggers': False,
    'handlers'                : {
        'file': {
            'level'   : 'INFO',
            'class'   : 'logging.FileHandler',
            'filename': '/var/log/django/debug.log',
        },
    },
    'loggers': {
        'django': {
            'handlers' : ['file'],
            'level'    : 'INFO',
            'propagate': True,
        },
    },
}
