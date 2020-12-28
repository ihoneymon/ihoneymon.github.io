---
title: "[B-C-D] 001. 개발자 인생은 빌드와 배포사이 코딩이다."
layout: post
category: 'tech'
tags: [tech, spring, springboot,log]
date: 2019-05-03 09:00:00
---

\'스프링 부트를 어떻게 설명할까\' 하고 고민하다가 뇌리를 스쳐간 한 문장.

> Life is **Choice** between **Birth** and **Death**.
>
> 인생은 삶과 죽음 사이의 선택(의 연속)이다.
>
> ---  장 폴 사르트르

위 문장을 변형한 아래 문장이 탄생한다.

> Developer life is **Coding** between **Build** and **Deploy**.
>
> 개발자 인생은 (프로젝트) 빌드와 배포 사이 삽질(=코딩)(의 연속)이다.
>
> ---  \#월급쟁이개발자 허니몬


> 크흐. 두고두고 봐도 참 명문이다...​.. 음트트트.


이후에는 스프링 부트를 설명하는 자리가 있으며 나는 어김없이 \'B-C-D'를
외치고 있다.

![Developer life is Coding between Build and Deploy.]({{"/assets/post/2019-05-03/2019-05-03-01.png" | absolute_url }})

잠자리에 들기전 문득 \'B-C-D\' 시리즈로 블로그 포스팅하면 좋겠다는
생각을 했다. 그리고 구성은 대략 다음과 같이 구성했다:

> **Important**
>
> -   빌드(**B**uild)
>
>     -   빌드도구(Build Tool): Gradle
>
>     -   Gradle Kotlin DSL
>
>     -   Spring Boot Gradle Plugin & BOM
>
> -   코드(**C**ode): 프레임워크와 그를 기반한 코딩에 대한 이야기
>
>     -   `` @SpringBootApplication` ``
>
>     -   스프링 애노테이션 프로그래밍 모델
>
>     -   프로파일(`@Profile`)과 조건(`@Condition`) 처리
>
>         -   프로파일 전략
>
>     -   자동구성(`AutoConfiguration`)
>
>     -   애플리케이션 속성(& 외부구성)
>
> -   배포(**D**eploy)
>
>     -   스프링 부트 그레이들 플러그인
>
>     -   배포방식: Jar vs War
>
>     -   로깅설정
>
>     -   Spring Boot Actuator
>
>     -   CI & CD
>
의 이야기를 쭈욱 해보려고 한다.

>   다 쓰려면 얼마나 걸릴까...​. 크흡...​.

그 긴 여정을 시작한다.

P.S. 오프라인 스프링 트레이닝 과정 \'스프링 러너(<https://springrunner.io/>)\'를 진행하고 있다. 곧 \'스프링 부트
201\' 과정도 준비하고 있다. 언제 되려나.
