from django.db import models
from user.models import User, Category, BaseTimeStampModel


class DocumentTypeChoices(models.TextChoices):
    # 문서 타입 선택
    PARTICIPATION = 'PARTICIPATION', '참여'
    NOTICE        = 'NOTICE', '공지'
    REPORT        = 'REPORT', '보고'
    ANNOUNCEMENT  = 'ANNOUNCEMENT', '공고'


class Document(BaseTimeStampModel):
    """공문 모델"""
    id         = models.AutoField(
        primary_key  = True,
        db_column    = 'document_id',
        verbose_name = '공문 ID'
    )
    doc_title  = models.CharField(
        max_length   = 512,
        verbose_name = '제목'
    )
    doc_content = models.TextField(
        null         = True,
        blank        = True,
        verbose_name = '내용'
    )
    doc_type   = models.CharField(
        max_length   = 20,
        choices      = DocumentTypeChoices.choices,
        null         = True,
        blank        = True,
        verbose_name = '타입'
    )
    pub_date   = models.DateTimeField(
        verbose_name = '게시일'
    )
    dead_date  = models.DateTimeField(
        null         = True,
        blank        = True,
        verbose_name = '마감일',
        help_text    = '참여 등의 공문만'
    )
    is_active  = models.BooleanField(
        default      = True,
        null         = True,
        blank        = True,
        verbose_name = '활성 상태'
    )
    region_id  = models.IntegerField(
        verbose_name = '지역 ID'
    )
    categories = models.ManyToManyField(
        Category,
        related_name = 'documents',
        blank        = True,
        verbose_name = '카테고리'
    )

    class Meta:
        db_table             = 'document'
        verbose_name         = '공문'
        verbose_name_plural  = '공문들'
        ordering             = ['-pub_date']

    def __str__(self):
        return f"[{self.get_doc_type_display()}] {self.doc_title}"


class DocumentScrap(BaseTimeStampModel):
    """공문 스크랩 모델"""
    id = models.AutoField(
        primary_key  = True,
        db_column    = 'document_scrap_id',
        verbose_name = '공문 스크랩 ID'
    )
    user = models.ForeignKey(
        User,
        on_delete      = models.CASCADE,
        db_column      = 'user_id',
        related_name   = 'document_scraps',
        verbose_name   = '사용자'
    )
    document = models.ForeignKey(
        Document,
        on_delete      = models.CASCADE,
        db_column      = 'document_id',
        related_name   = 'scraps',
        verbose_name   = '공문'
    )

    class Meta:
        db_table             = 'document_scrap'
        verbose_name         = '공문 스크랩'
        verbose_name_plural  = '공문 스크랩들'
        unique_together      = ('user', 'document')

    def __str__(self):
        return f"{self.user.name}의 스크랩 - {self.document.doc_title}"
