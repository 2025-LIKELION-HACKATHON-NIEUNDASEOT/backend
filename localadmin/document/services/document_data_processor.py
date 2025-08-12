class DocumentDataProcessor:
    @staticmethod
    def process_seoul_api_data(api_data, region_id):
        return api_data

    @staticmethod
    def process_api_data(raw_doc, region_id):
        processed_doc = {
            'title': raw_doc.get('title'),
            'content': raw_doc.get('content'),
            'pub_date': raw_doc.get('date'),
            'deadline': raw_doc.get('deadline'),
            'category': raw_doc.get('category'),
            'department': raw_doc.get('department'),
            'region_id': region_id,
        }
        return processed_doc
