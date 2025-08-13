from typing import List, QuerySet
from django.db import transaction
from django.utils import timezone

from .models import Notification
from user.models import User, UserCategory, UserRegion
from document.models import Document


class NotificationService:
    """알림 관련 비즈니스 로직"""


    @staticmethod
    def create_notification_for_document(document: Document) -> List[Notification]:
        """
        새로운 공문에 대해 관심사가 일치하는 사용자들에게 알림 생성
        
        Args:
            document: 새로 생성된 공문 인스턴스
            
        Returns:
            생성된 알림들의 리스트
        """
        with transaction.atomic():
            # 해당 공문에 관심이 있을 사용자들 조회
            interested_users = NotificationService._get_interested_users_for_document(document)
            
            notifications_to_create = []
            for user in interested_users:
                notification_title = document.doc_title
                notification_content = '' 
                
                notification = Notification(
                    user      = user,
                    document  = document,
                    title     = notification_title,
                    content   = notification_content
                )
                notifications_to_create.append(notification)
            
            # 일괄 생성
            created_notifications = Notification.objects.bulk_create(
                notifications_to_create, 
                batch_size=100
            )
            
            return created_notifications


    @staticmethod
    def _get_interested_users_for_document(document: Document) -> QuerySet[User]:
        """
        특정 공문에 관심이 있을 사용자들 조회
        - 관심 지역이 일치하거나
        - 관심 카테고리가 일치하는 사용자들
        """
        from django.db.models import Q
        
        # 관심 지역이 일치하는 사용자들
        region_interested_users = User.objects.filter(
            user_regions__region_id=document.region_id
        ).distinct()
        
        # 관심 카테고리가 일치하는 사용자들
        category_interested_users = User.objects.filter(
            user_categories__category__in=document.categories.all()
        ).distinct()
        
        # 두 조건 중 하나라도 만족하는 사용자들
        interested_users = User.objects.filter(
            Q(id__in=region_interested_users) | 
            Q(id__in=category_interested_users)
        ).distinct()
        
        return interested_users


    @staticmethod
    def get_user_notifications(
        user: User, 
        doc_type: str = None,
        region_ids: List[int] = None,
        category_ids: List[int] = None,
        is_read: bool = None
    ) -> QuerySet[Notification]:
        """
        사용자별 알림 조회 (필터링 지원)
        
        Args:
            user: 사용자 인스턴스
            doc_type: 공문 타입 필터 ('PARTICIPATION', 'NOTICE', etc.)
            region_ids: 지역 ID 리스트 필터
            category_ids: 카테고리 ID 리스트 필터
            is_read: 읽음 상태 필터
            
        Returns:
            필터링된 알림 QuerySet
        """
        queryset = Notification.objects.filter(user=user).select_related(
            'document'
        ).prefetch_related(
            'document__categories'
        )
        
        if doc_type:
            queryset = queryset.filter(document__doc_type=doc_type)
        
        if region_ids:
            queryset = queryset.filter(document__region_id__in=region_ids)
        
        if category_ids:
            queryset = queryset.filter(
                document__categories__id__in=category_ids
            ).distinct()
        
        if is_read is not None:
            queryset = queryset.filter(is_read=is_read)
        
        return queryset.order_by('-notification_time')


    @staticmethod
    def mark_notification_as_read(notification_id: int, user: User) -> bool:
        """
        알림을 읽음으로 표시
        
        Args:
            notification_id: 알림 ID
            user: 사용자 인스턴스
            
        Returns:
            성공 여부
        """
        try:
            notification = Notification.objects.get(
                id=notification_id, 
                user=user
            )
            notification.mark_as_read()
            return True
        except Notification.DoesNotExist:
            return False


    @staticmethod
    def get_unread_count(user: User) -> int:
        """사용자의 읽지 않은 알림 개수 조회"""
        return Notification.objects.filter(
            user=user, 
            is_read=False
        ).count()
