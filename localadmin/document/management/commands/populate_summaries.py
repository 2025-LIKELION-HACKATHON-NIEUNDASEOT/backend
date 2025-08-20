# document/management/commands/populate_summaries.py

from django.core.management.base import BaseCommand
from document.models import Document
from document.utils import analyze_document_content

class Command(BaseCommand):
    help = 'Populates the summary field for all documents using the Gemini API.'

    def handle(self, *args, **options):
        self.stdout.write("Starting to populate summaries for all documents...")
        
        documents = Document.objects.filter(is_active=True, summary__isnull=True)
        total_documents = documents.count()
        processed_count = 0
        
        self.stdout.write(f"Found {total_documents} documents without a summary.")

        for doc in documents:
            processed_count += 1
            self.stdout.write(f"[{processed_count}/{total_documents}] Processing Document ID: {doc.id} - Title: {doc.doc_title}")
            
            analyzed_data = analyze_document_content(doc.doc_content)
            
            if analyzed_data and 'summary' in analyzed_data:
                doc.summary = analyzed_data.get('summary', '')
                try:
                    doc.save(update_fields=['summary'])
                    self.stdout.write(self.style.SUCCESS(f"  - Summary successfully saved for ID {doc.id}"))
                except Exception as e:
                    self.stdout.write(self.style.ERROR(f"  - Failed to save summary for ID {doc.id}: {e}"))
            else:
                self.stdout.write(self.style.WARNING(f"  - Failed to get a valid summary for ID {doc.id} from API."))
            
            time.sleep(1)

        self.stdout.write(self.style.SUCCESS("All documents processed. Summary population complete."))