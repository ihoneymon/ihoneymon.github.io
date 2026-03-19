---
title: "손 안대고 코풀기: AI로 Jekyll -> Hugo 로 이관하기"
date: 2026-03-20T00:00:00+09:00
categories: [tech]
tags: [hugo, jekyll, blog, migration, ai, claude]
---

블로그를 시작한 게 2018년이니 어언 8년이 됐다. 그동안 Jekyll 기반으로 GitHub Pages 에 올려서 운영해왔는데, 솔직히 말하면 루비(Ruby) 환경 셋업이 귀찮을 때마다 포스팅 의욕이 뚝 떨어졌다. `bundle install` 이 실패하면 반나절이 날아가는 경험을 몇 번 하고 나니 Hugo 로 옮겨야겠다는 생각이 굳어졌다.

마침 Claude Code 를 쓰기 시작하면서 "이거 한번 시켜볼까?" 싶었다. 결론부터 말하면, **거의 손 안 대고 코를 풀었다.**

---

## 왜 Hugo 인가

- **Go 바이너리 하나로 끝**: 루비 환경, Bundler, 젬(Gem) 의존성 같은 것 없다. `brew install hugo` 한 줄이면 끝.
- **빌드 속도**: 33개 포스트 기준 빌드 91ms. Jekyll 은 같은 규모에서 수 초가 걸렸다.
- **한글 지원**: `hasCJKLanguage = true` 옵션으로 한국어 요약(summary) 길이 계산이 제대로 된다.

---

## 이관 작업 개요

전체 작업은 크게 네 단계로 진행됐다.

1. Hugo 설정 파일(`hugo.toml`) 작성
2. 레이아웃 템플릿 이식
3. 포스트 마이그레이션 스크립트 작성 및 실행
4. 빌드 오류 수정 + GitHub Actions 배포 설정

---

## 1단계: hugo.toml 작성

Jekyll 의 `_config.yml` 에 해당하는 Hugo 설정 파일이다. 기존 Jekyll 설정에서 필요한 값을 그대로 옮겼다.

```toml
baseURL = "http://honeymon.io/"
languageCode = "ko-KR"
title = "I'm honeymon(JiHeon Kim)."
hasCJKLanguage = true
enableRobotsTXT = true
summaryLength = 30

[pagination]
  pagerSize = 5
  path = "page"

[params]
  description = "허니몬(honeymon.io)의 블로그 입니다."
  author = "honeymon"
  email = "ihoneymon@gmail.com"

[taxonomies]
  tag = "tags"
  category = "categories"

[markup]
  [markup.highlight]
    noClasses = true
    style = "monokai"
    codeFences = true
  [markup.goldmark.renderer]
    unsafe = true
```

`[markup.goldmark.renderer] unsafe = true` 는 포스트 본문에 HTML 을 직접 쓴 경우 렌더링되게 하는 옵션이다. 없으면 HTML 태그가 그대로 텍스트로 출력된다.

---

## 2단계: 레이아웃 템플릿 이식

Jekyll 은 `_layouts/`, `_includes/` 에 Liquid 템플릿을 쓰고, Hugo 는 `layouts/` 에 Go 템플릿을 쓴다. 문법은 다르지만 구조는 비슷하다.

Claude 에게 기존 `_layouts/post.html` 을 보여주고 Hugo 템플릿으로 바꿔달라고 하니 `layouts/_default/single.html` 을 뚝딱 만들어줬다. 공통 요소(head, navbar, footer)도 `layouts/partials/` 로 분리했다.

```
layouts/
  _default/
    baseof.html    ← 전체 페이지 뼈대
    single.html    ← 포스트 개별 페이지
    term.html      ← /tags/java/ 같은 태그별 포스트 목록
    taxonomy.html  ← /tags/, /categories/ 전체 목록
  partials/
    head.html
    navbar.html
    footer.html
    scripts.html
  posts/
    single.html    ← posts 섹션 전용 포스트 페이지
```

`baseof.html` 이 전체 틀을 잡고, 각 페이지는 `{{ block "main" . }}` 을 오버라이드하는 방식이다.

---

## 3단계: 포스트 마이그레이션 스크립트

33개 포스트를 손으로 하나씩 고치는 건 말이 안 된다. Claude 가 `migrate_posts.py` 를 작성해줬다.

```python
#!/usr/bin/env python3
"""Jekyll to Hugo post migration script."""
import os, re

SRC = '_posts'
DST = 'content/posts'

os.makedirs(DST, exist_ok=True)

def fix_liquid_urls(text):
    # {{ "/assets/post/..." | absolute_url }} -> /assets/post/...
    return re.sub(
        r'\{\{["\s]*(/[^"}\s]+)["\s]*\|\s*(?:absolute_url|relative_url)\s*\}\}',
        r'\1',
        text
    )

def convert_frontmatter(fm):
    fm = re.sub(r'^layout:\s*.+\n', '', fm, flags=re.MULTILINE)   # layout 필드 제거
    fm = re.sub(r'^category:', 'categories:', fm, flags=re.MULTILINE)  # 단수 -> 복수
    return fm

for filename in sorted(os.listdir(SRC)):
    if not (filename.endswith('.md') or filename.endswith('.markdown')):
        continue
    # ... (파일 읽기/쓰기 생략)
```

핵심은 두 가지다.

**① Jekyll front matter 정리**

Jekyll 은 `layout: post` 처럼 레이아웃을 front matter 에 명시하지만 Hugo 는 디렉터리 구조로 레이아웃을 결정한다. `layout` 필드를 제거하지 않으면 Hugo 가 무시하긴 하지만 지저분하다.

또 Jekyll 에서 `category: tech` (단수)로 쓴 것을 Hugo 는 `categories: [tech]` (복수)로 인식한다. `category:` → `categories:` 로 일괄 치환했다.

**② Liquid URL 필터 제거**

Jekyll 포스트에서 이미지를 삽입할 때 이런 형태를 많이 썼다.

```markdown
![설명]({{ "/assets/post/2021-01-16/img.png" | absolute_url }})
```

Hugo 는 Liquid 템플릿을 해석하지 못하므로 저 부분을 그냥 `/assets/post/2021-01-16/img.png` 로 바꿔야 한다. 정규식으로 일괄 처리했다.

---

## 4단계: 빌드 오류 수정

스크립트를 돌리고 `hugo build` 를 실행하니 에러가 쏟아졌다.

```
ERROR the "date" front matter field is not a parsable date:
  see content/posts/2018-03-01-springboot-2.0-release.md
```

Jekyll 에서 날짜를 `2018-03-01 23:00` 처럼 적어둔 포스트가 27개나 됐다. Hugo 는 이 형식을 파싱하지 못한다. ISO 8601 형식인 `2018-03-01T23:00:00+09:00` 으로 바꿔야 했다.

이것도 Python 으로 일괄 처리했다.

```python
import os, re

date_pattern = re.compile(
    r'^(date:\s*)(\d{4}-\d{2}-\d{2})\s+(\d{2}:\d{2})(:\d{2})?\s*$',
    re.MULTILINE
)

def replace_date(m):
    prefix, date, time = m.group(1), m.group(2), m.group(3)
    sec = m.group(4) or ':00'
    return f'{prefix}{date}T{time}{sec}+09:00'

# content/posts/ 아래 모든 .md 파일에 적용
```

날짜 오류 27개 수정 완료.

---

그 다음 경고가 남았다.

```
WARN  found no layout file for "html" for kind "taxonomy"
WARN  found no layout file for "html" for kind "term"
```

Hugo 0.158 에서는 `list.html` / `terms.html` 파일명이 더 이상 taxonomy/term 레이아웃으로 자동 매핑되지 않는다. `_default/taxonomy.html` 과 `_default/term.html` 을 별도로 만들어야 한다.

기존 `layouts/tags/list.html` 의 내용을 바탕으로 두 파일을 만들었더니 경고가 사라지고 카테고리/태그 페이지가 정상 생성됐다 (172 → 180 pages).

---

## GitHub Actions 배포

마지막으로 푸시하면 자동 배포되도록 워크플로우를 설정했다.

```yaml
# .github/workflows/deploy.yml
name: Deploy Hugo to GitHub Pages

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: '0.158.0'
          extended: true
      - run: hugo --minify
      - uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  deploy:
    needs: build
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - uses: actions/deploy-pages@v4
```

---

## 결과

| | Jekyll | Hugo |
|---|---|---|
| 빌드 시간 | ~수 초 | **91ms** |
| 환경 셋업 | Ruby + Bundler | `brew install hugo` |
| 포스트 수 | 33개 | 33개 (전부 이관) |
| 생성 페이지 | - | 180개 (taxonomy 포함) |

---

## 소감

솔직히 말하면 내가 직접 한 건 거의 없다. Claude Code 에게 "Jekyll 에서 Hugo 로 옮기고 싶은데 도와줘" 라고 시작해서, 오류가 날 때마다 에러 메시지를 보여주면 알아서 고쳐줬다. 마이그레이션 스크립트, 레이아웃 템플릿, 날짜 형식 일괄 수정, GitHub Actions 워크플로우까지.

"손 안 대고 코풀기" 라는 말이 딱 맞는다. AI 가 삽질을 대신 해주는 시대다.

블로그를 Hugo 로 옮기고 싶었는데 손이 안 갔던 분들, 한번 Claude Code 에 던져보시길.

---

> Hugo 기반 블로그에 포스팅 작성하는 방법은 [README-WRITE-WITH-HUGO.md](https://github.com/ihoneymon/ihoneymon.github.io/blob/main/README-WRITE-WITH-HUGO.md) 를 참고.
