from user.models         import User, BaseTimeStampModel
from django.db           import models
from document.models     import Document


class SpeakerChoices(models.TextChoices):
    USER = 'USER', '사용자'
    AI   = 'AI', 'AI'


class ChatbotSession(BaseTimeStampModel):
    id         = models.AutoField(
        primary_key  = True,
        verbose_name = '챗봇 세션 ID'
    )
    is_active  = models.BooleanField(
        default      = True,
        null         = True,
        blank        = True,
        verbose_name = '활성 상태'
    )
    document   = models.OneToOneField(
        Document,
        on_delete    = models.CASCADE,
        null         = True,
        blank        = True,
        related_name = 'chatbot_session',
        verbose_name = '연결된 공문'
    )
    user       = models.ForeignKey(
        User,
        on_delete    = models.CASCADE,
        related_name = 'chatbot_sessions',
        verbose_name = '사용자'
    )

    class Meta:
        db_table            = 'chatbot_session'
        verbose_name        = '챗봇 세션'
        verbose_name_plural = '챗봇 세션들'
        ordering            = ['-created_at']
        unique_together     = ('user', 'document')

    @property
    def title(self):
        return self.document.doc_title if self.document else "제목 없음"

    def __str__(self):
        return f"{self.user.name}의 세션 - {self.title}"


class ChatbotMessage(BaseTimeStampModel):
    id              = models.AutoField(
        primary_key  = True,
        verbose_name = '챗봇 메시지 ID'
    )
    speaker         = models.CharField(
        max_length   = 10,
        choices      = SpeakerChoices.choices,
        verbose_name = '화자'
    )
    content         = models.TextField(
        null         = True,
        blank        = True,
        verbose_name = '내용'
    )
    chatbot_session = models.ForeignKey(
        ChatbotSession,
        on_delete    = models.CASCADE,
        related_name = 'messages',
        verbose_name = '세션'
    )

    class Meta:
        db_table            = 'chatbot_message'
        verbose_name        = '챗봇 메시지'
        verbose_name_plural = '챗봇 메시지들'
        ordering            = ['created_at']

    def __str__(self):
        return f"[{self.speaker}] {self.content[:30] if self.content else '내용 없음'}..."
