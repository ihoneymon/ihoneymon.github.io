---
title: "[spring-boot] 스프링 부트 2.2 여행을 준비하는 개발자를 위한 안내서"
layout: post
category: [tech]
tags: [tech, java, spring, spring-boot]
date: 2019-11-06 09:00:00
---

지난 2019-10-16 스프링 부트 2.2가 스프링 5와 발맞춰 출시했다.
스프링 부트 업그레이드와 관련된 내용을 간간히 추가했다. 지속적으로 내용을 보강하겠다.

> Release Spring Boot 2.2.0 (2019-10-16)

## 스프링 부트 2.1 과 달라진 점

### Gradle 최소 요구버전 변경: 4.10+

[Spring Boot Reference Documentation](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#getting-started-system-requirements)

### 스프링 부트 2.1 `@Deprecated` 항목 제거

ex) `RestTemplateBuilder#setConnectTimeout(int connectTimeout)`

[spring-projects/spring-boot](https://github.com/spring-projects/spring-boot/blob/2.1.x/spring-boot-project/spring-boot/src/main/java/org/springframework/boot/web/client/RestTemplateBuilder.java)

### 스프링 프레임워크 5.2 적용

- `@Configuration` 애노테이션 속성 `proxyBeanMethod` 추가
- `MergedAnnotations` : 애노테이션을 처리하기 위한 새로운 API
    - [http://wonwoo.ml/index.php/post/category/web/spring-boot/page/3](http://wonwoo.ml/index.php/post/category/web/spring-boot/page/3)

        MergedAnnotation<SpringBootApplication> springBootApplication = MergedAnnotations.from(Application.class)
            .get(SpringBootApplication.class);
        Class<?>[] scanBasePackageClasses = springBootApplication.getClassArray("scanBasePackageClasses");
        String[] scanBasePackages = springBootApplication.getStringArray("scanBasePackages");
        boolean proxyBeanMethods = springBootApplication.getBoolean("proxyBeanMethods");

### Webflux 및 Reactive  지원 강화

### Kotlin 지원 강화(레퍼런스 문서 내 코틀린 예제코드 추가)

- Kotlin Coroutines 지원

### Spring message - RSocket 지원 추가

[Web on Reactive Stack](https://docs.spring.io/spring/docs/current/spring-framework-reference/web-reactive.html#rsocket)

### `MediaType.APPLICATION_JSON_UTF8` 제거대상

- `StringHttpMessageConverter`를 제외한 `HttpMessageConverter` 기본 문자설정은 `UTF-8`
- `Content-Type: application/json;charset=utf-8` → `Content-Type: application/json` 으로 변환
- 참고: [http://honeymon.io/tech/2019/10/23/spring-deprecated-media-type.html](http://honeymon.io/tech/2019/10/23/spring-deprecated-media-type.html)

### Jakarta EE 의존성

- 스프링 부트 스타터 에서 사용하는 동일한 groupId 의 경우 이동
- Java EE 의존성 이동: `javax` → `jakarta`
- 예
    - `com.sun.mail:javax.mail` → `com.sun.mail:jakarta.mail`
    - `org.glassfish:javax.el` → `org.glassfish:jakarta.el`

### Spring HATEOAS 1.0

- [https://docs.spring.io/spring-hateoas/docs/1.0.0.RELEASE/reference/html/](https://docs.spring.io/spring-hateoas/docs/1.0.0.RELEASE/reference/html/)
- 시스템에서 제공하는 자원(Resource)에 대한 안내매체 역할을 수행
- 좀더 REST 한 API를 만들고 그 정보를 제공할 수 있길!
- Spring MVC & Webflux 지원

### 로깅 파일 사이즈를 좀 더 명확하게 정의할 수 있게 되었다.

- [https://docs.spring.io/spring-boot/docs/2.2.0.RELEASE/reference/html//spring-boot-features.html#boot-features-custom-log-configuration](https://docs.spring.io/spring-boot/docs/2.2.0.RELEASE/reference/html//spring-boot-features.html#boot-features-custom-log-configuration)
- 2.2.0 이전: 기본 10MB, Byte 단위로 설정
- 2.2.0 이후: B, KB, MB, GB, TB 단위로 사용가능

### Hibernate Dialect

- 하이버네이트를 사용할 때 데이터베이스를 탐색하여 적절한 방언을 선택하도록 지원한다.
- `JpaProperties#determineDatabase` 제거대상

        /**
         * Determine the {@link Database} to use based on this configuration and the primary
         * {@link DataSource}.
         * @param dataSource the auto-configured data source
         * @return {@code Database}
         * @deprecated since 2.2.0 in favor of letting the JPA container detect the database
         * to use.
         */
        @Deprecated
        public Database determineDatabase(DataSource dataSource) {
        	if (this.database != null) {
        		return this.database;
        	}
        	return DatabaseLookup.getDatabase(dataSource);
        }

- `JpaProperties#getDatabase()`사용

### 테스트

- JUnit 5 적용
    - [https://junit.org/junit5/docs/current/user-guide/](https://junit.org/junit5/docs/current/user-guide/)
        - Migration Tips: [https://junit.org/junit5/docs/current/user-guide/#migrating-from-junit4-tips](https://junit.org/junit5/docs/current/user-guide/#migrating-from-junit4-tips)
    - 스프링 부트 2.2 부터 JUnit 5 Jupiter 가 적용되었다(JUnit5 == Jupiter, JUnit4 == Vintage).

            test {
                useJUnitPlatform {
                    includeTags "fast", "smoke & feature-a" //@Tag("대응")
                    // excludeTags "slow", "ci"
                    includeEngines "junit-jupiter"
                    // excludeEngines "junit-vintage"
                }
            }

- AssertJ 3.12
    - [https://assertj.github.io/doc/#overview](https://assertj.github.io/doc/#overview)
    - JUnit 의 단언식(Assert expression, `assert~`)은 뭔가 어색한 방식이다.
    - AssertJ 의 단언식이 서술적으로 표현할 수 있어 조금 더 명확하게 확인이 가능하다.
- Hamcrest upgrade 2.1
    - [http://hamcrest.org/](http://hamcrest.org/)
    - 테스트 결과에 대한 검증

### `HttpHiddenMethodFilter` 기본 비활성화

- 브라우저에서 지원하는 요청 메서드타입 `GET` 과 `POST` 뿐

    <form method="POST" action="/update">
    ...
    </form>
    // 
    <form action="/update">
      <input type="hidden" name="_method" value="PUT"/>
    </form>

- 비활성화 이유: `_method` 요청 매개변수(parameter)가 포함된 경우 `HttpHiddenMethodFilter` 에서 요청 본문을 사전에 소비한다.
- 활성화 방법
    - MVC: `spring.mvc.hiddenmethod.filter.enabled=true`
    - Webflux: `spring.webflux.hiddenmethod.filter.enabled=true`
    - 속성명을 보니.. `spring.mvc.filter.hiddenmethod.enabled` 로 변경될 가능성도

### DevTools 설정 디렉터리

- [https://docs.spring.io/spring-boot/docs/2.2.0.RELEASE/reference/html//using-spring-boot.html#using-boot-devtools](https://docs.spring.io/spring-boot/docs/2.2.0.RELEASE/reference/html//using-spring-boot.html#using-boot-devtools)
- 디렉터리: `~/.config/spring-boot`
- 설정파일
    - `spring-boot-devtools.properties`
    - `spring-boot-devtools.yaml`
    - `spring-boot-devtools.yml`

### 액츄에이터(Actuator)

- Health indicator 구성 클래스가 변경됨
- JMX 비활성화 기본
    - 액츄에이터 관련한 정보는 보안상 **비활성화**
    - `spring.jmx.enabled=true` 를 통해 활성화 가능

## 스프링 부트 2.2 새로운 점

- Spring Boot 2.2.0 구성 변경기록
    - [https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.2.0-Configuration-Changelog](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.2.0-Configuration-Changelog)

### Java 13 지원

- Java 13([https://openjdk.java.net/projects/jdk/13/](https://openjdk.java.net/projects/jdk/13/))
- 8, 11 지원

### 성능향상

- 스프링 프레임워크 5.2.M1 에서 소개된 `@Configuration` 속성 `proxyBeanMethod` 을 이용하여 구동 시간과 메모리 사용량을 줄일 수 있다.
    - `@Configuration(proxyBeanMethod=false)`이라고 해당 클래스의 `@Bean` 메서드를 호출할 때 메서드로 인식

        @Configuration(proxyBeanMethod=false) // 값을 변경해보자~
        public class ProxyBeanMethodConfiguration {
        
            @Bean
            InnerClass innerClass() {
                return new InnerClass();
            }
        
            public static class InnerClass {
                public InnerClass() {
                    System.out.println("InnerClass init!");
                }
        
                public void call() {
                    System.out.println("InnerClass call!");
                }
            }
        }
        
        @Configuration
        public class AppConfiguration {
            private final ProxyBeanMethodConfiguration proxyBeanMethodConfiguration;
        
            public AppConfiguration(ProxyBeanMethodConfiguration proxyBeanMethodConfiguration) {
                this.proxyBeanMethodConfiguration = proxyBeanMethodConfiguration;
            }
        
            @Bean
            OtherInnerClass otherInnerClass() {
                return new OtherInnerClass(proxyBeanMethodConfiguration.innerClass());
            }
        
            public static class OtherInnerClass {
                public OtherInnerClass(ProxyBeanMethodConfiguration.InnerClass innerClass) {
                    innerClass.call();
                }
            }
        }
        
        // proxyBeanMethods=false 선언 후 실행시
        InnerClass init!
        InnerClass call!
        InnerClass init!
        
        // proxyBeanMethod=true(기본값) 실행시
        InnerClass init!
        InnerClass call!

    - `@SpringBootApplication` 과 `@SpringBootConfiguration` 에서도 사용가능하다.
- 개발단계에서 빌드도구를 통해 부트를 실행할 때 플래그(`-Xverify:none` 혹은 `-XX:TieredStopAtLevel=1`)로 JVM을 설정하여 실행시간을 단축할 수 있다. JDK 13 에서는 `-Xverify:none` 기능은 소멸되었다.
- 시간을 지체하는 부분들에 대한 성능개선이 있었다:
    - 많은 수의 구성속성을 바인딩하는 과정에서 시간이 소요되었다.
    - 스프링 부트에서는 JPA 엔티티를 탐색하여 `PersistenceUnit` 를 준비했으나, 하이버네이트 소유의 엔티티에 대한 탐색은 비활성화하여 속도를 개선
    - 빈이 생성되어 있을 때만 자동구성 내에서 주입하도록 재정의
    - 스프링 빈과 관련된 액츄에이터는 JMX 혹은 HTTP 종점이 활성화 되어 노출될 때 생성
    - 더이상 사용하지 않는 코덱 제거
    - 톰캣 MBean Registry 를 기본 비활성화하여 메모리 절약

### Lazy initialization

- [https://spring.io/blog/2019/03/14/lazy-initialization-in-spring-boot-2-2](https://spring.io/blog/2019/03/14/lazy-initialization-in-spring-boot-2-2)
    - [https://flyburi.com/604](https://flyburi.com/604)
- `spring.main.lazy-initialization` 사용
- 얻게되는 이득: 애플리케이션 구동속도를 높일 수 있다.
    - 스프링 애플리케이션이 구동시 스프링 빈을 탐색하고 적재하는 과정을 생략하여 속도 상승!
- `@Lazy(false)` 가 선언되었거나 `LazyInitializationExcludeFilter` 를 이용해서 예외대상 선정가능

        @Bean
        static LazyInitializationExcludeFilter integrationLazyInitExcludeFilter() {
            return LazyInitializationExcludeFilter.forBeanTypes(IntegrationFlow.class);
        }

### `@ConfigurationpProperties` 탐색

- 2.2.0 이전: `@EnableConfigurationProperties` 에 불러오거나 `@Component`를 추가해야했음
- `@SpringBootApplication` 에 `@ConfigurationPropertiesScan` 이 추가되었음
    - `@CofigurationProperties` 도 스프링 빈으로 탐색됨(≠ `@Component` 는 아님

### `@ConfigurationProperties` 생성자 바인딩

- 생성자를 기반한 속성값 연동이 가능하다.
- 클래스에 `@ConfigurationProperties` 가 선언되어 있거나 생성자에서 `@ConstructorBinding`을 선언

        @ConstructorBinding
        @ConfigurationProperties("honeymon.api")
        public class HoneymonApiProperties {
            private String rootUri;
            private String headerAuthorization;
            private Duration connectTimeout;
            private Duration readTimeout;
        
            public HoneymonApiProperties(String rootUri, String headerAuthorization, Duration connectTimeout, Duration readTimeout) {
                this.rootUri = rootUri;
                this.headerAuthorization = headerAuthorization;
                this.connectTimeout = connectTimeout;
                this.readTimeout = readTimeout;
            }
        	// getter 생략
        }

- `@DefaultValue` 와 `@DateTimeFormat` 을 생성자 인자에 선언하여 사용가능

        //application.yml
        honeymon.api:
          root-uri: http://honeymon.io/api
          connect-timeout: 10s
          read-timeout: 5s
          header-authorization: Berear 2019-01-01
          today: 2019/11/06
        
        //HoneymonApiProperties
        public HoneymonApiProperties(String rootUri, String headerAuthorization, Duration connectTimeout, Duration readTimeout, 
                                     @DefaultValue("Sample") String value, 
                                     @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate today) { // yyyy-MM-dd
            this.rootUri = rootUri;
            this.headerAuthorization = headerAuthorization;
            this.connectTimeout = connectTimeout;
            this.readTimeout = readTimeout;
            this.value = value;
            this.today = today;
        }
        
        // 오류 발생
        Caused by: java.lang.IllegalArgumentException: Parse attempt failed for value [2019/11/06]
        	at org.springframework.format.support.FormattingConversionService$ParserConverter.convert(FormattingConversionService.java:223)
        	at org.springframework.format.support.FormattingConversionService$AnnotationParserConverter.convert(FormattingConversionService.java:338)
        	at org.springframework.core.convert.support.ConversionUtils.invokeConverter(ConversionUtils.java:41)
        	... 101 more
        Caused by: java.time.format.DateTimeParseException: Text '2019/11/06' could not be parsed at index 4
        	at java.time.format.DateTimeFormatter.parseResolved0(DateTimeFormatter.java:1949)
        	at java.time.format.DateTimeFormatter.parse(DateTimeFormatter.java:1851)
        	at java.time.LocalDate.parse(LocalDate.java:400)
        	at org.springframework.format.datetime.standard.TemporalAccessorParser.parse(TemporalAccessorParser.java:69)
        	at org.springframework.format.datetime.standard.TemporalAccessorParser.parse(TemporalAccessorParser.java:46)
        	at org.springframework.format.support.FormattingConversionService$ParserConverter.convert(FormattingConversionService.java:217)
        	... 103 more

- [https://docs.spring.io/spring-boot/docs/2.2.0.RELEASE/reference/html/spring-boot-features.html#boot-features-external-config-constructor-binding](https://docs.spring.io/spring-boot/docs/2.2.0.RELEASE/reference/html/spring-boot-features.html#boot-features-external-config-constructor-binding)

### RSocket 지원

- RSocket: [http://rsocket.io/](http://rsocket.io/)
    - TCP, WebSocket 그리고 Aeron([https://github.com/real-logic/Aeron](https://github.com/real-logic/Aeron), 고성능 메시지 전송 프로토콜) 을 통해 바이트 스트림을 전송할 수 있는 바이너리 프로토콜
    - 리액티브 스트리밍
    - [https://brunch.co.kr/@springboot/271](https://brunch.co.kr/@springboot/271)
    - [https://brunch.co.kr/@springboot/153](https://brunch.co.kr/@springboot/153)

### `RestTemplateBuilder` 요청 재정의

- 이건 밑에서 자세히 설명

### 스프링 배치 데이터소스 정의

다수의 데이터소스가 있는 환경에서 스프링 배치에서 사용하는 `DataSource` 빈에 `@BatchDataSource`를 선언하여 스프링 배치에서 사용하도록 할 수 있다.

### 빌드 정보 `time` 항목 추가

- 빌드 정보를 제공하는 `[build.properties](http://build.properties)` 내에 `build.time` 속성을 제공하여 빌드 시간을 제공

### Health indicator groups 설정

다음과 같이 Health 인디케이터에 포함할 그룹을 정의할 수 있다. (고 하는데 어따 써먹는지 알수 없다)

    management.endpoint.health.group.custom.include=db

- [https://docs.spring.io/spring-boot/docs/2.2.0.RELEASE/reference/html//production-ready-features.html#health-groups](https://docs.spring.io/spring-boot/docs/2.2.0.RELEASE/reference/html//production-ready-features.html#health-groups)

### Flyway JavaMigration 으로 자동구성

- `JavaMigration` 빈을 이용해서 자동구성 가능

### `URI` 속성 추가

- `configpros` 와 `env` 엔드포인트에 URI 속성 추가됨

## Spring Boot 유용팁!

- Gradle 스크립트 작성시 큰따옴표!

        compile 'org.springframework.cloud:spring-cloud-aws:2.0.1.RELEASE' -> compile("org.springframework.cloud:spring-cloud-aws:2.0.1.RELEASE")

- Gradle 작성시 `dependencyManagement` BOM(Bill of materials) 을 잘 선택하자.

        // ex: 잘못된 경우: 스프링 부트 2.0.6 으로 고정되어버렸...
        
        dependencyManagement {
            imports {
                mavenBom "org.springframework.cloud:spring-cloud-aws:2.0.1.RELEASE"
            }
        }
        
        // ex: spring-boot-dependencies 에 영향을 끼치지 않고 spring-cloud-aws 모듈만 영향
        dependencyManagement {
            imports {
                mavenBom "org.springframework.cloud:spring-cloud-aws-dependencies:2.1.3.RELEASE"
            }
        }
        
        //// import a BOM
        //    implementation platform("org.springframework.boot:spring-boot-dependencies:1.5.8.RELEASE")

    - [https://github.com/spring-projects/spring-boot/blob/master/spring-boot-project/spring-boot-dependencies/pom.xml](https://github.com/spring-projects/spring-boot/blob/master/spring-boot-project/spring-boot-dependencies/pom.xml)
    - [https://docs.spring.io/dependency-management-plugin/docs/current/reference/html/](https://docs.spring.io/dependency-management-plugin/docs/current/reference/html/)
    - [https://gradle.org/whats-new/gradle-5/](https://gradle.org/whats-new/gradle-5/)

### Gradle 4.6+ 업그레이드시

- wrapper 태스크 오버라이드 안됨

        task wrapper(type: Wrapper) {
            gradleVersion = "5.3.1"
        }
        
        //> Cannot add task 'wrapper' as a task with that name already exists.

- Groovy DSL 변경에 따른 항목 변경

        jacocoTestReport {
            reports {
                xml.enabled false
                csv.enabled false
                html.destination "${buildDir}/reports/jacoco/html"
            }
            executionData = files("${buildDir}/jacoco/jacoco.exec")
        }
        //> Could not find method destination() for arguments [/Users/생략/build/reports/jacoco/html] on Report html of type org.gradle.api.reporting.internal.TaskGeneratedSingleDirectoryReport.
        
        jacocoTestReport {
            reports {
                xml.enabled false
                csv.enabled false
                html.setDestination(file("${buildDir}/reports/jacoco/html"))  // setDestination 사용
            }
            executionData = files("${buildDir}/jacoco/jacoco.exec")
        }

- 애노테이션을 사용하는 라이브러리에 `annotationProcessor` 선언
    - test 태스크: `testAnnotationProcessor` 사용
    - [https://docs.gradle.org/4.6/release-notes.html#convenient-declaration-of-annotation-processor-dependencies](https://docs.gradle.org/4.6/release-notes.html#convenient-declaration-of-annotation-processor-dependencies)
    - 예

            dependencies {
            		compile("org.projectlombok:lombok")
                annotationProcessor("org.projectlombok:lombok")
            		testAnnotationProcessor("org.projectlombok:lombok") // test 계층에서 사용시 다음과 같이 선언한다.
            
            		compile("com.querydsl:querydsl-jpa")
                annotationProcessor("com.querydsl:querydsl-jpa")
                compile("com.querydsl:querydsl-apt")
                annotationProcessor("com.querydsl:querydsl-apt")
            }

- Querydsl plugin 설정추가

        // 관련 구성: 변경전
        dependencies {
        		compile("com.querydsl:querydsl-jpa")
            compile("com.querydsl:querydsl-apt")
        }
        
        configure(querydslProjects) {
            apply plugin: "com.ewerk.gradle.plugins.querydsl"
        
            def querydslSrcDir = "src/main/generated"
            querydsl {
                library = "com.querydsl:querydsl-apt"
                jpa = true
                querydslSourcesDir = querydslSrcDir
            }
        
            sourceSets {
                main {
                    java {
                        srcDirs = ["src/main/java", querydslSrcDir]
                    }
                }
            }
        }
        
        // 오류발생
        > Task :honeymon-core:compileQuerydsl FAILED
        
        FAILURE: Build failed with an exception.
        
        * What went wrong:
        Execution failed for task ':honeymon-core:compileQuerydsl'.
        > Annotation processor 'com.querydsl.apt.jpa.JPAAnnotationProcessor' not found
        
        // 관련 구성: 변경후
        dependencies {
        		compile("com.querydsl:querydsl-jpa")
            annotationProcessor("com.querydsl:querydsl-jpa")
            compile("com.querydsl:querydsl-apt")
            annotationProcessor("com.querydsl:querydsl-apt")
        }
        
        configure(querydslProjects) {
            apply plugin: "com.ewerk.gradle.plugins.querydsl"
        
            def querydslSrcDir = "src/main/generated"
            querydsl {
                library = "com.querydsl:querydsl-apt"
                jpa = true
                querydslSourcesDir = querydslSrcDir
            }
        
            sourceSets {
                main {
                    java {
                        srcDirs = ["src/main/java", querydslSrcDir]
                    }
                }
            }
        
        		compileQuerydsl { // querydsl 컴파일시 사용하는 애노테이션프로세서('com.querydsl.apt.jpa.JPAAnnotationProcessor')의 경로를 querydsl 이 지정한 경로를 이용한다는 선언
                options.annotationProcessorPath = configurations.querydsl
            }
        }

### `RestTemplateBuilder` 활용법

- `setReadTimeout(long readTimeout)`, `setConnectTimeout(long connectTimeout)` 메서드 제거됨
- `setReadTimeout(Duration readTimeout)`, `setConnectTimeout(Duration connectTimeout)` 으로 대체됨
- 밀리세컨드(1/1000초) 단위로 설정값 변경

        //이전
        honeymon.api:
          root-uri: http://honeymon.io/api
          header-authorization: Berear 2019-11-01
          read-timeout: 5_000
          connect-timeout: 10_000
        
        // 이후
        honeymon.api:
          root-uri: http://honeymon.io/api
          header-authorization: Berear 2019-11-01
          read-timeout: 5s
          connect-timeout: 10s // java.time.Duration 으로 변환됨

- `HoneymonApiProperties`

        @ConfigurationProperties("honeymon.api")
        public class HoneymonApiProperties {
          private String rootUri;
          private String headerAuthorization;
        	private Duration readTimeout;
          private Duration connectTimeout;
        
        	// getter/setter
        }

- RestTemplateBuilder 선언방식 변화
    - 2.2.0 이전

            public HoneymonApiClient(HoneymonApiProperties properties) {
                this.properties = properties;
                this.restTemplate = new RestTemplateBuilder()
                        .rootUri(properties.getRootUri())
                        .additionalInterceptors(new HoneymonApiHttpInterceptor(properties.getHeaderAuthorization()))
                        .setReadTimeout(properties.getReadTimeout())
                        .setConnectTimeout(properties.getConnectTimeout())
                        .build();
            }
            
            // RestTemplate 요청시 Authorization 값을 추가하기 위해 ClientHttpRequestInterceptor 구현체를 추가
            public static class HoneymonApiHttpInterceptor implements ClientHttpRequestInterceptor {
                private final String authorizationToken;
            
                public HoneymonApiHttpInterceptor(String authorizationToken) {
                    this.authorizationToken = authorizationToken;
                }
            
                @Override
                public ClientHttpResponse intercept(HttpRequest request, byte[] body, ClientHttpRequestExecution execution) throws IOException {
                    HttpHeaders headers = request.getHeaders();
                    headers.set(HttpHeaders.AUTHORIZATION, authorizationToken);
                    
                    return execution.execute(request, body);
                }
            }

    - 2.2.0 이후(Header 를 변경하기 위해 ClientHttpRequestInterceptor 를 구현할 필요없다.)

            public HoneymonApiClient(HoneymonApiProperties properties) {
                this.properties = properties;
                this.restTemplate = new RestTemplateBuilder()
                        .rootUri(properties.getRootUri())
                        .defaultHeader(HttpHeaders.AUTHORIZATION, properties.getHeaderAuthorization())
                        .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                        .setReadTimeout(properties.getReadTimeout())
                        .setConnectTimeout(properties.getConnectTimeout())
                        .build();
            }

- `org.springframework.beans.factory.support.BeanDefinitionOverrideException` 이 발생하는 경우

        spring.main.allow-bean-definition-overriding: true

    - 스프링 부트 2.1([https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.1-Release-Notes](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.1-Release-Notes)) 에 추가된 기능으로 동일한 유형(타입)의 스프링 빈이 중복생성되는 것을 강제차단한다. 위의 설정읠 통해서 이 기능을 비활성화할 수 있다.
    - 스프링 부트 테스트(`@SpringBootTest`)를 실행할 때 `@TestConfiguration` 에서 동일한 유형을 가진 스프링 빈을 선언할 때 발생할 수 있는데 이때는
        - `src/test/resources/application.yml` 내에 `spring.main.allow-bean-definition-overriding: true` 를 설정하거나

## 참고

- [https://github.com/spring-projects/spring-framework/wiki/Upgrading-to-Spring-Framework-5.x](https://github.com/spring-projects/spring-framework/wiki/Upgrading-to-Spring-Framework-5.x)
    - [https://github.com/spring-projects/spring-framework/issues/21697](https://github.com/spring-projects/spring-framework/issues/21697)

    - [https://docs.spring.io/spring-framework/docs/current/javadoc-api/deprecated-list.html](https://docs.spring.io/spring-framework/docs/current/javadoc-api/deprecated-list.html)
    - [https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/core/annotation/MergedAnnotations.html](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/core/annotation/MergedAnnotations.html)
    - [https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/core/annotation/MergedAnnotation.html](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/core/annotation/MergedAnnotation.html)
- [https://github.com/spring-projects/spring-boot/releases](https://github.com/spring-projects/spring-boot/releases)
- 파이어버드(Firebird, [https://firebirdsql.org/en/start/](https://firebirdsql.org/en/start/)): DBMS
    - Jaybird(JDBC Driver)
- Spring Security OAuth: [https://projects.spring.io/spring-security-oauth/docs/oauth2.html](https://projects.spring.io/spring-security-oauth/docs/oauth2.html)
- [https://docs.gradle.org/4.6/release-notes.html#convenient-declaration-of-annotation-processor-dependencies](https://docs.gradle.org/4.6/release-notes.html#convenient-declaration-of-annotation-processor-dependencies)
- [http://honeymon.io/tech/2019/06/17/spring-boot-2-start.html](http://honeymon.io/tech/2019/06/17/spring-boot-2-start.html)
- [https://spring.io/blog/2019/10/16/spring-boot-2-2-0](https://spring.io/blog/2019/10/16/spring-boot-2-2-0)
- [https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.1-Release-Notes](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.1-Release-Notes)
- [https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.2-Release-Notes](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.2-Release-Notes)
- [https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/)
- [http://honeymon.io/tech/2019/10/23/spring-deprecated-media-type.html](http://honeymon.io/tech/2019/10/23/spring-deprecated-media-type.html)