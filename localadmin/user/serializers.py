from rest_framework import serializers
from datetime import date
from .models import User, Category, UserCategory, UserRegion, GenderChoices, RegionTypeChoices


class CategorySerializer(serializers.ModelSerializer):
    # 카테고리
    
    class Meta:
        model = Category
        fields = ['id', 'category_id', 'category_name', 'is_active']


class UserCategorySerializer(serializers.ModelSerializer):
    # 사용자 관심 주제
    category = CategorySerializer(read_only=True)
    
    class Meta:
        model = UserCategory
        fields = ['id', 'category']


class UserRegionSerializer(serializers.ModelSerializer):
    # 사용자 관심 지역
    type_display = serializers.CharField(source='get_type_display', read_only=True)
    
    class Meta:
        model = UserRegion
        fields = ['id', 'region_id', 'type', 'type_display']


class UserProfileSerializer(serializers.ModelSerializer):
    # 사용자 프로필 조회
    user_categories = UserCategorySerializer(many=True, read_only=True)
    user_regions = UserRegionSerializer(many=True, read_only=True)
    gender_display = serializers.CharField(source='get_gender_display', read_only=True)
    
    class Meta:
        model = User
        fields = [
            'id', 'user_id', 'name', 'birth', 'gender', 'gender_display',
            'user_categories', 'user_regions', 'created_at'
        ]
        read_only_fields = ['id', 'user_id', 'created_at', 'age']


class UserProfileUpdateSerializer(serializers.Serializer):
    # 사용자 프로필 수정
    name = serializers.CharField(
        max_length=64,
        min_length=2,
        required=False,
        help_text='사용자 이름'
    )
    birth = serializers.DateField(
        required=False,
        allow_null=True,
        help_text='생년월일 (YYYY-MM-DD)'
    )
    gender = serializers.ChoiceField(
        choices=GenderChoices.choices,
        required=False,
        allow_null=True,
        help_text=f'성별: {", ".join([f"{choice[0]}({choice[1]})" for choice in GenderChoices.choices])}'
    )
    category_ids = serializers.ListField(
        child=serializers.CharField(max_length=50),
        required=False,
        allow_empty=True,
        help_text="관심 카테고리 ID 목록 (예: ['TRANSPORT', 'CULTURE'])"
    )
    regions = serializers.ListField(
        child=serializers.DictField(),
        required=False,
        allow_empty=True,
        help_text="관심 지역 목록 (예: [{'region_id': 'SEOUL', 'type': '거주지'}])"
    )
    
    def validate_birth(self, value):
        # 생년월일 검증
        if value and value > date.today():
            raise serializers.ValidationError("생년월일은 현재 날짜보다 이전이어야 합니다.")
        return value
    
    def validate_category_ids(self, value):
        # 카테고리 ID 목록 검증
        if value:
            unique_ids = list(set(value))
            
            existing_categories = Category.objects.filter(
                category_id__in=unique_ids,
                is_active=True
            )
            
            if len(existing_categories) != len(unique_ids):
                existing_ids = set(existing_categories.values_list('category_id', flat=True))
                invalid_ids = set(unique_ids) - existing_ids
                raise serializers.ValidationError(
                    f"존재하지 않거나 비활성화된 카테고리 ID: {list(invalid_ids)}"
                )
            
            return unique_ids
        return value
    
    def validate_regions(self, value):
        # 지역 목록 검증
        if value:
            valid_types = [choice[0] for choice in RegionTypeChoices.choices]
            
            for region_data in value:
                if 'region_id' not in region_data:
                    raise serializers.ValidationError("각 지역 데이터에 region_id가 필요합니다.")
                
                if 'type' not in region_data:
                    raise serializers.ValidationError("각 지역 데이터에 type이 필요합니다.")
                
                if region_data['type'] not in valid_types:
                    raise serializers.ValidationError(
                        f"유효하지 않은 지역 타입: {region_data['type']}. "
                        f"가능한 값: {valid_types}"
                    )
                
                if not region_data['region_id'].strip():
                    raise serializers.ValidationError("region_id는 빈 문자열일 수 없습니다.")
            
            return value
        return value