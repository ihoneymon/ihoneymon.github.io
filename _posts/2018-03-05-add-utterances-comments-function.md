---
layout: post
title: 내 포스트에 깃헙 이슈로 관리하는 댓글달기
categories: [notice]
tags: [blog,comment,utterances,outsider]
date: 2018-03-01 23:00
---

Jekyll로 사이트를 정돈하고 포스트를 조금씩 적어올리기 시작하면서 댓글의 아쉬움이 남는다. 티스토리 블로그 포스팅을 올릴 때마다 혹은 일주일에 한번씩 스팸댓글이 달린다. 티스토리 앱에서는 알림을 켜두면 매번 댓글알림 푸시가 온다. 블로그 관리에서는 해당IP에 대한 댓글을 차단해뒀지만 블로그앱에서는 여지없이 댓글알림 푸시가 온다. 티스토리에 개선요청을 했지만 아직 그대로다.

그래서 [ihoney.pe.kr](http://ihoney.pe.kr) 과 [java.ihoney.pe.kr](http://java.ihoney.pe.kr) 댓글을 거의 보지 않게 되었다.

[아웃사이더](https://blog.outsider.ne.kr)님의 [페이스북 댓글을 utterances로 교체했습니다](https://blog.outsider.ne.kr/1356)를 보고 댓글 기능을 추가했습니다.

![포스트에 달린 댓글]({{"/assets/post/2018-03-05/2018-03-05-add-utterances-comments-function-01.png" | absolute_url }})

댓글을 달면 포스트에 대한 댓글이 달렸다는 것을 이슈로 알수 있습니다. 이슈에 댓글을 달면 대댓글도 됩니다.

![댓글 달기]({{"/assets/post/2018-03-05/2018-03-05-add-utterances-comments-function-02.png" | absolute_url }})

그리고 댓글이 달렸다는 알림메일도 옵니다.

![이메일알림]({{"/assets/post/2018-03-05/2018-03-05-add-utterances-comments-function-03.png" | absolute_url }})

## 정리
* 댓글을 달기 위해서는 깃헙에 로그인하고 권한을 확인하고 이용승인을 해야합니다.
* 생각해보니, 깃헙계정없는 일반인은 댓글 못달겠구나 싶습니다.
  * 이에 대해서는 뭔가 해결할 수 있는 방법을 찾아봐야겠습니다. ^^;;
* 댓글은 [ihoneymon/blog-comment](https://github.com/ihoneymon/blog-comment) 이슈에서 관리됩니다.


## 참고
* [페이스북 댓글을 utterances로 교체했습니다](https://blog.outsider.ne.kr/1356) - Outsider's Dev Story
