# localadmin/settings/__init__.py
import os

# DJANGO_SETTINGS_MODULE 
# 기본값은 development
environment = os.environ.get('DJANGO_ENV', 'development')

if environment == 'production':
    from .production import *
else:
    from .development import *