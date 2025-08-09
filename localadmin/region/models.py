from django.db import models
from django.db import models

class Region(models.Model):
    region_code = models.CharField(max_length=16, unique=True) # 식별용 고유 코드 - 임시용!
    city = models.CharField(max_length=32)  #시도
    district = models.CharField(max_length=32, blank=True, null=True) #시군구

    def __str__(self):
        if self.district:
            return f"{self.city} {self.district}"
        return self.city