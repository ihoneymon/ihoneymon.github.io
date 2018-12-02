---
layout: post
title: 깃 커밋 메시지 주석문자 변경하기
categories: Git
tags: [git, commit, message, msg, commentChar, sharp, semicolon]
date: 2018-02-26 09:30:00
---

> Change git commit commentChar (``#``) change to (``;``)


깃헙을 사용한다면 깃헙 이슈관리를 위해서 ``#{issue-number}``을 활용하고 싶어한다. 그런데 깃에서 커밋메시지를 주석처리하는 문자는 기본적으로 ``#``(샵, 해시코드, sharp, hashcode)를 사용하기 때문에 깃헙 이슈관리 기능을 활용하기가 어렵다. 이런 때는 주석코드를 변경하면 된다. 이와 관련해서 인터넷을 검색했다.

그렇게 찾은 것이 [Start a git commit message with a hashmark (``#``)](https://stackoverflow.com/questions/2788092/start-a-git-commit-message-with-a-hashmark) 다.

방법은 간단하다.

```console
$ git config core.commitchar ";"
```

으로 변경하면 다음과 같은 형태로 메시지 주석코드가 변경된다.

```
# 변경사항
## config.yml
* jekyll-asciidoc 추가: ASCIIDOC(`.adoc`) 형식으로 작성한 텍스트 파일을 랜더링가능

## 2018-02-25 파일 변경
* `.md` -> `.adoc` 으로 변경

; Please enter the commit message for your changes. Lines starting
; with ';' will be ignored, and an empty message aborts the commit.
;
; Date:      Sun Feb 25 21:22:43 2018 +0900
;
; On branch master
; Changes to be committed:
;       modified:   Gemfile
;       modified:   _config.yml
;       modified:   _layouts/post.html
;       new file:   _posts/2018-02-25-honeymon-io-create.adoc
;       deleted:    _posts/2018-02-25-honeymon-io-create.md
;       modified:   about.html
;       modified:   assets/vendor/startbootstrap-clean-blog/scss/_mixins.scss
;       new file:   build.sh
;       modified:   contact.html
;       deleted:    screenshot.png
;       new file:   serve.sh
;
```

## 참고사항
* [Git:: git-config](https://git-scm.com/docs/git-config/1.8.5#git-config-corecommentchar)
