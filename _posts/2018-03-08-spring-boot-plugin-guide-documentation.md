---
layout: post
title: 스프링 부트 빌드도구 플러그인 가이드(그레이들Gradle 과 메이븐Maven)
categories: [tech]
tags: [springboot,buildtool,gradle,maven]
date: 2018-03-08 17:30
---

스프링 부트는 빌드시 사용되는 편의기능을 가진 그레이들과 메이븐에 대한 플러그인을 지원한다. 스프링 부트 참고문서에서는 이 플러그인에 대한 설명이 빈약하다

* Spring Boot Gradle plugin Guide:
[https://docs.spring.io/spring-boot/docs/current/gradle-plugin/reference/html/](https://docs.spring.io/spring-boot/docs/current/gradle-plugin/reference/html/)
> ![Spring Boot Gradle plugin Guide]({{"/assets/post/2018-03-08-spring-boot-plugin-guide-01.png" | absolute_url }})

* Spring Boot Maven plugin Guide:
[https://docs.spring.io/spring-boot/docs/current/maven-plugin/index.html](https://docs.spring.io/spring-boot/docs/current/maven-plugin/index.html)
> ![Spring Boot Maven plugin Guide]({{"/assets/post/2018-03-08-spring-boot-plugin-guide-02.png" | absolute_url }})

스프링 부트 빌드와 관련하여 필요한 기능에 대해서 사용하는 빌드도구에 따라서 각 문서를 참조하기 비란다.

## P.S.
책 쓰다가 배너에서 사용하는 ``${application.name}`` 속성 때문에 찾아보다가

```
jar {
  manifest {
    attributes("KEY1", "VALUE1", "KEY2", "VALUE2")
  }
}
```

``jar`` 에서 ``bootJar``로 변경된 걸 확인했다.

```
bootJar {
  manifest {
    attributes("KEY1", "VALUE1", "KEY2", "VALUE2")
  }
}
```
