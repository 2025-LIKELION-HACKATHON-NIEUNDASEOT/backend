# localadmin/settings/__init__.py
import os

# DJANGO_SETTINGS_MODULE
environment = os.environ.get('DJANGO_ENV', 'development')

print(f"Loading settings for environment: {environment}")

if environment == 'production':
    from .production import *
else:
    from .development import *
