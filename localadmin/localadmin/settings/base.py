from pathlib import Path
import os
import environ

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent.parent

# django-environ 초기화 (모든 환경에서 공통 사용)
env = environ.Env(
    DEBUG=(bool, False)
)

# 환경별 .env 파일 로드 (각 환경 설정에서 호출)
def load_env_file(env_filename):
    """환경에 맞는 .env 파일 로드"""
    env_file = os.path.join(BASE_DIR, env_filename)
    if os.path.exists(env_file):
        env.read_env(env_file)
        return True
    return False


# 공통 환경변수 설정 (모든 환경에서 사용)
def setup_common_env_vars():
    """공통 환경변수들을 설정"""
    # SGIS 키 설정
    global SGIS_CONSUMER_KEY, SGIS_CONSUMER_SECRET, GEMINI_API_KEY
    
    SGIS_CONSUMER_KEY = env('SGIS_CONSUMER_KEY', default=None)
    SGIS_CONSUMER_SECRET = env('SGIS_CONSUMER_SECRET', default=None)
    
    # Gemini API 설정
    GEMINI_API_KEY = env('GEMINI_API_KEY', default=None)
    if GEMINI_API_KEY:
        os.environ['GEMINI_API_KEY'] = GEMINI_API_KEY


# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    
    'rest_framework',
    'drf_yasg', 
    'corsheaders', 
    'storages',  
    
    'user',
    'chatbot',
    'scrap',
    'document',
    'region',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'localadmin.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'localadmin.wsgi.application'

# Password validation
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# Internationalization
LANGUAGE_CODE = 'ko-kr'
TIME_ZONE = 'Asia/Seoul'
USE_I18N = True
USE_TZ = True

# Default primary key field type
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# REST Framework
REST_FRAMEWORK = {
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.AllowAny',
    ],
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 10,
}

# Swagger
SWAGGER_SETTINGS = {
    'USE_SESSION_AUTH': False,
    'JSON_EDITOR': True,
    'SUPPORTED_SUBMIT_METHODS': [
        'get',
        'post',
        'put',
        'delete',
        'patch'
    ],
}