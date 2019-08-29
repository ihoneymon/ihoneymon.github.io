---
layout: post
title: 스프링 부트 2.0.0.RELEASE
category: [tech,spring-boot]
tags: [java,spring,springboot,release]
date: 2018-03-01 23:00
---

## 스프링 부트 2.0 정식 출시
* [https://spring.io/blog/2018/03/01/spring-boot-2-0-goes-ga](https://spring.io/blog/2018/03/01/spring-boot-2-0-goes-ga)

## 스프링 부트 2.0 새로운 점:
- A Java 8 baseline, and Java 9 support.
- Reactive web programming support with Spring ``WebFlux``/``WebFlux.fn``.
- Auto-configuration and starter POMs for reactive Spring Data Cassandra, MongoDB, Couchbase and Redis.
- Support for embedded [Netty](https://netty.io/).
- HTTP/2 for [Tomcat](https://tomcat.apache.org/), [Undertow](http://undertow.io/) and [Jetty](https://www.eclipse.org/jetty/).
- A brand new actuator architecture, with support for Spring MVC, WebFlux and Jersey.
- [Micrometer](https://micrometer.io/) based metrics with exporters for Atlas, Datadog, Ganglia, Graphite, Influx, JMX, New Relic, Prometheus, SignalFx, StatsD and Wavefront.
- Quartz scheduler support.
- Greatly simplified security auto-configuration.

## 정리
기다리고 기다리던 스프링 부트 2.0이 정식으로 출시되었다.

> 스프링 부트 2.0 출시에 맞춰서 쓰고 있는 책은 내일 교정본을 받고 최대한 빨리 출간할 예정이다.

스프링 부트 2.0에서 크게 달라진 점은 [스프링 프레임워크 5](https://docs.spring.io/spring/docs/5.0.4.RELEASE/spring-framework-reference/)를 기반으로 하여 [리액티브 지원](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.0-Release-Notes#reactive-spring)이 가장 큰 부분이라고 생각된다.

> 아직까지는 리액티브 웹 프로그래밍을 적극적으로 활용한 경험은 없는 상태라서 살펴봐야할 부분이 많다.

살펴볼 수 있다.

관심가는 변화 중 하나는 JDBC 라이브러리가 Tomcat JDBC에서 [HikariCP](https://brettwooldridge.github.io/HikariCP/) 로 변경되었다.
> 기존에는 Tomcat JDBC를 제외(exclude)하고 HikariCP 의존성을 추가해야했지만 지금은 굳이 그럴 필요가 없어졌다.

그리고 운영과 관련된 액츄에이터(Actuator)에서 DropWizard에 맞춰 지원하던 형식이 [Micrometer](https://micrometer.io/)에서 쉽게 사용할 수 있도록 개편되었다. 더불어서 액츄에이터 기본경로에 ``/actuator``가 접두사로 붙게 되었다.

그레이들 관련한 플러그인도 조금 더 개선이 될 것으로 보인다.

## 참고
* [Spring Boot 2.0 Release note](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.0-Release-Notes)
* [Spring Boot 1.5 -> 2.0 Migration Guide](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.0-Migration-Guide)
* [백기선님의 스프링 부트 - Youtube](https://goo.gl/Qm6X5V)
