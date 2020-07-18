---
title: "[spring-boot] 어느 월급쟁이개발자의 스프링 부트 업데이트 대비방법"
layout: post
category: [tech]
tags: [tech, spring-boot, log]
date: 2020-05-25
---

* 부제: '어느 월급쟁이개발자의 스프링 부트 변화 따라잡기' 노하우 대방출!

# 들어가며

지난 2020-05-15 스프링 부트 2.3.0 이 출시([https://spring.io/blog/2020/05/15/spring-boot-2-3-0-available-now](https://spring.io/blog/2020/05/15/spring-boot-2-3-0-available-now))됐다. 

예전에는 스프링 부트이 출시하면 출시노트(Release note) 및 소스코드 등을 살펴보면서 뭐가 달라졌는지 정리해서 공유했던 때가 있었는데, 이제 잘 하지 않게 된다. 이제는 출시노트를 살펴보고 내가 사용하고 있는 기능의 변경사항이 있는지 확인하고 넘어가는 수준에서 머물고 있다.

스프링 부트는 스프링 프레임워크와 업그레이드를 함께하면서 스프링 안에서 일어나는 변화를 적극적으로 수용한다. 그 변화는 스프링 프레임워크 5.0 출시에 맞춰 스프링 부트 2.0 을 출시하면서 명확하게 그 의도를 드러냈다. 예를 들어, 스프링 프레임워크 5가 되면서 **웹(Web)** 이라는 개념이 동기방식(Synchronous && Blocking) 과 비동기방식(Asynchronious && Nonblocking)  으로 구분짓는 서블릿사양(Servlet spec) 과 리액티브(Reactive spec) 으로 나뉘며 각각의 지향성을 명확히 했다. 스프링 부트 내부에서 웹서버(WebServer) 라는 용어는 서블릿컨테이너(ServletContainer) 로 변경하는 작업과 함께 리액터(Reactor)라는 개념과 분리되어 사용되기 시작했다.

스프링 부트는 2.0 부터 스프링 프레임워크와 변화를 함께하고 있으며, 아래 스프링 부트 출시버전별 스프링 프레임워크 버전을 살펴보면 유추가능하다. 스프링 부트의 버전을 알면 사용하고 있는 스프링 프레임워크의 버전을 확인할 수 있고, 이를 기반으로 해서 스프링 프레임워크 문서 등을 찾아보면 된다.

- 스프링 부트 1.5.12 → 스프링 프레임워크 4.3.16( Spring Boot 1.x 은 2019-08-01 부터 지원이 끊겼으므로 어서어서 2.x 으로 업그레이드하기 바란다)
    - [https://docs.spring.io/spring-boot/docs/1.5.12.RELEASE/reference/htmlsingle/#boot-documentation-first-steps](https://docs.spring.io/spring-boot/docs/1.5.12.RELEASE/reference/htmlsingle/#boot-documentation-first-steps)
- 스프링 부트 2.0 → 스프링 프레임워크 5.0
    - [https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.0-Release-Notes](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.0-Release-Notes)
- 스프링 부트 2.1 → 스프링 프레임워크 5.1
    - [https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.1-Release-Notes](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.1-Release-Notes)
- 스프링 부트 2.2 → 스프링 프레임워크 5.2
    - [https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.2-Release-Notes](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.2-Release-Notes)
- 스프링 부트 2.3 → 스프링 프레임워크 5.3
    - [https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.3-Release-Notes](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.3-Release-Notes)

스프링 부트는 내가(그리고 여러분이) **따라가기 벅찰정도로 빠르게 변화** 한다. 개발자가 관심을 가지는 기술(유행기술)을 빠르게 도입하고 유용하다면 빠르게 적용했던 코드를 수정하고 애플리케이션 속성키를 정돈하면서 발전시키고, 사람들의 관심이 사그라들거나 지원이 사라진 기술에 대해서는 과감하게 제거(Deprecated)한다. 그래서 스프링 부트는 새로운 버전이 출시되면 어떤 점이 달라졌고 무엇이 새롭게 추가되었는지를 파악하는 것이 꽤 중요하다. 나처럼 무턱대로 버전업 했다가 작동하지 않는 애플리케이션을 다시 재작동시키기 위한 삽질을 피하려면 '설명서를 잘 읽어야 한다'.  지금부터,

> 스프링 부트 설명서를 읽는 어느 #월급쟁이개발자 의 방법을 소개한다.

# 스프링 부트업데이트 소식 확인

스프링 부트는 변화과정을 다양한 정보매체를 통해 비교적 상세하게 공개하고 있다. 이는 오픈소스(Open source) 라는 특성과 많은 사람이 협업하기 때문에 가능한 일이다. 자신에게 맞는 정보매체를 선택하여 스프링 부트와 관련소식을 접할 수 있는데, 내가 스프링 부트 관련소식을 접하는 경로는 다음과 같다.

## SNS

트위터를 비롯해서 페이스북 등 SNS 안에 있는 개발자 커뮤니티를 기웃거리면 스프링 부트 업데이트를 비롯한 다양한 소식을 빠르게 접할 수 있다(... 나는 SNS 중독자 일지도...).

- 트위터
    - [https://twitter.com/springboot](https://twitter.com/springboot)

        ![]({{"/assets/post/2020-05-25/2020-05-25-img-01.png" | absolute_url }})

        스프링 부트 출시를 비롯한 스프링 부트 관련 소식을 가장 빠르게 접할 수 있다.

- 페이스북
    - 한국스프링유저그룹(KSUG, [https://www.facebook.com/groups/springkorea](https://www.facebook.com/groups/springkorea))

        ![]({{"/assets/post/2020-05-25/2020-05-25-img-02.png" | absolute_url }})

        스프링과 관련된 다양한 활동이 이뤄지고 있는 대표적인 커뮤니티로 부지런한 누군가가 공유해주는 이런 뉴스를 빠르게 접할 수 있다. 더불어서 궁금한 점을 물으면 누군가가 답해준다.

- 지인
    - @[Outsideris](https://twitter.com/Outsideris)([https://twitter.com/](https://twitter.com/Outsideris)): 다양한 개발소식을 공유하는 인싸 **풀스택 개발자** 아웃사이더님

        ![]({{"/assets/post/2020-05-25/2020-05-25-img-03.png" | absolute_url }})

        개발 및 일상의 다양한 소식을 엿볼 수 있다.

    - @ihoneymon([https://twitter.com/ihoneymon](https://twitter.com/ihoneymon)): #월급쟁이개발자

        ![]({{"/assets/post/2020-05-25/2020-05-25-img-04.png" | absolute_url }})

        개발관련 소식은 #월급쟁이개발자 라는 태그와 함께 제공하고 있다. 

## [spring.io](http://spring.io) 블로그 - release 카테고리

스프링 부트의 변경사항을 간략하게 확인할 수 있다. 변경사항을 살펴볼 수 있는 링크를 제공는데 이 링크를 통해 보다 자세한 내용을 확인할 수 있다. 

- 참고: [https://spring.io/blog/2020/05/15/spring-boot-2-3-0-available-now](https://spring.io/blog/2020/05/15/spring-boot-2-3-0-available-now)
- 다루는 내용
    - 새로운 내용: 보다 자세한 내용은 스프링 부트 출시노트에서 다룬다.
    - 새로운 지원기능
    - 의존성 라이브러리 업그레이드

![]({{"/assets/post/2020-05-25/2020-05-25-img-05.png" | absolute_url }})

## 스프링 부트 깃헙 위키

[spring.io](http://spring.io) 에서 제공하는 출시노트(release note) 보다 좀 더 상세한 정보를 얻을 수 있다. 위키(wiki)라는 시스템의 특성을 살려 정식버전이 출시하기 전 마일스톤과 GA 상태일 때 관련사항을 확인할 수 있다. 

- 정식버전이 출시하면 마일스톤과 GA 과정에서 지원했던 기능이나 설정이 변경되거나 제거될 수 있다는 것을 유의하자.
- 참고: [https://github.com/spring-projects/spring-boot/wiki](https://github.com/spring-projects/spring-boot/wiki)
- 다루는 내용
    - 스프링 사이트 출시알림보다 상세한 내용을 제공한다.
    - 스프링 부트 출시버전으로 업그레이드 하는 방법
        - 스프링 부트 1.5 → 2.0
        - 스프링 부트 2.2 에서 제거대상이 되었던 클래스, 메서드와 속성에 대응할 수 있는 도구
    - 최소사양 변경사항
        - 스프링 부트 2.3 은 그레이들 6.3 이상 사용을 권장한다(나는 그레이들 6.4.1 이상 권장)
    - 변경사항
    - 의존성 라이브러리
    - 제거대상

![]({{"/assets/post/2020-05-25/2020-05-25-img-06.png" | absolute_url }})

## 스프링 부트 레퍼런스 문서

스프링 부트에 대한 가장 상세한 정보를 얻을 수 있는 곳이다. 스프링 부트에 익숙하건 그렇지 않건 가장 자주 봐야한다. 스프링 부트 문서는 내용이 정말 방대하다. 거기서 더 나아가 서드파티 라이브러리를 사용하게 되는 경우 봐야하는 문서양은 정말 어마어마해진다. 

- [https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/)

![]({{"/assets/post/2020-05-25/2020-05-25-img-07.png" | absolute_url }})

스프링 부트 사용에 앞서서 가볍게 레퍼런스 문서를 가볍게 읽어준 후, 스프링 부트 입문서를 읽으면 좀 더 빠르게 이해할 수 있다. 영어라서 어렵게 느껴진다면 크롬에서 해당페이지를 '한국어'로 번역해서 읽어봐도 좋다. 대략적인 내용을 파악할 수 있다.

## 스프링 부트 입문서

...

# 변경사항 확인

스프링 부트에 관한 새로운 소식을 접했으면 그 안에서 자신이 사용하는 것에 대한 변경사항을 확인해야 한다. 그 과정에서 살펴볼 수 있는 내용들을 기술한다. 

## [spring.io](http://spring.io) 블로그 확인

- release([https://spring.io/blog/category/releases](https://spring.io/blog/category/releases))
    - 스프링 부트를 비롯한 스프링 생태계의 다양한 소식을 접할 수 있다.
    - 출시된 스프링 부트에 대한 개괄적인 내용을 살펴보기 좋다.

## 스프링 부트 깃헙 위키

- 스프링 부트 깃헙 위키 - Release([https://github.com/spring-projects/spring-boot/wiki#release-notes](https://github.com/spring-projects/spring-boot/wiki#release-notes)) 확인
    - 개괄적인 변경사항을 확인하는데 좋다.
    - 출시버전에 맞춰 변경된 서드파티 라이브러리의 변동을 확인할 수 있다.
    - 신규도입기능(Java 지원버전, 새로운 라이브러리 지원 구성 추가 등)
    - 예: `spring-boot-starter-validation`  추가:  `spring-boot-starter-web` 모듈에 포함되어 있던 `validation-api` 제외되어 `spring-boot-starter-validation` 별도모듈로 분리되었다.

        ![]({{"/assets/post/2020-05-25/2020-05-25-img-08.png" | absolute_url }})

        ![]({{"/assets/post/2020-05-25/2020-05-25-img-09.png" | absolute_url }})

## 스프링 부트 레퍼런스 문서

- 시스템 요구사항(System requirement): [https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#getting-started-system-requirements](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#getting-started-system-requirements)
    - 빌드도구 확인
        - 그레이들: 그레이들은 업그레이드가 빈번하게 일어난다. 메이저 버전이 변경되는 경우는 특히 유심히 살펴봐야한다.
        - 메이븐
    - 서블릿 컨테이너 확인
        - 사용하는 서블릿 컨테이너 버전에 따라 사용가능한 서블릿, 웹소켓 등의 사양이 달라질 수 있다.
    - 지원언어 및 버전 확인
        - 사용하는 언어의 지원버전을 확인한다.
- 부록(Appendix): [https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#appendix](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#appendix)
    - Appendix A: 공통 애플리케이션 속성
        - 스프링 부트에서 관리하는 공통 애플리케이션 속성 확인
        - 필요에 따라서는 스프링 부트에서 제공하는 `@ConfigurationProperties` 클래스를 확인하여 기본속성이나 어떤 유형의 값이 적용가능한지 확인해야 한다.
    - Appendix F: Dependency versions
        - 스프링 부트에서 관리하는 서드파티 라이브러리 확인
        - BOM (Bill of Material): 서드파티 라이브러리 버전은 spring-boot-dependencies 에서 관리한다.
        - [https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#dependency-versions](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#dependency-versions)

## 소스코드 확인

- 스프링 부트는 오픈소스 프로젝트
    - [https://github.com/spring-projects/spring-boot](https://github.com/spring-projects/spring-boot)
    - 태그가 잘 정리되어 있어 출시버전 별 코드를 확인할 수 있다.

        ![]({{"/assets/post/2020-05-25/2020-05-25-img-10.png" | absolute_url }})

- `master` 브랜치는 현재 배포되고 있는 코드와 일치한다.
    - 레퍼런스 문서는 `current` 와 일치한다.
    - [https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#legal)
    - 원하는 버전을 `current` 와 바꿔 입력하면 해당 레퍼런스 문서를 볼 수 있다.

        ![]({{"/assets/post/2020-05-25/2020-05-25-img-11.png" | absolute_url }})

        - ex) [https://docs.spring.io/spring-boot/docs/**1.5.12.RELEASE**/reference/htmlsingle](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#legal)
        - ex) [https://docs.spring.io/spring-boot/docs/**2.0.0.RELEASE**/reference/htmlsingle](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#legal)
        - ex) [https://docs.spring.io/spring-boot/docs/**2.3.0.RELEASE**/reference/htmlsingle](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#legal)
- 마일스톤([https://github.com/spring-projects/spring-boot/milestones](https://github.com/spring-projects/spring-boot/milestones)) 확인
    - 앞으로 출시될 스프링 부트에 추가되거나 변경될 내용을 확인할 수 있다.

    ![]({{"/assets/post/2020-05-25/2020-05-25-img-12.png" | absolute_url }})

# 변경사항 적용

## 소스코드 확인

스프링 부트의 변경사항과 권장구성은 아래 `spring-boot-autoconfigure` 모듈에 모여있다고 봐도 된다. 

- [https://github.com/spring-projects/spring-boot/tree/master/spring-boot-project/spring-boot-autoconfigure](https://github.com/spring-projects/spring-boot/tree/master/spring-boot-project/spring-boot-autoconfigure)

## 예제 프로젝트 관리

내가 사용하는 기능들을 학습하기 위해 구현한 프로젝트를 이용해서 스프링 부트를 업그레이드 하고 빌드테스트를 돌리면서 확인하는 방법이 있다. 가장 빠르고 직접적으로 자신의 프로젝트에 끼치는 영향을 확인할 수 있다. 

스프링 부트가 출시되면 습관적(??)으로 업그레이드를 하는 나에게는 가장 안전하고 좋은 방법이다. 위에서 새로운 소식과 변경사항을 확인하는 방법을 거론했지만, 나는 이렇게 새로운 버전으로 업그레이드 후 뭔가가 안되면 "뭐지? 왜 안되는거야?" 라며 뒤늦게 출시노트와 참고문서를 살펴보며 변경사항을 확인한다.

> 그 삽질을 통해 스프링 부트의 변화를 체감하는 나는 변태인가...?

예제: [https://github.com/ihoneymon/boot-spring-boot](https://github.com/ihoneymon/boot-spring-boot)

![]({{"/assets/post/2020-05-25/2020-05-25-img-13.png" | absolute_url }})

# 맺으며

스프링 부트는 내가 적응하는 속도보다 빠르게 변화한다. 그 변화에 적응하기 위한 나름의 요령을 정리해봤다. 

사용기술 참고문서(Reference documentation)를 살피고 출시버전에 대한 출시노트(Release note)를 확인하여 자신이 알고 있던 지식과 차이점을 확인하는 방식으로 접근하길 바란다.  

스프링 부트에 익숙해지려면, 지속가능한 학습 및 사용방법을 스스로 익혀야 한다. 이것을 습득하고 나면 스프링 부트가 새로운 버전을 출시해도 허둥지둥하지 않고 능숙하게 대응할 수 있을 것이다.

> 꾸준함을 이기는 것은 없다.

...라고 누군가 그랬지만 노는 게 좋다.

# 참고

- [https://twitter.com/springboot](https://twitter.com/springboot)
- [https://www.facebook.com/groups/springkorea](https://www.facebook.com/groups/springkorea)
- [https://twitter.com/Outsideris](https://twitter.com/Outsideris)
- [https://twitter.com/ihoneymon](https://twitter.com/ihoneymon)
- [https://spring.io/blog/category/releases](https://spring.io/blog/category/releases)
- [https://github.com/spring-projects/spring-boot/wiki#release-notes](https://github.com/spring-projects/spring-boot/wiki#release-notes)
- [https://github.com/spring-projects/spring-boot](https://github.com/spring-projects/spring-boot)
- [https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#legal)
- [https://github.com/ihoneymon/boot-spring-boot](https://github.com/ihoneymon/boot-spring-boot)