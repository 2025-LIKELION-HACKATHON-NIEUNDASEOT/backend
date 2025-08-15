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
        max_length   = 64,
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
    image_url   = models.CharField(
        max_length   = 1024,
        null         = True,
        blank        = True,
        verbose_name = '이미지 URL',
        help_text   = '이미지 파일 URL 또는 경로'
    )
    # 추천 관련 Gemini 캐시용 필드 추가
    keywords = models.TextField(
        null=True, 
        blank=True
    )
    related_departments = models.TextField(
        null=True, 
        blank=True
    )
    purpose = models.TextField(
        null=True, 
        blank=True
    )
    # 요약 필드 추가
    summary = models.TextField(
        null=True, 
        blank=True
    )

    class Meta:
        db_table             = 'document'
        verbose_name         = '공문'
        verbose_name_plural  = '공문들'
        ordering             = ['-pub_date']

    def __str__(self):
        return f"[{self.get_doc_type_display()}] {self.doc_title}"
