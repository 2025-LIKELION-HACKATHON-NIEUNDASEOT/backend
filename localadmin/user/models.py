from django.db import models
from django.core.validators import MinLengthValidator


class GenderChoices(models.TextChoices):
    # 성별 선택
    MALE = 'M', '남성'
    FEMALE = 'F', '여성'
    OTHER = 'OTHER', '기타'


class RegionTypeChoices(models.TextChoices):
    # 지역 관심 유형
    RESIDENCE = '거주지', '거주지'
    INTEREST = '관심지역', '관심지역'


class BaseTimeStampModel(models.Model):
    # 공통 타임스탬프 필드
    created_at = models.DateTimeField(
        auto_now_add=True,
        verbose_name='생성일시'
    )
    
    class Meta:
        abstract = True


class User(BaseTimeStampModel):
    # 사용자 모델
    user_id = models.CharField(
        max_length=50,
        unique=True,
        validators=[MinLengthValidator(3)],
        verbose_name='사용자ID'
    )
    name = models.CharField(
        max_length=64,
        validators=[MinLengthValidator(2)],
        verbose_name='이름',
        help_text='사용자 이름'
    )
    birth = models.DateField(
        null=True,
        blank=True,
        verbose_name='생년월일'
    )
    gender = models.CharField(
        max_length=10,
        choices=GenderChoices.choices,
        null=True,
        blank=True,
        verbose_name='성별'
    )

    class Meta:
        db_table = 'user'
        verbose_name = '사용자'
        verbose_name_plural = '사용자들'

    def __str__(self):
        return f"{self.name} ({self.user_id})"
    
    @property
    def age(self):
        # 나이 계산
        if self.birth:
            from datetime import date
            today = date.today()
            return today.year - self.birth.year - (
                (today.month, today.day) < (self.birth.month, self.birth.day)
            )
        return None


class Category(models.Model):
    # 카테고리 모델
    category_id = models.CharField(
        max_length=50,
        unique=True,
        verbose_name='카테고리ID'
    )
    category_name = models.CharField(
        max_length=64,
        unique=True,
        verbose_name='카테고리명'
    )
    is_active = models.BooleanField(
        default=True,
        verbose_name='활성화 여부'
    )

    class Meta:
        db_table = 'category'
        verbose_name = '카테고리'
        verbose_name_plural = '카테고리들'
        ordering = ['category_name']

    def __str__(self):
        return self.category_name


class UserCategory(BaseTimeStampModel):
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='user_categories',
        verbose_name='사용자'
    )
    category = models.ForeignKey(
        Category,
        on_delete=models.CASCADE,
        verbose_name='카테고리'
    )

    class Meta:
        db_table = 'user_category'
        verbose_name = '사용자 관심 주제'
        unique_together = ('user', 'category')

    def __str__(self):
        return f"{self.user.user_id} → {self.category.category_name}"


class UserRegion(BaseTimeStampModel):
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='user_regions',
        verbose_name='사용자'
    )
    # 추후 지역 관련 개발이 완료되면 field 연결 예정
    region_id = models.CharField(
        max_length=50,
        verbose_name='지역ID'
    )
    type = models.CharField(
        max_length=20,
        choices=RegionTypeChoices.choices,
        verbose_name='지역 타입'
    )

    class Meta:
        db_table = 'user_region'
        verbose_name = '사용자 관심 지역'
        unique_together = ('user', 'region_id')

    def __str__(self):
        return f"{self.user.user_id} → {self.region_id} ({self.type})"