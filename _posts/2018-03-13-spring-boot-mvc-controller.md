---
layout: post
title: "[springboot] Spring MVC 자동구성 제어하기"
categories: [tech]
tags: [springboot,spring,mvc,autoconfiguration]
date: 2018-03-13 11:30
---

## 자동구성된 스프링 MVC 구성 조작하기

자동구성된 스프링 MVC 구성을 큰 변경없이 추가적인 조작하려면 다음과 같은 형태로 구성한다.

```
@Configuration
public class WebMvcConfig implements WebMvcConfigurer, WebMvcRegistrations {
}
```

  ``WebMvcConfigurer`` 는 자동구성된 스프링 MVC 구성에 ``Formatter``, ``MessageConverter`` 등을 추가등록할 수 있다. ``WebMvcRegistrations``는 ``RequestMappingHandlerMapping``, ``RequestMappingHandlerAdapter``와 ``ExceptionHandlerExceptionResolver``를 재정의할 때 사용한다.


``WebMvcConfigurer``와 ``WebMvcRegistrations`` 소스를 살펴보면 메서드들을 ``default`` 메서드로 선언했다. 필요한 메서드만 구현해서 사용하라는 의미다. Java7을 지원하는 스프링 부트 1.5 에서는 [``default`` 메서드(https://goo.gl/A7CL31)](https://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html)가 없었기에 ``WebMvcConfigurer``를 사용하려면 인터페이스에 선언된 메서드를 모두 구현해야 했다. 그런 불편함을 해소하고자 ``WebMvcConfigurerAdapter`` 추상 클래스를 제공했다. 이 추상 클래스를 상속받아 필요한 메서드만 오버라이드했다.

스프링 부트 2.0부터 Java8과 스프링 5.0을 사용하면서 ``WebMvcConfigurer`` 메서드에 ``default``를 선언했다. 그 덕분에 ``WebMvcConfigurer``를 구현하는 클래스에서 모든 메서드를 구현해야하는 강제력이 사라졌다. 쓰임새가 사라진 ``WebMvcConfigurerAdapter`` 클래스는 스프링 부트 2.0에서 제외(Deprecated)되었다.


## 스프링 MVC 구성 제어권한 가지기
자동구성된 스프링 MVC 구성을 개발자가 완벽히 제어하는 방법은 다음과 같다.

1. ``@Configuration`` 과 ``@EnableWebMvc``를 함께 선언
  ```
  @Configuration
  @EnableWebMvc
  public class WebMvcConfig {}
  ```


  ``@EnableWebMvc``를 선언하면  ``WebMvcConfigurationSupport``에서 구성한 스프링 MVC 구성을 불러온다.


2. ``@Configuration`` 과 ``@EnableWebMvc``를 함께 선언한 클래스가 ``WebMvcConfigurer`` 인터페이스 구현

  ```
  @Configuration
  @EnableWebMvc
  public class WebMvcConfig implements WebMvcConfigurer {
      @Override
      public void addFormatters(FormatterRegistry formatterRegistry) {
          formatterRegistry.addConverter(new MyConverter());
      }

      @Override
      public void configureMessageConverters(List<HttpMessageConverter> converters) {
          converters.add(new MyHttpMessageConverter());
      }
  }
  ```

  위처럼 선언하면 ``WebMvcConfigurationSupport``에서 자동구성한 스프링 MVC 구성에 ``Formatter``, ``MessageConverter`` 등을 추가적으로 등록할 수 있다.

3. ``@EnableWebMvc`` 없이 스프링 MVC 구성을 변경하는 방법

```
@Configuration
public class WebMvcConfig extends WebMvcConfigurationSupport {

    @Bean
    @Override
    public RequestMappingHandlerMapping requestMappingHandlerMapping() {
        return super.requestMappingHandlerMapping();
    }
}
```

## 정리
스프링 MVC 자동구성은 ``WebMvcAutoConfiguration``이 담당한다. 이 구성이 활성화되는 조건 중에 ``WebMvcConfigurationSupport`` 타입의 빈을 찾을 수 없을 때 라는 조건이 있다.

```
@Configuration
@ConditionalOnWebApplication(type = Type.SERVLET)
@ConditionalOnClass({ Servlet.class, DispatcherServlet.class, WebMvcConfigurer.class })
@ConditionalOnMissingBean(WebMvcConfigurationSupport.class)
@AutoConfigureOrder(Ordered.HIGHEST_PRECEDENCE + 10)
@AutoConfigureAfter({ DispatcherServletAutoConfiguration.class,
		ValidationAutoConfiguration.class })
public class WebMvcAutoConfiguration {
}
```
바로 이 조건(``@ConditionalOnMissingBean(WebMvcConfigurationSupport.class)``).

그런데 위에서 거론했던 ``@EnableWebMvc``를 스프링 MVC 구성을 위한 클래스에 선언하면 ``WebMvcConfigurationSupport``을 불러와 스프링 MVC를 구성한다. 이 과정에서 ``WebMvcConfigurationSupport``가 컴포넌트로 등록되어 ``@ConditionalOnMissingBean(WebMvcConfigurationSupport.class)`` 조건을 만족시키지 못하게 되어 ``WebMvcAutoConfiguration``은 비활성화 된다. 이와 유사하게 ``WebMvcConfigurationSupport``를 확장한 클래스에 ``@Configuration``를 선언하면 동일하게 적용된다.
