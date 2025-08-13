import os
import logging
from typing import List, Dict, Any

try:
    import firebase_admin
    from firebase_admin import credentials, messaging
except ImportError:
    firebase_admin = None
    print("firebase_admin이 설치되지 않았습니다. pip install firebase-admin을 실행하세요.")

from django.conf import settings

logger = logging.getLogger(__name__)


class FirebaseService:
    """Firebase Cloud Messaging 서비스"""

    _app = None

    @classmethod
    def initialize_firebase(cls):
        """Firebase 앱 초기화"""
        if not firebase_admin:
            logger.error("firebase_admin 패키지가 설치되지 않았습니다.")
            return None

        if not cls._app:
            try:
                cred_path = getattr(settings, 'FIREBASE_CREDENTIALS_PATH', None)
                if cred_path and os.path.exists(cred_path):
                    cred     = credentials.Certificate(cred_path)
                    cls._app = firebase_admin.initialize_app(cred)
                    logger.info("Firebase 초기화 성공")
                else:
                    logger.error("Firebase 인증서 파일을 찾을 수 없습니다.")
            except Exception as error:
                logger.error(f"Firebase 초기화 실패: {error}")

        return cls._app

    @staticmethod
    def send_push_to_multiple_tokens_compat(tokens, title, body, data=None):
        """
        여러 토큰을 개별 messaging.send()로 전송
        (send_multicast, send_all 미지원 버전 호환)
        """
        success_count = 0
        failure_count = 0

        for token in tokens:
            message = messaging.Message(
                notification=messaging.Notification(title=title, body=body),
                data=data or {},
                token=token
            )
            try:
                messaging.send(message)
                success_count += 1
            except Exception as err:
                logger.error(f"FCM 전송 실패 (token={token}): {err}")
                failure_count += 1

        logger.info(f"푸시 알림 전송 완료: {success_count}개 성공, {failure_count}개 실패")
        return success_count, failure_count

    @classmethod
    def send_push_notification_to_user(
        cls,
        user,
        title: str,
        body: str,
        data: Dict[str, Any] = None
    ) -> bool:
        """특정 사용자에게 푸시 알림 전송"""
        if not firebase_admin:
            logger.error("firebase_admin이 설치되지 않아 푸시 알림을 전송할 수 없습니다.")
            return False

        try:
            cls.initialize_firebase()
            from .models import FCMDevice

            active_tokens = FCMDevice.objects.filter(
                user=user,
                is_active=True
            ).values_list('registration_token', flat=True)

            if not active_tokens:
                logger.warning(f"사용자 {user.user_id}의 활성 FCM 토큰이 없습니다.")
                return False

            # send_multicast 지원 여부 확인
            if hasattr(messaging, 'send_multicast'):
                message = messaging.MulticastMessage(
                    notification=messaging.Notification(title=title, body=body),
                    data=data or {},
                    tokens=list(active_tokens)
                )
                response = messaging.send_multicast(message)
                logger.info(
                    f"푸시 알림 전송 완료: {response.success_count}개 성공, "
                    f"{response.failure_count}개 실패"
                )
                if response.failure_count > 0:
                    cls._deactivate_failed_tokens(response.responses, active_tokens)
                return response.success_count > 0

            # 멀티캐스트 미지원 → 개별 전송
            logger.warning("알림 전송 완료 (firebase-admin 버전에서 send_multicast 미지원, 개별 전송으로 지원.)")
            success_count, _ = cls.send_push_to_multiple_tokens_compat(
                tokens=list(active_tokens),
                title=title,
                body=body,
                data=data
            )
            return success_count > 0

        except Exception as error:
            logger.error(f"푸시 알림 전송 실패: {error}")
            return False

    @classmethod
    def _deactivate_failed_tokens(cls, responses, tokens):
        """실패한 토큰 비활성화"""
        try:
            from .models import FCMDevice
            failed_tokens = []

            for idx, response in enumerate(responses):
                if not response.success:
                    error_code = response.exception.code if response.exception else None
                    if error_code in ['UNREGISTERED', 'INVALID_ARGUMENT']:
                        failed_tokens.append(tokens[idx])

            if failed_tokens:
                FCMDevice.objects.filter(
                    registration_token__in=failed_tokens
                ).update(is_active=False)
                logger.info(f"{len(failed_tokens)}개의 무효한 FCM 토큰을 비활성화했습니다.")

        except Exception as error:
            logger.error(f"실패 토큰 처리 중 오류: {error}")


class NotificationService:
    """알림 비즈니스 로직"""

    @staticmethod
    def create_notification_for_document(document) -> List:
        """관심사 일치 사용자에게 알림 생성 및 푸시 전송"""
        from django.db import transaction
        from .models import Notification

        with transaction.atomic():
            interested_users     = NotificationService._get_interested_users_for_document(document)
            created_notifications = []

            for user in interested_users:
                notification = Notification.objects.create(
                    user=user,
                    document=document,
                    title=document.doc_title,
                    content=""
                )
                created_notifications.append(notification)
                NotificationService._send_push_for_document(user, document)

            return created_notifications

    @staticmethod
    def _get_interested_users_for_document(document):
        """공문에 관심 있는 사용자 조회"""
        from django.db.models import Q
        from user.models import User

        return User.objects.filter(
            Q(user_regions__region_id=document.region_id) |
            Q(user_categories__category__in=document.categories.all())
        ).distinct()

    @staticmethod
    def _send_push_for_document(user, document):
        """공문 관련 푸시 알림 발송"""
        try:
            from region.models import Region

            try:
                region = Region.objects.get(id=document.region_id)
                region_name = (
                    region.city if not region.district else f"{region.city} {region.district}"
                )
            except Region.DoesNotExist:
                region_name = "지역정보없음"

            categories      = document.categories.all()
            category_names  = [cat.category_name for cat in categories]
            category_label  = category_names[0] if category_names else "관심분야"

            region_label = region_name if region_name != "지역정보없음" else ""
            if region_label and category_label:
                subject = f"{region_label}/{category_label}"
            else:
                subject = region_label or category_label

            # 푸시 메시지 제목과 내용
            title = f"📍 [{subject}] 관련 공문이 등록됐어요!"
            body  = f'"{document.doc_title}" 지금 확인해보세요'

            push_data = {
                'document_id' : str(document.id),
                'doc_type'    : document.doc_type,
                'region_name' : region_name,
                'categories'  : ','.join(category_names)
            }

            FirebaseService.send_push_notification_to_user(
                user=user,
                title=title,
                body=body,
                data=push_data
            )

        except Exception as error:
            logger.error(f"공문 푸시 알림 전송 실패: {error}")

    @staticmethod
    def get_user_notifications(user, doc_type=None, region_ids=None, category_ids=None):
        """사용자 알림 조회"""
        from .models import Notification

        queryset = Notification.objects.filter(user=user).select_related('document')

        if doc_type:
            queryset = queryset.filter(document__doc_type=doc_type)
        if region_ids:
            queryset = queryset.filter(document__region_id__in=region_ids)
        if category_ids:
            queryset = queryset.filter(
                document__categories__id__in=category_ids
            ).distinct()

        return queryset.order_by('-notification_time')

    @staticmethod
    def send_test_push_notification(user) -> bool:
        """테스트 푸시"""
        try:
            from .models import Notification

            latest_notification = Notification.objects.filter(
                user=user
            ).select_related('document').first()

            if not latest_notification:
                logger.warning(f"사용자 {user.user_id}의 알림이 없습니다.")
                return False

            NotificationService._send_push_for_document(user, latest_notification.document)
            logger.info(f"사용자 {user.user_id}에게 테스트 푸시 알림 전송 완료")
            return True

        except Exception as error:
            logger.error(f"테스트 푸시 알림 전송 실패: {error}")
            return False