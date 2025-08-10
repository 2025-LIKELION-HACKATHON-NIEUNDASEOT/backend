from django.db        import models
from user.models      import User, BaseTimeStampModel
from document.models  import Category
from chatbot.models   import ChatbotSession, ChatbotMessage, SpeakerChoices
from django.core.exceptions import ValidationError


class ChatbotScrap(BaseTimeStampModel):
    """챗봇 스크랩 모델 (카테고리 다중)"""
    id               = models.AutoField(
        primary_key  = True,
        verbose_name = '챗봇 스크랩 ID'
    )
    summary          = models.CharField(
        max_length   = 200,
        null         = True,
        blank        = True,
        verbose_name = 'AI 응답 요약'
    )
    user             = models.ForeignKey(
        User,
        on_delete    = models.CASCADE,
        related_name = 'chatbot_scraps',
        verbose_name = '사용자'
    )
    chatbot_session  = models.ForeignKey(
        ChatbotSession,
        on_delete    = models.CASCADE,
        related_name = 'scraps',
        verbose_name = '세션'
    )
    user_message     = models.ForeignKey(
        ChatbotMessage,
        on_delete    = models.CASCADE,
        related_name = 'user_scraps',
        verbose_name = '사용자 메시지'
    )
    ai_message       = models.ForeignKey(
        ChatbotMessage,
        on_delete    = models.CASCADE,
        related_name = 'ai_scraps',
        verbose_name = 'AI 메시지'
    )
    categories         = models.ManyToManyField(
        Category,
        related_name = 'chatbot_scraps',
        blank        = True,
        verbose_name = '카테고리'
    )

    class Meta:
        db_table            = 'chatbot_scrap'
        verbose_name        = '챗봇 스크랩'
        verbose_name_plural = '챗봇 스크랩들'
        ordering            = ['-created_at']
        unique_together     = ('user', 'user_message', 'ai_message')

    def clean(self):
        if self.user_message and self.user_message.speaker != SpeakerChoices.USER:
            raise ValidationError('user_message는 USER 타입이어야 합니다.')
        if self.ai_message and self.ai_message.speaker != SpeakerChoices.AI:
            raise ValidationError('ai_message는 AI 타입이어야 합니다.')

    def save(self, *args, **kwargs):
        self.full_clean()
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.user.name}의 스크랩"