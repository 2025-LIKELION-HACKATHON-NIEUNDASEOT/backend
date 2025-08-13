from django.db import models

from user.models import User, BaseTimeStampModel
from document.models import Document


class FCMDevice(BaseTimeStampModel):
    """FCM 디바이스 토큰 관리"""
    
    DEVICE_TYPE_CHOICES = [
        ('android', 'Android'),
        ('ios', 'iOS'), 
        ('web', 'Web')
    ]
    
    user = models.ForeignKey(
        User,
        on_delete    = models.CASCADE,
        related_name = 'fcm_devices',
        verbose_name = '사용자'
    )
    registration_token = models.CharField(
        max_length   = 255,
        unique       = True,
        verbose_name = 'FCM 등록 토큰'
    )
    device_type = models.CharField(
        max_length   = 10,
        choices      = DEVICE_TYPE_CHOICES,
        default      = 'android',
        verbose_name = '디바이스 타입'
    )
    is_active = models.BooleanField(
        default      = True,
        verbose_name = '활성 상태'
    )
    

    class Meta:
        db_table             = 'fcm_device'
        verbose_name         = 'FCM 디바이스'
        verbose_name_plural  = 'FCM 디바이스들'
        unique_together      = ('user', 'registration_token')


    def __str__(self):
        return f"{self.user.name} - {self.device_type}"


class Notification(BaseTimeStampModel):
    """알림 모델"""
    id = models.AutoField(
        primary_key  = True,
        db_column    = 'notification_id',
        verbose_name = '알림 ID'
    )
    title = models.CharField(
        max_length   = 128,
        verbose_name = '알림 제목'
    )
    content = models.CharField(
        max_length=256,
        null=True,           
        blank=True,         
        default='',          
        verbose_name='알림 내용'
    )
    is_read = models.BooleanField(
        default      = False,
        verbose_name = '읽음 여부'
    )
    notification_time = models.DateTimeField(
        auto_now_add = True,
        verbose_name = '알림 생성 시간'
    )
    read_time = models.DateTimeField(
        null         = True,
        blank        = True,
        verbose_name = '읽은 시간'
    )
    user = models.ForeignKey(
        User,
        on_delete    = models.CASCADE,
        related_name = 'notifications',
        verbose_name = '사용자'
    )
    document = models.ForeignKey(
        Document,
        on_delete    = models.CASCADE,
        related_name = 'notifications',
        verbose_name = '공문'
    )


    class Meta:
        db_table             = 'notification'
        verbose_name         = '알림'
        verbose_name_plural  = '알림들'
        ordering             = ['-notification_time']
        indexes              = [
            models.Index(fields=['user', 'is_read']),
            models.Index(fields=['notification_time']),
        ]


    def __str__(self):
        status = "읽음" if self.is_read else "안읽음"
        return f"[{status}] {self.user.name}님 - {self.title}"


    def mark_as_read(self):
        """알림을 읽음으로 표시"""
        from django.utils import timezone
        
        if not self.is_read:
            self.is_read   = True
            self.read_time = timezone.now()
            self.save(update_fields=['is_read', 'read_time'])