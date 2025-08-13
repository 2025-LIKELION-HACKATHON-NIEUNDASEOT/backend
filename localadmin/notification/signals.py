# notifications/signals.py
import logging
from django.db.models.signals import post_save
from django.dispatch import receiver

from document.models import Document
from .firebase_service import NotificationService


logger = logging.getLogger(__name__)


@receiver(post_save, sender=Document)
def create_notifications_for_new_document(sender, instance, created, **kwargs):
    """새 공문 생성 시 자동 알림 생성 + 푸시 전송"""
    if created and instance.is_active:
        try:
            created_notifications = NotificationService.create_notification_for_document(instance)
            logger.info(f"공문 ID {instance.id}에 대해 {len(created_notifications)}개의 알림이 생성되었습니다.")
            
        except Exception as error:
            logger.error(f"공문 ID {instance.id}에 대한 알림 생성 실패: {error}")
