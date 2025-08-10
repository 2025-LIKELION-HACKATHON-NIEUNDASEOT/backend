import requests
from django.conf import settings
from django.core.management.base import BaseCommand
from region.models import Region # Region 모델

class Command(BaseCommand):
    help = 'Loads region data from the SGIS API'
    
    def get_access_token(self):
        # SGIS API 인증 토큰
        auth_url = 'https://sgisapi.kostat.go.kr/OpenAPI3/auth/authentication.json'
        payload = {
            'consumer_key': settings.SGIS_CONSUMER_KEY,
            'consumer_secret': settings.SGIS_CONSUMER_SECRET # .env.local에 저장된 키
        }
        response = requests.get(auth_url, params=payload)
        response.raise_for_status()
        return response.json()['result']['accessToken']

    def handle(self, *args, **options):
        # 인증 토큰 발급
        access_token = self.get_access_token()
        self.stdout.write(self.style.SUCCESS(f"SGIS Access Token: {access_token}"))
        
        # 시도 데이터 로드
        city_url = 'https://sgisapi.kostat.go.kr/OpenAPI3/addr/stage.json'
        city_params = {'accessToken': access_token}
        response = requests.get(city_url, params=city_params)
        response.raise_for_status()
        print(response.json())
        cities = response.json()['result']

        for city_data in cities:
            Region.objects.get_or_create(
                region_code=city_data['cd'],
                defaults={
                    'city': city_data['addr_name'],
                    'district': None
                }
            )
            # 출력 테스트용 self.stdout.write(self.style.SUCCESS(f"Saved City: {city_data['addr_name']}"))


            # 각 시도의 시군구 데이터 로드
            district_url = 'https://sgisapi.kostat.go.kr/OpenAPI3/addr/stage.json'
            district_params = {
                'accessToken': access_token,
                'cd': city_data['cd']
            }
            response_district = requests.get(district_url, params=district_params)
            response_district.raise_for_status()
            districts = response_district.json()['result']

            for district_data in districts:
                if len(district_data['cd']) == 5:
                    Region.objects.get_or_create(
                        region_code=district_data['cd'],
                        defaults={
                            'city': city_data['addr_name'],
                            'district': district_data['addr_name'],
                        }
                    )
                # 출력 테스트용 self.stdout.write(self.style.SUCCESS(f"Saved District: {district_data['addr_name']}"))