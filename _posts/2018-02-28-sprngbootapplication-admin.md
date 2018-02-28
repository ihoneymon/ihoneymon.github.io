---
layout: post
title: SpringBootApplication Admin(JMX client) 기능에 대해서
tags: [java,spring,springboot,application,admin,jmx]
categories: [tech,spring-boot]
date: 2018-02-28 13:30:00
---

## Spring Boot Application Admin 기능
오늘 백기선님([](http://whiteship.me/))의 유투브 생방([](https://www.youtube.com/watch?v=8fK1tA7C6Ss))에 뒤늦게 참여하다가 SpringBootApplication admin에 대한 기능을 살펴봤습니다. 스프링부트에서는 JMX(**J**ava **M**anagement e**X**tension) 에서 접근할 수 있는 속성들을 많이 제공합니다. 개인적으로는 JMX 기능을 통해서 애플리케이션이나 서버를 관리하던 경험이 전무한 탓에 이에 대해서는 가볍게 무시하고 넘어갔지만, 백기선님은 NHN에서 근무할 때 꽤 유용했다고 하시니 다시한번 살펴보기로 했습니다.

이상민님의 책 ['자바 성능을 결정짓는 코딩 습관과 튜닝 이야기'(http://www.yes24.com/24/Goods/2842880?Acode=10)](http://www.yes24.com/24/Goods/2842880?Acode=10) 에서 모니터링 API로써 JMX에 대해 다루고 있다(한번 읽어봐야겠다).

스프링 부트 애플리케이션에서는 관리 기능과 관련한 속성(``spring.application.admin.enabled``)을 활성화할 수 있다. 이 기능을 활성화하면 실행되고 있는 운영체제의 ``MBeanServer``에 [`SpringApplicationAdminMXBean`](https://github.com/spring-projects/spring-boot/tree/v2.0.0.RC2/spring-boot-project/spring-boot/src/main/java/org/springframework/boot/admin/SpringApplicationAdminMXBean.java)가 노출된다.

```java
/**
 * An MBean contract to control and monitor a running {@code SpringApplication} via JMX.
 * Intended for internal use only.
 *
 * @author Stephane Nicoll
 * @since 1.3.0
 */
public interface SpringApplicationAdminMXBean {

	/**
	 * Specify if the application has fully started and is now ready.
	 * @return {@code true} if the application is ready
	 * @see org.springframework.boot.context.event.ApplicationReadyEvent
	 */
	boolean isReady();

	/**
	 * Specify if the application runs in an embedded web container. Return {@code false}
	 * on a web application that hasn't fully started yet, so it is preferable to wait for
	 * the application to be {@link #isReady() ready}.
	 * @return {@code true} if the application runs in an embedded web container
	 * @see #isReady()
	 */
	boolean isEmbeddedWebApplication();

	/**
	 * Return the value of the specified key from the application
	 * {@link org.springframework.core.env.Environment Environment}.
	 * @param key the property key
	 * @return the property value or {@code null} if it does not exist
	 */
	String getProperty(String key);

	/**
	 * Shutdown the application.
	 * @see org.springframework.context.ConfigurableApplicationContext#close()
	 */
	void shutdown();

}
```

> jmx 에 노출되는 이름은 ``spring.application.admin.jmx-name`` 속성을 통해 재정의할 수 있다.

![JConsole 에서 BootSpringBootApplication 발견!]({{"/assets/post/2018-02-28-springbootapplication-admin-jmx-jconsole-01.png" | absolute_url }})

![JConsole 에서 BootSpringBootApplication 연결]({{"/assets/post/2018-02-28-springbootapplication-admin-jmx-jconsole-02.png" | absolute_url }})

![BootSpringBootApplication에서 노출된 MBean 항목들]({{"/assets/post/2018-02-28-springbootapplication-admin-jmx-jconsole-03.png" | absolute_url }})

이렇게 ``SpringApplicationAdminMXBean``가 노출되면 원격에서 스프링 부트 애플리케이션을 관리할 수 있게 된다. 예전에는 스프링 부트 액츄에이터(Actuator)에서 [Remote Shell](https://docs.spring.io/spring-boot/docs/1.5.10.RELEASE/reference/htmlsingle/#production-ready-remote-shell)기능을 지원했지만, 스프링 부트 2.0 에서는 **제외(Deprecated)**되었다.

> 이 기능을 사용하고 싶다면 ``org.crsh:crsh.shell.telnet`` 의존성을 추가하면 된다. 굳이 터미널로 접근해서 애플리케이션을 관리해야할 필요성은 많이 사라져간다.


## 정리
실행중인 자바 애플리케이션의 정보를 MBeanServer 에 등록하는 MBean 클라이언트 기능을 ``spring.application.admin.enabled`` 속성으로 활성화할 수 있다. 이 속성이 활성화되면 JConsole 등 MBean 사양을 따르는 감시 및 관리도구에서 접근하여 애플리케이션 정보를 살펴보고 종료하는 등의 원격제어가 가능해진다.

## 추가
### 스프링 부트 액츄에이터(Spring Boot Actuator) MXBeans
추가적으로, 스프링 부트 [액츄에이터(Actuator)](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#production-ready)도 MBean 으로 노출된다. 이에 대해서는 추후에 살펴보겠다.

![Spring Boot Actuator Mbeans]({{"/assets/post/2018-02-28-springbootapplication-admin-jmx-jconsole-04.png" | absolute_url }})

## 참고
* ![JMX Archirecture](https://upload.wikimedia.org/wikipedia/en/thumb/d/db/Jmxarchitecture.png/400px-Jmxarchitecture.png)
* [SpringBootApplication Admin 기능(https://goo.gl/LgqMc3)](https://docs.spring.io/spring-boot/docs/2.0.0.RC2/reference/htmlsingle/#boot-features-application-admin)
* [Introducing MBean(https://goo.gl/pQeTcf)](https://docs.oracle.com/javase/tutorial/jmx/mbeans/index.html)
* [Standard MBeans(https://goo.gl/NqN6Pa)](https://docs.oracle.com/javase/tutorial/jmx/mbeans/standard.html)
* [MBeanServer](http://cris.joongbu.ac.kr/course/2018-1/jcp/api/javax/management/MBeanServer.html)
> 에이전트측에서 MBean 를 조작하기 위한 인터페이스입니다
* [JMX Architecture](https://docs.oracle.com/javase/7/docs/technotes/guides/jmx/overview/architecture.html)
* [Java EE Standard and Specification](https://goo.gl/QfxNhh)
