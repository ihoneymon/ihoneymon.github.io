---
layout: post
title: "[spring-boot] 2.1.0.RELEASE 에 대하여"
categories: [tech]
tags: [springboot, release]
date: 2018-11-24 00:00
---

스프링 부트 2.1.0.RELEASE 에서는 스프링 부트 5.1.0.RELEASE 가 포함되어있다. 5.1.0 버전은 이전
5.0.X 와 조금 더 달라졌다. 그래서 스프링 부트 2.1.0.RELEASE 를 적용하려 한다면 고려할 사항이 있으니 가이드를
살펴보자.

# 요약

  - 스프링 부트 2.1.0.RELEASE 는 스프링 프레임워크 5.1.0.RELEASE 포함
    
      - 스프링 프레임워크 5.1.0.RELEASE
        
          - Java EE 8 지원 → 라이브러리 버전 하한선 상승
        
          - 중첩 구성 클래스 탐색방식 변경
        
          - 스프링 부트 스프링빈 중복 생성정책 변경
    
      - 스프링 부트 2.1.0.RELEASE
        
          - 스프링빈 중복 허용여부 `spring.main.allow-bean-definition-overriding`
            속성 제공

# 스프링 프레임워크 변경사항

보다 자세한 사항은 아래 링크를
    참고하자:

  - <https://github.com/spring-projects/spring-framework/wiki/Upgrading-to-Spring-Framework-5.x>

  - JDK 11 지원(Java LTS 버전이 출시되면 해당바전을 지원하는 정책 펼듯)

  - [지원 라이브러리 베이스라인이
    업그레이드](https://github.com/spring-projects/spring-framework/wiki/Upgrading-to-Spring-Framework-5.x#upgrading-to-version-50)
    되었다.
    
      - Java 8 맞춰서 코드베이스 변경
    
      - Java EE 8 지원 → WAS 요구사항 버전 변경됨
        
          - Servlet 3.1 / 4.0
        
          - JPA 2.1 / 2.2
        
          - Bean Validation 1.1 / 2.0
        
          - JMS 2.0
        
          - JSON Binding API 1.0 (as an alternative to Jackson / Gson)
    
      - 중첩 구성 클래스 탐색방식 변경

> **Important**
> 
> **스프링 프레임워크 5.1.0 은 빈을 등록하는 과정에서 발생하는 오버헤드(지연)를 발생시키는 요소들을 강제로 배제시키는
> 정책**이 적용되었다.
> 
>   - [중첩 구성클래스 탐색(Nested Configuration Class
>     Detection)](https://github.com/spring-projects/spring-framework/wiki/Upgrading-to-Spring-Framework-5.x#nested-configuration-class-detection)

타입(Type) 수준에 선언된 `@Component` 혹은 `@Configuration` 만 컴포넌트 스캔으로 탐색한다. 스프링
프레임워크 5.1.0 부터는 아래처럼 작성한 구성 클래스는 `@Import({BaseConfig.class})` 를 호출해도
탐색되지 않는다.

``` java
public class BaseConfig {
    @Profile("stub")
    @Configuration
    public static class StubConfig {
        @Bean
        public BaseService baseService() {
            return new BaseServiceStub();
        }
    }

    @Profile("!stub")
    @Configuration
    public static class ImplConfig {
        @Bean
        public BaseService baseService() {
            return new BaseServiceImpl();
        }
    }
}
```

위와 같은 형태로 정의한 일반 클래스 안에 구성 클래스를 탐색하는 정책이 변경되었다.

스프링 프레임워크 5.1.0 전에는 다음과 같이 선언해도 `BaseConfig.StubConfig` 와
`BaseConfig.ImplConfig` 를 탐색했지만 스프링 프레임워크 5.1.0 이후에는 적용되지 않는다.

``` java
@Import({BaseConfig.class})
public class AppConfig {
    // 생략
}
```

다음과 같이 중첩클래스를 명시적으로 선언하거나

``` java
@Import({BaseConfig.StubConfig.class, BaseConfig.ImplConfig.class})
public class AppConfig {
    // 생략
}
```

다음과 같이 `@ComponentScan` 에서 패키지를 명시하는 방식을 사용해야 한다.

``` java
@ComponentScan(basePackages = {"io.honeymon.boot.springboot.config"})
public class AppConfig {
    // 생략
}
```

# 스프링 부트

스프링 부트 2.1.0 에서는 스프링빈이 개발자 모르게 덮어쓰이는 상황을 피할 수 있도록
`spring.main.allow-bean-definition-overriding` 조건을 추가하고 이 속성을 `false` 로
정의하여 비활성화시킨다.

  - [스프링빈
    덮어쓰기](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.1-Release-Notes#bean-overriding)

> **Note**
> 
> 프로파일에 따라서 동일한 이름의 빈을 다른 클래스로 생성하는 경우 문제에 부딪칠 수
    있다.

# 참고

  - <https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.1-Release-Notes>

  - <https://github.com/spring-projects/spring-framework/wiki/Upgrading-to-Spring-Framework-5.x>
