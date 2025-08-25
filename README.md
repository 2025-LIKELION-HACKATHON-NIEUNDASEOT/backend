<div align="center">
  <img src="https://i.postimg.cc/Sx4xbjts/image.jpg" alt="프로젝트 이미지" />
</div>

---

## 📬 Villit 프로젝트 개요

### 서비스 소개
" 나와 지역사회를 가깝게 "

어렵고 광범위한 지역 행정 소식, AI비서로 맞춤 확인
> **프로젝트 기간**: 2025.07.22 ~ 2025.08.26

---

## 🚀 백엔드 팀원 소개

<table align="center">
  <thead>
    <tr>
      <th>이수진</th>
      <th>김민주</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center"><img src="https://avatars.githubusercontent.com/leewatertrue" alt="이수진 사진" width="200" height="200"></td>
      <td align="center"><img src="https://avatars.githubusercontent.com/chacha-0409" alt="민주 사진" width="200" height="200"></td>
    </tr>
    <tr>
      <td align="center"><a href="https://github.com/leewatertrue">@leewatertrue</a></td>
      <td align="center"><a href="https://github.com/chacha-0409">@chacha-0409</a></td>
    </tr>
    <tr>
      <td align="center">사용자 계정(게스트 로그인),<br> 챗봇, 챗봇 스크랩,<br>공문 스크랩, 푸시 알림 및 알림<br>CICD 배포 (AWS)</td>
      <td align="center">공문 조회 및 크롤링, <br>홈 화면(다가오는 일정,<br>관심 지역 및 분야 최근 소식),<br> 공문 및 지역 검색</td>
    </tr>
  </tbody>
</table>

---
## 🛠 기술 스택
<div align="center">
<table width="100%">
<tr>
<th align="center">Backend</th>
<td align="left">
<img height="50" src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/django.png">  
<img height="50" src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/visual_studio_code.png">
<img height="50" src="https://i.postimg.cc/3R2GYWHx/pydantic.jpg">
<img height="50" src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/selenium.png">
</td>
</tr>
<tr>
<th align="center">Database</th>
<td align="left">
<img height="50" src="https://user-images.githubusercontent.com/25181517/183896128-ec99105a-ec1a-4d85-b08b-1aa1620b2046.png"> 
<img height="50" src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/postman.png">
</td>
</tr>
<tr>
<th align="center">CI/CD</th>
<td align="left">
<img height="50" src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/git.png">
</td>
</tr>
<tr>
<th align="center">Deployment</th>
<td align="left">
<img height="50" src="https://user-images.githubusercontent.com/25181517/183896132-54262f2e-6d98-41e3-8888-e40ab5a17326.png">
<img height="50" src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/swagger.png">
  <img height="50" src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/firebase.png">
</td>
</tr>
</table>
</div>

---
## 🏗 서버 아키텍처 및 흐름
<div align="center">
  <li>아키텍처</li><br>
    <img src="https://i.postimg.cc/x84CK391/image.jpg"><br>
  <br><li>흐름도</li><br>
    <img src="https://i.postimg.cc/brgtttB6/Untitled-diagram-Mermaid-Chart-2025-08-25-032759.png">
</div>

---

## 📖 API 명세서
- [📗 Villit 백엔드 스웨거](https://villit.o-r.kr/swagger/)<br>

- API 간단 정리
<details>
  <summary>챗봇</summary>
  <img src="https://i.postimg.cc/8kZds8gT/image.jpg">
</details>
<details>
  <summary>공문</summary>
  <img src="https://i.postimg.cc/d0crgwrj/image.jpg">
</details>
<details>
  <summary>알림</summary>
  <img src="https://i.postimg.cc/3NqD1T3p/image.jpg">
</details>
<details>
  <summary>스크랩</summary>
  <img src="https://i.postimg.cc/SQPXwmpY/image.jpg">
</details>
<details>
  <summary>사용자와 지역</summary>
  <img src="https://i.postimg.cc/Kj3YZgyk/image.jpg">
  <img src="https://i.postimg.cc/HkgbhTQ4/image.jpg">
</details>


---

> ### Git 브랜치 전략
> **Git Flow** 전략을 사용하였습니다.
- **`main`**: 개발 코드. 모든 기능 브랜치는 `main`에서 시작됩니다.
- **`feat/[이슈번호]`**: 새로운 기능을 개발하는 브랜치.<br><br>

> ### 코드 컨벤션
- **언어**: Python
- **스타일**: [📃 파이썬 코딩 컨벤션 정리 참고](https://velog.io/@stresszero/%EC%BD%94%EB%94%A9-%EC%BB%A8%EB%B2%A4%EC%85%98)
- **주석**: 필요 메서드마다 구분하기 쉽도록 주석을 달아줍니다.<br><br>

> ### 커밋 및 이슈
| 커밋 유형  | 의미                                                                                  |
| ---------- | ------------------------------------------------------------------------------------- |
| 🎉 `Initial`     | 초기 세팅시에만 사용                             |
| ✨ `Feat`     | 새로운 기능 추가                             |
| 🐛 `Fix`      | 버그 수정                   |
| 📝 `Docs`     | 문서(README, SWAGGER 등) 수정                                                          |
| ♻️ `Refactor` | 코드 리팩토링(기능 변화 없이 코드 구조 개선)       |
| 🌏 `Deploy`    | 배포 설정                    |
| 💚 `CI/CD`    | CI/CD 관련 설정 수정                    |
| ⚙️ `Setting`    | 그 외 설정 수정                    |
| 🚀 `Chore`    | 그 외 기타 수정 및 잡일성 작업                    |

