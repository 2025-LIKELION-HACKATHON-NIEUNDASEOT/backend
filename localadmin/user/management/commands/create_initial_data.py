from datetime            import date

from django.core.management.base import BaseCommand, CommandError

from user.models          import User, Category, UserCategory, UserRegion, GenderChoices, RegionTypeChoices
from region.models        import Region


class Command(BaseCommand):
    help = '사용자 프로필 시스템의 초기 데이터를 생성합니다.'

    def add_arguments(self, parser):
        parser.add_argument(
            '--force',
            action    = 'store_true',
            help      = '기존 데이터가 있어도 강제로 생성합니다.',
        )

    def handle(self, *args, **options):
        self.stdout.write(self.style.SUCCESS('=== 초기 데이터 생성을 시작합니다 ==='))

        force = options['force']

        try:
            self.create_categories(force)
            self.create_guest_user(force)
            self.create_user_categories(force)
            self.create_user_regions(force)

            self.stdout.write(self.style.SUCCESS('=== 초기 데이터 생성이 완료되었습니다 ==='))

        except Exception as error:
            raise CommandError(f'초기 데이터 생성 중 오류가 발생했습니다: {str(error)}')

    def create_categories(self, force=False):
        self.stdout.write('카테고리 데이터를 생성중입니다...')

        categories_data = [
            {'category_name': '교통'},
            {'category_name': '문화'},
            {'category_name': '주택'},
            {'category_name': '경제'},
            {'category_name': '환경'},
            {'category_name': '안전'},
            {'category_name': '복지'},
            {'category_name': '행정'},
        ]

        created_count = 0
        for category_data in categories_data:
            category, created = Category.objects.get_or_create(
                category_name = category_data['category_name'],
                defaults      = {'is_active': True}
            )

            if created or force:
                if not created and force:
                    category.is_active = True
                    category.save()
                created_count += 1
                self.stdout.write(f'  - {category.category_name} 카테고리 생성')
        
        self.stdout.write(self.style.SUCCESS(f'카테고리 {created_count}개 생성 완료'))

    def create_guest_user(self, force=False):
        self.stdout.write('게스트 사용자를 생성중입니다...')

        user_data = {
            'user_id' : 'GUEST1',
            'name'    : '김덕사',
            'birth'   : date(2000, 1, 1),
            'gender'  : GenderChoices.FEMALE
        }

        user, created = User.objects.get_or_create(
            user_id  = user_data['user_id'],
            defaults = user_data
        )

        if created or force:
            if not created and force:
                for key, value in user_data.items():
                    setattr(user, key, value)
                user.save()
            self.stdout.write(f'  - 게스트 사용자 {user.name} ({user.user_id}) 생성 완료')

        self.stdout.write(self.style.SUCCESS('게스트 사용자 생성 완료'))

    def create_user_categories(self, force=False):
        self.stdout.write('사용자-카테고리 관계를 생성중입니다...')

        try:
            user                = User.objects.get(user_id='GUEST1')
            transport_category  = Category.objects.get(category_name='교통')
            culture_category    = Category.objects.get(category_name='문화')

            if force:
                UserCategory.objects.filter(user=user).delete()

            categories_to_add   = [transport_category, culture_category]
            created_count       = 0

            for idx, category in enumerate(categories_to_add, 1):
                user_category, created = UserCategory.objects.get_or_create(
                    user     = user,
                    category = category,
                )

                if created:
                    created_count += 1
                    self.stdout.write(
                        f'  - {user.name}님의 {category.category_name} 관심 분야 생성'
                    )

            self.stdout.write(
                self.style.SUCCESS(f'사용자-카테고리 관계 {created_count}개 생성 완료')
            )

        except (User.DoesNotExist, Category.DoesNotExist) as error:
            self.stdout.write(
                self.style.ERROR(f'사용자-카테고리 관계 생성 실패: {str(error)}')
            )

    def create_user_regions(self, force=False):
        self.stdout.write('사용자-지역 관계를 생성중입니다...')

        try:
            user = User.objects.get(user_id='GUEST1')

            if force:
                UserRegion.objects.filter(user=user).delete()

            # PK 기반 관심 지역 생성 
            regions_to_add = [
                {'region_id': 6, 'type': RegionTypeChoices.RESIDENCE},    
                {'region_id': 24, 'type': RegionTypeChoices.INTEREST}     
            ]

            created_count = 0
            for idx, region_data in enumerate(regions_to_add, 1):
                region_obj = Region.objects.get(id=region_data['region_id'])
                user_region, created = UserRegion.objects.get_or_create(
                    user   = user,
                    region = region_obj,
                    defaults = {
                        'type': region_data['type']
                    }
                )

                if created:
                    created_count += 1
                    self.stdout.write(
                        f'  - {user.name}님의 {region_obj} ({region_data["type"]}) 지역 관심 생성'
                    )

            self.stdout.write(
                self.style.SUCCESS(f'사용자-지역 관계 {created_count}개 생성 완료')
            )

        except User.DoesNotExist as error:
            self.stdout.write(
                self.style.ERROR(f'사용자-지역 관계 생성 실패: {str(error)}')
            )
        except Region.DoesNotExist as error:
            self.stdout.write(
                self.style.ERROR(f'지정된 지역(pk) 조회 실패: {str(error)}')
            )
