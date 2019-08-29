---
layout: post
title: 코틀린 class 를 열어다오.  
category: [tech]
tags: [kotlin,class,final,open]
date: 2018-03-08 17:30
---

[http://start.spring.io/?language=kotlin](http://start.spring.io/?language=kotlin)으로 스프링 부트 애플리케이션을 생성했다. 기본 프로젝트 코드를 살펴봤다.

```kotlin
@SpringBootApplication
class ConfigServerApplication

fun main(args: Array<String>) {
    runApplication<ConfigServerApplication>(*args)
}
```
그런데 이렇게 생선된 애플리케이션을 실행하면 다음과 같은 실패로그를 보게 된다.

```
org.springframework.beans.factory.parsing.BeanDefinitionParsingException: Configuration problem: @Configuration class 'ConfigServerApplication' may not be final. Remove the final modifier to continue.
Offending resource: io.honeymon.msa.configserver.ConfigServerApplication
	at org.springframework.beans.factory.parsing.FailFastProblemReporter.error(FailFastProblemReporter.java:72) ~[spring-beans-5.0.4.RELEASE.jar:5.0.4.RELEASE]
	at org.springframework.context.annotation.ConfigurationClass.validate(ConfigurationClass.java:217) ~[spring-context-5.0.4.RELEASE.jar:5.0.4.RELEASE]
	at org.springframework.context.annotation.ConfigurationClassParser.validate(ConfigurationClassParser.java:207) ~[spring-context-5.0.4.RELEASE.jar:5.0.4.RELEASE]
	at org.springframework.context.annotation.ConfigurationClassPostProcessor.processConfigBeanDefinitions(ConfigurationClassPostProcessor.java:317) ~[spring-context-5.0.4.RELEASE.jar:5.0.4.RELEASE]
	at org.springframework.context.annotation.ConfigurationClassPostProcessor.postProcessBeanDefinitionRegistry(ConfigurationClassPostProcessor.java:233) ~[spring-context-5.0.4.RELEASE.jar:5.0.4.RELEASE]
	at org.springframework.context.support.PostProcessorRegistrationDelegate.invokeBeanDefinitionRegistryPostProcessors(PostProcessorRegistrationDelegate.java:273) ~[spring-context-5.0.4.RELEASE.jar:5.0.4.RELEASE]
	at org.springframework.context.support.PostProcessorRegistrationDelegate.invokeBeanFactoryPostProcessors(PostProcessorRegistrationDelegate.java:93) ~[spring-context-5.0.4.RELEASE.jar:5.0.4.RELEASE]
	at org.springframework.context.support.AbstractApplicationContext.invokeBeanFactoryPostProcessors(AbstractApplicationContext.java:693) ~[spring-context-5.0.4.RELEASE.jar:5.0.4.RELEASE]
	at org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:531) ~[spring-context-5.0.4.RELEASE.jar:5.0.4.RELEASE]
	at org.springframework.boot.web.servlet.context.ServletWebServerApplicationContext.refresh(ServletWebServerApplicationContext.java:140) ~[spring-boot-2.0.0.RELEASE.jar:2.0.0.RELEASE]
	at org.springframework.boot.SpringApplication.refresh(SpringApplication.java:752) [spring-boot-2.0.0.RELEASE.jar:2.0.0.RELEASE]
	at org.springframework.boot.SpringApplication.refreshContext(SpringApplication.java:388) [spring-boot-2.0.0.RELEASE.jar:2.0.0.RELEASE]
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:327) [spring-boot-2.0.0.RELEASE.jar:2.0.0.RELEASE]
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:1246) [spring-boot-2.0.0.RELEASE.jar:2.0.0.RELEASE]
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:1234) [spring-boot-2.0.0.RELEASE.jar:2.0.0.RELEASE]
	at io.honeymon.msa.configserver.ConfigServerApplicationKt.main(ConfigServerApplication.kt:13) [classes/:na]
```

로그를 보니 ``@Configuration``가 선언된 클래스는 ``final`` 이어서는 안된다고 한다.

> 난 ``final`` 선언한적도 없는데?
>> 자바 개발자 마인드...라기보다는 나는 ``final`` 선언이 크게 습관화되지 않았다.

코틀린 문서를 찾아보니 코틀린 클래스는 기본적으로 final 이라고 한다. 이 클래스를 상속하려는 경우에는 ``open``이라는 접근제한자를 앞에 붙여야 한다.

```kotlin
@SpringBootApplication
open class ConfigServerApplication

fun main(args: Array<String>) {
    runApplication<ConfigServerApplication>(*args)
}
```

성공!

## 정리
* 스프링 부트에서 ``@Configuration`` 클래스는 ``final``이어서는 안된다.
* 코틀린 클래스는 접근제한자 선언안하면 기본은 ``final`` 선언이다.
* 스프링 부트 애플리케이션은 ``open``을 선언하자.

## 참고
* [Classes and Inheritance](https://kotlinlang.org/docs/reference/classes.html#classes-and-inheritance)
