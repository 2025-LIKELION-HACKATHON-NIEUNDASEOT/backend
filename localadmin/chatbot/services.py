import os
from typing import Optional, List, Dict

import google.generativeai as genai
from django.conf import settings


class GeminiChatService:
    """Google Gemini AI 챗봇 서비스"""

    def __init__(self):
        api_key = os.environ.get('GEMINI_API_KEY')
        if not api_key:
            raise ValueError("GEMINI_API_KEY가 설정되지 않았습니다.")

        genai.configure(api_key=api_key)
        self.model = genai.GenerativeModel('gemini-2.0-flash')

    def generate_response(
        self,
        message: str,
        context: Optional[Dict] = None,
        history: Optional[List[Dict]] = None
    ) -> str:
        try:
            prompt = self._build_prompt(message, context, history)
            response = self.model.generate_content(prompt)
            return response.text
        except Exception as e:
            raise Exception(f"Gemini API 오류: {str(e)}")

    def _build_prompt(
        self,
        message: str,
        context: Optional[Dict] = None,
        history: Optional[List[Dict]] = None
    ) -> str:
        prompt_parts = [
            "당신은 지역 행정 정보를 제공하는 친절하고 상냥한 AI 어시스턴트입니다. 말투를 최대한 둥글게 다듬으세요."
            "사용자의 질문에 정확하고 도움이 되는 답변을 제공해주세요. 최대한 쉬운 단어로만 설명하세요."
            "만일 단어 하나만 질문에 올라왔으면 그 단어의 뜻을 자세히 설명해주세요."
            "인사하지 말고 바로 답변을 이어서 제공하세요. 인사말과 이름을 부르는 것을 완전히 생략하고, 바로 답변만 제공하세요.",
            "답변은 최대 9줄, 최소 3줄로 하세요."
            "질문을 반복하거나, '네, ~', '아니요, ~'와 같은 불필요한 서론은 절대 사용하지 마세요. 물어본 말을 또 언급하는 것도 금지합니다."
        ]

        # 사용자 정보
        if context and context.get('user'):
            user = context['user']
            user_info_lines = []

            if user.name:
                user_info_lines.append(f"이름: {user.name}")
            if user.birth:
                user_info_lines.append(f"생년월일: {user.birth.strftime('%Y-%m-%d')}")
            if user.gender:
                user_info_lines.append(f"성별: {user.get_gender_display()}")

            # 관심 카테고리
            if hasattr(user, 'user_categories'):
                categories = [
                    uc.category.category_name for uc in user.user_categories.all()
                ]
                if categories:
                    user_info_lines.append(f"관심 카테고리: {', '.join(categories)}")

            # 관심 지역
            if hasattr(user, 'user_regions'):
                regions = [ur.region_id for ur in user.user_regions.all()]
                if regions:
                    user_info_lines.append(f"관심 지역: {', '.join(regions)}")

            if user_info_lines:
                prompt_parts.append("\n=== 사용자 정보 ===\n" + "\n".join(user_info_lines))

        # 공문 정보
        if context:
            doc = context.get('document')
            if doc:
                categories_str = ", ".join([c.category_name for c in doc.categories.all()])
                prompt_parts.append(
                    f"\n=== 공문 정보 ===\n"
                    f"제목: {doc.doc_title}\n"
                    f"타입: {doc.get_doc_type_display()}\n"
                    f"카테고리: {categories_str or '없음'}\n"
                    f"지역 ID: {doc.region_id}\n"
                    f"게시일: {doc.pub_date.strftime('%Y-%m-%d')}\n"
                    f"마감일: {doc.dead_date.strftime('%Y-%m-%d') if doc.dead_date else '없음'}\n"
                    f"내용:\n{doc.doc_content or '내용 없음'}\n"
                )

            if context.get('related_docs'):
                prompt_parts.append(
                    f"\n관련 문서 ID 목록: {', '.join(map(str, context['related_docs']))}"
                )

        if history:
            prompt_parts.append("\n\n이전 대화 내역:")
            for h in history[-5:]:
                speaker = "사용자" if h['speaker'] == 'USER' else "AI"
                prompt_parts.append(f"{speaker}: {h['content']}")

        prompt_parts.append(f"\n\n사용자: {message}")
        prompt_parts.append("\nAI:")

        return "\n".join(prompt_parts)

    def summarize_response(self, response: str, max_length: int = 100) -> str:
        # AI 응답을 한 줄로 요약
        try:
            prompt = (
                f"다음 텍스트를 {max_length}자 이내로 한 줄로 요약해주세요:\n\n"
                f"{response}\n\n"
                "요약:"
            )
            summary_response = self.model.generate_content(prompt)
            summary = summary_response.text.strip()

            if len(summary) > max_length:
                summary = summary[:max_length - 3] + "..."

            return summary

        except Exception:
            if len(response) > max_length:
                return response[:max_length - 3] + "..."
            return response