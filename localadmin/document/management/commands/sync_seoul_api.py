from django.core.management.base import BaseCommand
from django.conf import settings
from ...services.seoul_api_service import DocumentService

class Command(BaseCommand):
    help = 'Sync documents from Seoul OpenAPI'
    
    def add_arguments(self, parser):
        parser.add_argument(
            '--region-id',
            type=int,
            required=True,
            help='Region ID to sync data for'
        )
        parser.add_argument(
            '--service-name',
            type=str,
            required=True,
            help='Seoul API service name'
        )
        parser.add_argument(
            '--api-key',
            type=str,
            help='Seoul API key (optional, uses settings if not provided)'
        )
    
    def handle(self, *args, **options):
        region_id = options['region_id']
        service_name = options['service_name']
        api_key = options.get('api_key')
        
        self.stdout.write(
            f'Starting sync for region {region_id}, service: {service_name}'
        )
        
        created_documents = DocumentService.sync_seoul_api_data(
            region_id=region_id,
            service_name=service_name,
            api_key=api_key
        )
        
        self.stdout.write(
            self.style.SUCCESS(
                f'Successfully synced {len(created_documents)} documents'
            )
        )