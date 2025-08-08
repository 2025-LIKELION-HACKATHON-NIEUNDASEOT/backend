from django.db import models
from django.db import models

class Region(models.Model):
    # region_code는 시/도 코드와 구/군 코드를 합친 고유 코드
    region_code = models.CharField(max_length=10, unique=True)
    city = models.CharField(max_length=20)  # 예: 서울특별시, 경기도
    district = models.CharField(max_length=20, blank=True, null=True) # 예: 도봉구, 종로구

    def __str__(self):
        if self.district:
            return f"{self.city} {self.district}"
        return self.city