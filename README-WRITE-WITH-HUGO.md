# Hugo로 블로그 포스팅 작성하기

## 로컬 환경 실행

```bash
hugo server -D
```

브라우저에서 http://localhost:1313 으로 접속해 확인한다.
`-D` 옵션을 붙이면 draft 포스트도 함께 렌더링된다.

---

## 새 포스트 만들기

파일명 규칙: `YYYY-MM-DD-slug.md`

```bash
hugo new content/posts/2026-03-20-my-new-post.md
```

또는 직접 `content/posts/` 아래에 파일을 생성해도 된다.

---

## Front matter (머리말)

모든 포스트는 `---`로 감싼 YAML front matter로 시작한다.

```yaml
---
title: "포스트 제목"
date: 2026-03-20T09:00:00+09:00
categories: [tech]
tags: [spring-boot, java]
draft: false
---
```

### 필드 설명

| 필드 | 필수 | 설명 |
|------|------|------|
| `title` | 필수 | 포스트 제목 |
| `date` | 필수 | 작성일시. 반드시 ISO 8601 형식 사용 (`YYYY-MM-DDTHH:MM:SS+09:00` 또는 `YYYY-MM-DD`) |
| `categories` | 권장 | 카테고리 목록 (배열). 예: `[tech]`, `[hobby]` |
| `tags` | 권장 | 태그 목록 (배열). 예: `[java, spring-boot]` |
| `draft` | 선택 | `true`로 설정하면 `hugo server -D` 에서만 보임. 기본값 `false` |
| `subtitle` | 선택 | 부제목. 목록 페이지의 요약으로 표시됨 |
| `background` | 선택 | 헤더 배경 이미지 경로. 미지정시 `/img/bg-post.jpg` 사용 |

### date 형식 주의

Hugo는 날짜를 엄격하게 파싱한다. 아래 형식만 사용한다.

```yaml
# 올바른 형식
date: 2026-03-20
date: 2026-03-20T09:00:00+09:00

# 잘못된 형식 (빌드 오류 발생)
date: 2026-03-20 09:00
```

---

## 이미지 첨부

이미지는 `static/assets/post/YYYY-MM-DD/` 디렉터리에 넣는다.

```
static/
  assets/
    post/
      2026-03-20/
        screenshot-01.png
        diagram.png
```

포스트 본문에서 아래와 같이 참조한다.

```markdown
![설명](/assets/post/2026-03-20/screenshot-01.png)
```

---

## 카테고리 & 태그

현재 정의된 주요 카테고리:

- `tech` — 기술 관련
- `hobby` — 취미 관련

태그는 자유롭게 추가할 수 있다. 목록 페이지:
- 태그 목록: http://localhost:1313/tags/
- 카테고리 목록: http://localhost:1313/categories/

---

## 빌드 & 배포

```bash
# 로컬 빌드 (public/ 디렉터리에 생성)
hugo build

# 빌드 후 GitHub Pages 배포
git add .
git commit -m "포스트 제목"
git push origin main
```

`.github/` 워크플로우가 설정되어 있으면 push 시 자동 배포된다.

---

## 디렉터리 구조 요약

```
content/
  posts/           ← 블로그 포스트 마크다운 파일
static/
  assets/
    post/          ← 포스트별 이미지
  img/             ← 공통 이미지 (배경 등)
layouts/
  _default/        ← 기본 레이아웃 (term, taxonomy, single)
  partials/        ← 공통 컴포넌트 (head, navbar, footer 등)
hugo.toml          ← Hugo 설정
```
