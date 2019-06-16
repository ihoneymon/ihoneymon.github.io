---
title: "[spring-boot] 스프링 부트 2.x 준비하는 개발자를 위한 안내서"
layout: post
categories: tech
tags: [tech, java, spring-boot]
date: 2019-06-16 22:00:00
---

> 스프링 부트 참고서는 ['부트 스프링 부트!'](http://www.yes24.com/Product/Goods/62112463)
> ![Boot Spring Boot! 한 권으로 정리하는 스프링 부트 A to Z ](http://image.yes24.com/Goods/62112463/800x0)

오는 8월 1일, 스프링 부트 1.5.X 지원이 중단된다([Spring Boot 1.x EOL Aug
1st
2019](https://spring.io/blog/2018/07/30/spring-boot-1-x-eol-aug-1st-2019)).

> 이 중단소식을 접하고 스프링 부트 2.X 시대 여행을 준비하는 개발자를
> 위한 안내서를 작성해봐야겠다는 생각을 했다.

> **Note**
>
> 현재 관리하고 있는 프로젝트도 스프링 부트 2.2.0 이 출시(스프링
> 프레임워크 5.2.0.RELEASE가 출시와 동시에 출시될 것이다)하면 빠르게
> 업그레이드할 수 있도록 2.1.5 로 업그레이드했다. 이 과정에서 겪은
> 시행착오들과 문제들을 정리한다.

준비사항
========

스프링 부트 2.X 여행을 준비하자.

-   스프링 부트 ['시스템
    요구사항'](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#getting-started-system-requirements)을
    확인하고 준비하자.

-   스프링 부트 ['스프링 부트 2.0 이주 안내서(Migration
    Guide)'](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.0-Migration-Guide)를
    살펴보자.

-   사용하고 있는 애플리케이션 속성이 변경되었는지 확인하자.

-   ['액츄에이터 HTTP 종단점 경로
    변경'](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.0-Migration-Guide#base-path):
    `/{acutuator-end-point}` → `/actuator/{actuator-end-ponint}`

    -   HTTP 종단점 중 `/health`와 `/info` 를 제외한 모든 종단점의
        노출이 비활성화되었다.

-   스프링 부트 핫스와핑(Hot swapping) 프로젝트 Spring Loaded 프로젝트가
    이관되면서 기능지원이 사라졌다.

JDK 8 이상
----------

스프링 부트 1.5.X 까지는 JDK 6과 7을 지원했다. 그러나 스프링 부트
2.0(스프링 프레임워크 5.0 적용) 부터 JDK 8 이상 사용이 강제되었다. JDK 8
에서 지원하기 시작한 '인터페이스 디폴트 메서드'(Interface default
method,
<https://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html>)를
스프링 프레임워크 5.0 에서 적극 사용했다. 스프링 WebMVC 에서 웹구성을
사용자정의(Custom) 위한 목적으로 사용하는
[`WebMvcConfigure`](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/servlet/config/annotation/WebMvcConfigurer.html)와
[`WebMvcConfigurerAdapter`](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/servlet/config/annotation/WebMvcConfigurerAdapter.html)에서
그 변화를 살짝 엿볼 수 있다.

> **Note**
>
> 디폴트 메서드 기능이 지원되기 전에는 인터페이스를
> 구현(Implmentaion)하려고 하면 구현클래스에서 모든 메서드를
> 오버라이드(Override) 해야했다. 스프링 개발팀에서는 이런 불편을
> 해소하려는 목적으로 `WebMvcConfigure` 인터페이스의
> 중간구현체([어뎁터](https://ko.wikipedia.org/wiki/어댑터_패턴))인
> `WebMvcConfigurerAdapter`를 추가했다. 웹구성 중 특정 기능만
> 사용자정의하려는 개발자는 `WebMvcConfigure` 인터페이스 대신
> `WebMvcConfigurerAdapter`를 확장(extends)하여 특정 메서드만
> 사용자정의하여 사용했다.
>
> 그러나 JDK 8을 적극 반영한 스프링 프레임워크 5.0 부터는
> [`WebMvcConfigure`
> 인터페이스](https://github.com/spring-projects/spring-framework/blob/master/spring-webmvc/src/main/java/org/springframework/web/servlet/config/annotation/WebMvcConfigurer.java)에
> 디폴트 메서드가 적극사용되었다. 이 인터페이스를 구현해도 그 안에 있는
> 메서드를 모두 구현할 부담이 없어졌고 `WebMvcConfigurerAdapter`를
> 사용할 이유도 사라졌다.
>
> 내 코드에도 사용해봄직하다(아마도…​).

> **Note**
>
> JDK 11을 지원하지 않는 그레이들 플러그인이 있을 수 있다. 그 때는 내가
> 직접 만들어야할지도…​

빌드도구(Build tool)
--------------------

빌드도구는 프로젝트에서 사용하는 라이브러리 의존성을 관리하고
애플리케이션을 배포가능한 상태로 포장(Packaging or Archiving, 패키징
혹은 아카이빙)하는 과정을 담당한다. 이 과정에서 빌드 테스트나 넥서스
등의 레파지토리에 배포하는 등에 대한 설명은 생략한다.

-   [그레이들(Gradle)](https://gradle.org/) 4 이상(개인적으로는 5이상
    추천, 현재 5.4.1)

-   [메이븐(Maven)](https://maven.apache.org/) 3.2 이상

그레이들은 하위호환성은 무시하면서 빠르게 업그레이드를 하고 있는
빌드도구다('따라올테면 따라와 봐' 인가…​). 그래서 그레이들 버전을
변경하면 손봐야할 곳이 많이 생긴다. 지원이 중단된 플러그인을 대체할
새로운 플러그인을 찾아야할 수도 있고, 사용문법이나 동작이 달라져서
이해하는데 상당한 시간을 들여야 한다.

### 그레이들 플러그인 설정

스프링 부트는 빌드에 사용하는 바이너리 플러그인은
[`buildscripts`](https://docs.gradle.org/current/userguide/plugins.html#sec:old_plugin_application)와
[`plugins`](https://docs.gradle.org/current/userguide/plugins.html#sec:plugins_block)
두 가지 방식으로 선언이 가능하다.

#### `buildscripts`방식

빌드스크립트 방식은 그레이들에서 바이너리 플러그인을 정의하는 고전적인
방식이다. 빌드스크립트(`build.gradle`) 파일 안에 빌드 스크립트를
정의하는 어색함을 자아내는 부분이다.

**`build.gradle`.**

    buildscript {
        def gulpPluginVersion = "0.13"
        def springBootVer = "2.0.6.RELEASE"
        def asciidoctorVersion = '1.5.9.2'

        repositories {
            maven { url "https://plugins.gradle.org/m2/" }
        }

        dependencies {
            classpath "org.springframework.boot:spring-boot-gradle-plugin:$springBootVer"
            classpath "gradle.plugin.com.ewerk.gradle.plugins:querydsl-plugin:1.0.10"
            classpath "gradle.plugin.com.boxfuse.client:gradle-plugin-publishing:5.1.4"
            classpath "com.moowork.gradle:gradle-node-plugin:$gulpPluginVersion"
            classpath "com.moowork.gradle:gradle-gulp-plugin:$gulpPluginVersion"
            classpath "org.sonarsource.scanner.gradle:sonarqube-gradle-plugin:2.7"
            classpath "org.mariadb.jdbc:mariadb-java-client:2.2.3"
            classpath("org.asciidoctor:asciidoctor-gradle-plugin:${asciidoctorVersion}")
        }
    }

#### `plugins` 방식

위에서 언급한 빌드스크립트(`buildscripts`) 플러그인 선언부를 이해할 수
있는 형태로 개선한 것으로 그레이들 4.6 부터 적용되었다. 작성문법자체는
깔끔하다. 플러그인 클래스를 좀 더 재사용하기 좋도록 최적화를 수행하고
다른 버전의 플러그인을 각각 지정하거나 전역으로 적용할지 여부 등을
선택할 수 있다.

**`build.gradle`.**

    plugins {
        id "org.springframework.boot" version "2.1.5.RELEASE" 
        id "org.sonarqube" version "2.7.1"
        id "io.freefair.lombok" version "3.6.6" apply false 
        id "com.ewerk.gradle.plugins.querydsl" version "1.0.10" apply false
        id "org.asciidoctor.convert" version "1.5.3" apply false
        id "com.github.node-gradle.node" version "1.4.0" apply false
        id "com.github.node-gradle.gulp" version "1.4.0" apply false
        id "org.flywaydb.flyway" version "5.2.4" apply false
    }

-   프로젝트 전체에서 사용하는 플러그인

-   `apply false` 선언을 하면 프로젝트에서 사용하려면
    `apply plugin: "io.freefair.lombok"` 과 같이 사용할 플러그인을
    명시적으로 선언해야 한다.

> **Tip**
>
> 그레이들 플러그인 포탈외에 별도의 플러그인 포탈을 사용하려는 경우
> `settings.gradle` 에서 다음과 같이 선언해야 한다.
>
> -   [Custom plugin repositories -
>     Gradle](https://docs.gradle.org/current/userguide/plugins.html#sec:custom_plugin_repositories)
>
> **`settings.gradle`.**
>
>     pluginManagement {
>         repositories {
>             maven {
>                 url '../maven-repo'
>             }
>             gradlePluginPortal()
>             ivy {
>                 url '../ivy-repo'
>             }
>         }
>     }

> **Important**
>
> 스프링 부트가 제공하는 빌드도구 플러그인은 별도의 참고문서가
> 존재할만큼 살펴봐야할 내용이 많다.
>
> -   [Spring Boot Maven plugin Reference
>     Documentation](https://docs.spring.io/spring-boot/docs/current/maven-plugin/plugin-info.html)
>
> -   [Spring Boot Gradle plugin Reference
>     Documentation](https://docs.spring.io/spring-boot/docs/current/gradle-plugin/reference/html/)
>
### 그레이들 5.0 애너테이션 처리기

['그레이들 5.0'](https://gradle.org/whats-new/gradle-5/)부터 [애너테이션
프로세서 처리방식이
개선](https://docs.gradle.org/5.0/userguide/java_plugin.html#sec:incremental_annotation_processing)되었다([실제로는
4.6부터 모습을
드러냈…​](https://docs.gradle.org/4.6/release-notes.html)).

그래서 애너테이션을 기반으로 동작하는 롬복을 비롯한 JPA를 이용하는
Querydsl의 경우 다음과 같이 `annotationProcessor` 를 선언해야한다.

    dependencies {
        compile("org.projectlombok:lombok")
        annotationProcessor("org.projectlombok:lombok")
        testAnnotationProcessor("org.projectlombok:lombok")
        integrationTestAnnotationProcessor("org.projectlombok:lombok") 

        compile("com.querydsl:querydsl-jpa")
        annotationProcessor("com.querydsl:querydsl-jpa")
    }

-   통합테스트(Integration Test)에서 사용하는 경우도 컴파일을 위해
    다음과 같이 선언해야 했다(참고:
    <https://docs.gradle.org/5.3.1/userguide/java_plugin.html#java_source_set_configurations>).

### 스프링 부트 그레이들 플러그인(spring-boot-gradle-plugin)

스프링 부트는
[`spring-boot-dependencies`](https://github.com/spring-projects/spring-boot/tree/master/spring-boot-project/spring-boot-dependencies)를
의존성관리를 위한 BOM(Bill of Material, 라이브러리 버전을 명시한
명세서)으로 사용하고 있다. 그 덕분에 스프링 부트에서 지원하는 의존성
라이브러리의 경우는 버전을 명시하지 않아도 BOM에 등록되어있는 버전으로
일괄 관리된다. 스프링 부트를 사용한다면, 스프링 부트가 지원하지 않는
라이브러리를 제외하고는, **스프링 부트 BOM을 따르기를 권장**한다. 스프링
부트 배포에 맞춰 관련된 라이브러리에 대한 기본적인 작동 및 검증을
마쳤다고 믿고 넘어가자.

#### 실행가능한 JAR(혹은 WAR) 재포장(Repackaging, 리패키징)

스프링 부트 2.0 이 되면서 스프링 부트 그레이들 플러그인에 일부 변화가
있었다. 그 중에 하나가 이전에는 `bootRepackage` 태스크가 `bootJar`(Jar
확장) 와 `bootWar`(War 확장)로 분리되었다. 그레이들 멀티모듈 프로젝트를
사용하는 경우 의존성을 가지는 상위모듈의 경우에는 **실행가능한 JAR(혹은
WAR)**로 포장할 필요가 없다. 이 경우에는 다음과 같이 선언해야 상위모듈이
재포장되는 것을 방지한다:

    plugins {
        id "org.springframework.boot" version "2.1.5.RELEASE"
    }

    project(":core") {
        bootJar.enabled = false 
        jar.enabled = true
    }

    project(":api-application") {   
        implementation(project(":core"))
    }

-   '실행가능한 JAR' 재포장 비활성화

-   스프링 부트 프로젝트인 경우 '실행가능한 JAR' 재포장 활성화가 기본

#### 스프링 부트 지원 라이브러리 버전 변경

`hibernate-core` 라이브러리 `5.2.14` ~ `5.3.X` 버전 사이에서 `@MapsId`를
사용하는 `@OneToOne` 엔티티 사이에서 다음과 같은
`org.hibernate.id.IdentifierGenerationException: attempted to assign id from null one-to-one property`예외가
발생할 수 있다.

    Caused by: org.hibernate.id.IdentifierGenerationException: attempted to assign id from null one-to-one property [io.honeymon.Honeymon.bankAccount]
        at org.hibernate.id.ForeignGenerator.generate(ForeignGenerator.java:90)
        at org.hibernate.event.internal.AbstractSaveEventListener.saveWithGeneratedId(AbstractSaveEventListener.java:105)
        at org.hibernate.jpa.event.internal.core.JpaMergeEventListener.saveWithGeneratedId(JpaMergeEventListener.java:56)
        at org.hibernate.event.internal.DefaultMergeEventListener.saveTransientEntity(DefaultMergeEventListener.java:255)
        at org.hibernate.event.internal.DefaultMergeEventListener.entityIsTransient(DefaultMergeEventListener.java:235)
        at org.hibernate.event.internal.DefaultMergeEventListener.onMerge(DefaultMergeEventListener.java:173)
        at org.hibernate.internal.SessionImpl.fireMerge(SessionImpl.java:906)
        at org.hibernate.internal.SessionImpl.merge(SessionImpl.java:876)
        at org.hibernate.engine.spi.CascadingActions$6.cascade(CascadingActions.java:261)
        at org.hibernate.engine.internal.Cascade.cascadeToOne(Cascade.java:467)
        at org.hibernate.engine.internal.Cascade.cascadeAssociation(Cascade.java:392)
        at org.hibernate.engine.internal.Cascade.cascadeProperty(Cascade.java:193)
        at org.hibernate.engine.internal.Cascade.cascade(Cascade.java:126)

이와 관련한 하이버네이트 이슈가 있다.

-   <https://jira.spring.io/browse/DATAJPA-1304>

-   <https://hibernate.atlassian.net/browse/HHH-12436>

-   <https://hibernate.atlassian.net/browse/HHH-12842>

이 이슈는 hibernate-core 5.4.X.Final 버전에서 해소되었는데 스프링 부트
2.1.5.RELEASE 까지는
`` 5.3.10.Final`을 사용한다.  ``build.gradle` 에서 다음과 선언하여 `hibernate-core\`\`
버전을 변경하면 문제를 피해갈 수 있다.

**`build.gradle`.**

    apply plugin: "io.spring.dependency-management" 

    ext["hibernate.version"] = "5.4.2.Final" 

-   스프링 부트 BOM에서 독립적으로 버전을 관리하려면 선언해줘야 한다.

-   [`spring-boot-dependencies/pom.xml`](https://github.com/spring-projects/spring-boot/blob/master/spring-boot-project/spring-boot-dependencies/pom.xml)에
    선언되어 있는 `hibernate.version`을 덮어쓰기 한다(`5.3.10.Final` →
    `5.4.2.Final`).

### 롬복(Lombok) 플러그인

자바를 사용하면 거의 필수적으로 사용하는 롬복도 그레이들 플러그인이
존재한다. 롬복 프로젝트에서도 롬복 플러그인을 사용하는 것을 권장한다.

> **Note**
>
> There is a plugin for gradle that we recommend you use; it makes
> deployment a breeze, works around shortcomings of gradle prior to
> v2.12, and makes it easy to do additional tasks, such as running the
> lombok eclipse installer or delomboking. The plugin is open source.
> Read more [about the gradle-lombok
> plugin](https://plugins.gradle.org/plugin/io.freefair.lombok).
>
> -   <https://docs.freefair.io/gradle-plugins/current/reference/#_lombok_plugins>
>
    apply plugin: "io.freefair.lombok" 

    generateLombokConfig.enabled = false 

-   `io.freefair.lombok` 플러그인을 사용하면 각 모듈마다 `lombok.config`
    파일을 생성한다.

-   `lombok.config` 파일 생성을 비활성화한다.

> **Tip**
>
> 다음과 같은 방식으로 롬복을 적용할 프로젝트를 지정하는 것도 가능하다.
>
>     plugins {
>         // 생략
>         id "io.freefair.lombok" version "3.6.6" apply false
>     }
>
>     subprojects {
>         if (!name.startsWith("{target-module-name}")) {
>             apply plugin: "io.freefair.lombok"
>
>             generateLombokConfig.enabled = false
>         }
>     // 생략
>     }

변경사항
========

-   스프링 부트 2.0은 스프링 5 프레임워크 출시와 맞물려 있다. 스프링 5
    프레임워크가 출시하면서 연관된 프로젝트의 버전업 및 일괄변경이
    있었다.

> **Note**
>
> 스프링 부트 2.2.0은 스프링 5.2 프레임워크가 출시되는 시점에 맞춰서
> 출시될 것이다.
>
> -   <https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.2-Release-Notes>
>
스프링 부트
-----------

### 2.0.0.RELEASE

-   내장 JDBC 변경: `tomcat-jdbc` → `hikariCP`

    > **Note**
    >
    > javax.sql.DataSource 를 참조하여 처리하는 과정에서는 큰 문제가
    > 없으나 org.apache.tomcat.jdbc.pool.DataSource 를 참조하는 경우에는
    > tomcat-jdbc 의존성 추가 필요함

    -   hikariCP 의존성 제거: `spring-boot-starter-jdbc` 선언되어 있음 →
        스프링 부트에 버전관리 이관

    -   tomcat-jdbc 의존성 추가

-   `DataSourceBuilder` 패키지 변경:
    `org.springframework.boot.autoconfigure.jdbc.DataSourceBuilder` →
    `org.springframework.boot.jdbc.DataSourceBuilder`

-   애플리케이션 속성키 변경 여부 확인:
    <https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.0-Migration-Guide>

-   `SpringBootServletInitializer` 패키지 변경:
    `org.springframework.boot.web.support.SpringBootServletInitializer`
    →
    `` org.springframework.boot.web.servlet.support.SpringBootServletInitializer` ``

-   `AsyncRestTemplate` → `WebClient` 로 변경됨

### 2.1.0.RELEASE

#### Groovy 의존성관리 변경

**스프링 부트 2.1.0** 부터 groovy 버전이 2.4 →
2.5(<http://groovy-lang.org/releasenotes/groovy-2.5.html>)로 변경되었다.
이 과정에서 그루비 자체의 groovy-all 에 대한 정책도 변경되었다.

> **Note**
>
> 그루비 2.5 가 되면서 코어 groovy jar 와 여러 개 "모듈" jar로
> 구성되었다. 그루비의 모듈은 자바 9 이상의 모듈과는 다르다.
>
> 모듈 구성이 변경되면서 groovy-all 이라는 편의는 제공하지 않지만 동등한
> 구성요소를 가져오는 all pom은 제공한다.

테스트 프레임워크 스폭(Spock)를 사용하기 위해 groovy-all 을
사용했었다면, 스프링 부트에서는 다음과 같이 모듈을 변경해야 한다:

**2.1.0.RELEASE 이전.**

    testCompile('org.codehaus.groovy:groovy-all')
    testCompile('org.spockframework:spock-core:1.1-groovy-2.4')
    testCompile('org.spockframework:spock-spring:1.1-groovy-2.4')

**2.1.0.RELEASE 이후 - groovy-all 버전 명시.**

    testCompile('org.codehaus.groovy:groovy-all:2.5.7')
    testCompile('org.spockframework:spock-core:1.1-groovy-2.4')
    testCompile('org.spockframework:spock-spring:1.1-groovy-2.4')

스프링 부트 2.1.0 이후로 groovy-all에 대한 버전을 명시하지 않으면 다음과
같은 오류를 접하게 될 것이다:

    FAILURE: Build failed with an exception.

    * What went wrong:
    Could not resolve all files for configuration ':boot-spring-boot:compileClasspath'.
    > Could not find org.codehaus.groovy:groovy-all:. 

-   스프링 부트 2.1.0 부터는 `groovy-all` 버전을 관리하지 않는다.
    `groovy-all` 버전을 명시하지 않으면 위 메시지가 출력된다.

**2.1.0.RELEASE 이상.**

    testCompile('org.codehaus.groovy:groovy')   
    testCompile('org.codehaus.groovy:groovy-test') 
    testCompile('org.spockframework:spock-core:1.2-groovy-2.5')
    testCompile('org.spockframework:spock-spring:1.2-groovy-2.5')

-   `groovy-all` 대신 `groovy` 와 `groovy-test` 를 함께 선언하면 된다.

#### `RestTemplateBuilder` `connectTimeout`, `readTimeout` 타입변경

밀리세컨드(millisecond) 단위로 설정했던 연결시간초과(connectTimeout)과
읽기시간초과(readTimeout) 단위가 int 에서 Duration 으로 변경될 것이다.

**기존.**

    return new RestTemplateBuilder()
            .additionalMessageConverters(getMappingJackson2HttpMessageConverter())
            .interceptors(new RequestInterceptor(properties.getApiKey()))
            .rootUri(properties.getRootUri())
            .setConnectTimeout(10_000)
            .setReadTimeout(5_000)
            .build();

**변경.**

    return new RestTemplateBuilder()
            .additionalMessageConverters(getMappingJackson2HttpMessageConverter())
            .interceptors(new RequestInterceptor(properties.getApiKey()))
            .rootUri(properties.getRootUri())
            .setConnectTimeout(Duration.ofMillis(10_000))
            .setReadTimeout(Duration.ofMillis(5_000))
            .build();

위와 같이 Duration.ofMillis() 메서드를 이용하여 변환하면 된다.

### 2.1.5.RELEASE

#### h2database lock 발생: DBPool 무한대기상태

-   실행환경

    -   Spring Boot 2.1.5.RELEASE + spring-boot-devtools 사용

    -   h2database 1.4.199

h2database 를 인메모리(in-memory) 형태로 테스트할 때
`` spring-boot-devtools`를 사용하는 경우 `NonEmbeddedInMemoryDatabaseShutdownExecutor.destroy() ``
처리 과정에서 DBPool이 종료되지 않고 대기되는 상태를 유지한다.

테스트 종료 후 애플리케이션이 정리되면서 스프링 빈을 비활성화 하는
과정에서 `spring-dev-tools` 에 있는
`DevToolsDataSourceAutoConfiguration` 내부 클래스
`` NonEmbeddedInMemoryDatabaseShutdownExecutor.destroy()` `` 메서드가
`h2database TransactionCommand.update("SHUTDOWN")` 를 호출하다가
차단되면서 무한대기 상태에 빠진다. 로그를 봤을 때는 종료(SHUTDOWN)하려고
했다가 h2.engine.session 이 잠금상태여서 튕겨버린 듯 하다. 이걸 피할 수
있는 방법은

-   h2database 1.4.197 사용

-   h2database.1.4.199 사용시

    -   spring.datasource.hikari.jdbc-url 에 MV\_STORE=FALSE 값을 주면
        종료가 된다.

    -   spring-boot-devtools를 제대로 설정한다.

        -   기존

        -   변경(참고:
            <https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#using-boot-devtools>)

            **`build.gradle`.**

                configurations {
                    developmentOnly
                    runtimeClasspath {
                        extendsFrom developmentOnly
                    }
                }

                developmentOnly("org.springframework.boot:spring-boot-devtools")

### 2.2.0.RELEASE

현재 마일스톤 4까지 출시된 상태이며 스프링 프레임워크 5.2.0.RELEASE
출시에 맞춰서 출시될 것이다.

스프링 데이터(Spring Data)
--------------------------

스프링 데이터 프로젝트는 하위에 많은 모듈이 있으며, 각 모듈의 출시일이
다른 이유로 각 모듈은 서로 다른 메이저 및 마이너 버전을 가지고 있다.
호환가능한 버전을 찾을 때는 Spring Data Release Train BOM을 살펴보기
바란다.

### Spring Data Common

-   `PageRequest` 생성자 Deprecated

        @Deprecated
        public PageRequest(int page, int size) {
           this(page, size, Sort.unsorted());
        }

        @Deprecated
        public PageRequest(int page, int size, Direction direction, String... properties) {
           this(page, size, Sort.by(direction, properties));
        }

        @Deprecated
        public PageRequest(int page, int size, Sort sort) {
           super(page, size);
           this.sort = sort;
        }

\*`PageRequest.of(…​)` 사용

\+

    public static PageRequest of(int page, int size) {
       return of(page, size, Sort.unsorted());
    }

    public static PageRequest of(int page, int size, Sort sort) {
       return new PageRequest(page, size, sort);
    }

    public static PageRequest of(int page, int size, Direction direction, String... properties) {
       return of(page, size, Sort.by(direction, properties));
    }

-   `CrudRepository` 변경

    -   `E findOne(ID id)` → `Optional<E> findById(ID id)`

    -   `List<E> save(Iterable<E> entities)` →
        `List<E> saveAll(Iterable<E> entities)`

    -   `void delete(Iterable<? extends T> entities)` →
        `void deleteAll(Iterable<? extends T> entities)`

    -   참고: <https://jira.spring.io/browse/DATACMNS-944>

### Spring Data JPA

-   ID 생성방식 변경: `spring.jpa.hibernate.id.new_generator_mappings`
    속성값 변경: `false` → `true`

    > **Note**
    >
    > 기존 생성방식을 유지하기 위해서는 해당값을 false 로 명시적 선언
    >
    > -   <http://bit.ly/2C5yD22>
    >
    > 스프링 부트 1.5는 `spring.jpa.hibernate.id.new_generator_mappings`
    > 가 'FALSE’이기 때문에 하이버네이트 자동 키 생성 전략이 Native
    > Generator가 되어 방언(`MySQL5Dialect`)에 따라 'auto\_increment’가
    > 된 것이며,
    >
    > 스프링 부트 2.0에서는 'TRUE' 이기 때문에 SequenceStyleGenerator를
    > 사용하게 되고 MySQL이 Sequence를 지원하지 않기 때문에 Table
    > Generator가 된 것이다.

-   클래스명 변경: `QueryDslRepositorySupport` →
    `QuerydslRepositorySupport`

    > **Note**
    >
    > 이거 변경하는 게 은근히 귀찮다.

-   2.1.0 - `JpaProperties` 내에서 `HibernateProperties` 분리됨

        @ConfigurationProperties("spring.jpa.hibernate")
        public class HibernateProperties {
            //
        }

#### Hibernate

`@MapsId` 를 사용하는 부분에서
`org.hibernate.id.IdentifierGenerationException: attempted to assign id from null one-to-one property`
라는 예외가 발생할 수 있습니다.

-   관련 이슈: <https://hibernate.atlassian.net/browse/HHH-12436>

-   Hibernate 5.4.0.Final 패치

-   스프링 부트 2.0.0 ~ 2.1.5 을 사용하는 경우 발생 → 스프링 부트
    2.2.0 - hibernate-core:5.4.2.Final 사용

    **`build.gradle`.**

        apply plugin: "io.spring.dependency-management"

        ext["hibernate.version"] = "5.4.2.Final"

정리
====

-   스프링 부트를 사용한다면 라이브러리 의존성은 스프링 부트 출시버전에
    맞춰 함께 변경할 수 있도록 가급적 사용자재정의하는 것을 피하도록
    하자.

    -   스프링 부트 출시버전에서 지원하는 의존성
        버전(<https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#appendix-dependency-versions>)을
        확인한다.

-   스프링 부트 릴리즈
    노트(<https://github.com/spring-projects/spring-boot/wiki>)를
    정독한다.

    -   스프링 부트는 스프링 프레임워크의 영향을 많이 받는다. 스프링
        프레임워크 릴리즈 노트도 함께 살펴보는 것이 좋다.

    -   스프링 부트는 꾸준하게 리팩토링이 일어나며 ['공통 애플리케이션
        속성(Common application
        properties)'](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#common-application-properties)
        변경도 자주 일어난다. 출시때마다 자신이 사용하고 있는 '공통
        애플리케이션 속성' 키와 값이 변경되지 않았는지 확인한다.

-   애플리케이션 구성속성은 `@ConfigurationProperties` 를 이용한
    외부구성(External Configuration)으로 분리하고 하드코딩을 피한다.

참고
====

-   [Spring Boot 1.x EOL Aug 1st
    2019](https://spring.io/blog/2018/07/30/spring-boot-1-x-eol-aug-1st-2019)

-   [Spring Boot Reference
    Documentation](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/)

-   [Spring Boot Maven plugin Reference
    Documentation](https://docs.spring.io/spring-boot/docs/current/maven-plugin/plugin-info.html)

-   [Spring Boot Gradle plugin Reference
    Documentation](https://docs.spring.io/spring-boot/docs/current/gradle-plugin/reference/html/)

    -   [스프링 부트 2.0 이주 안내서(Migration
        Guide)](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.0-Migration-Guide)

-   [Gradle User
    Guide](https://docs.gradle.org/current/userguide/userguide.html)

    -   [Using Gradle Plugins -
        Gradle](https://docs.gradle.org/current/userguide/plugins.html)

    -   [The Java Plugin - Gradle Gradle Reference
        Documentation](https://docs.gradle.org/5.3.1/userguide/java_plugin.html#java_source_set_configurations)

    -   [Gradle plugin
        Reference](https://docs.gradle.org/current/userguide/plugin_reference.html#header)

    -   [Gradle plugin: `io.freefair.lombok` Reference
        Documentation](https://docs.freefair.io/gradle-plugins/current/reference/#_lombok_plugins)

-   [Configuration system -
    lombok](https://projectlombok.org/features/configuration)

-   [Spring Data JPA - Reference
    Documentation](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/)

-   [Querydsl plugin -
    Gradle](https://plugins.gradle.org/plugin/com.ewerk.gradle.plugins.querydsl)

- ['Boot Spring Boot! 한 권으로 정리하는 스프링 부트 A to Z ' - Wiki](https://github.com/ihoneymon/boot-spring-boot/wiki/스프링-부트-2.x-여행을-준비하는-개발자를-위한-안내서)