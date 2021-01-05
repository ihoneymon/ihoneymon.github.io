---
title: "[spring-boot] Visual Studio Code 에서 스프링 부트 프로젝트 개발하기"
layout: post
category: [tech]
tags: [tech, spring-boot]
date: 2021-01-06
---

회사에서는 입사자에게 개발기기로 맥북과 인텔리제이를 제공한다. 개인노트북에서는 개인 라이센스로 인텔리제이를 구매하여 사용하고 있다. 간혹 세미나나 스터디 발표를 하다보면 인텔리제이를 사용하지 않는 사용자도 제법 많다. **피보탈**(Pivotal)에서 제공하는 **STS**(Spring Tool Suite, [https://spring.io/tools](https://spring.io/tools))를 사용하는 이도 있다.

개발자 중에는 **자기 손에 익은 개발도구**(ex: Eclipse, Atom, VSCode)에서 **통합개발환경**(IDE, Integration Development Environment)이 제공됐으면 하는 이도 있다.

- 통합개발환경: 코딩, 디버깅, 컴파일, 배포 등 프로그램 개발과 관련된 전반적인 영역을 담당한다. 우리가 사용하는 인텔리제이, 이클립스, VSCode 등이 포함된다.

피보탈은 VSCode 에서 스프링 부트를 기반한 애플리케이션을 개발할 수 있는 확장팩을 제공한다. 

확장팩 몇 가지를 설치하고나면 문서편집 목적으로 사용하던 편집기였던 'VSCode'도 스프링 부트 애플리케이션을 개발할 수 있는 IDE가 된다. 

지금부터 **Visual Studio Code(줄여서 VSCode)**에서 스프링 부트 기반 자바 애플리케이션을 개발할 수 있는 환경을 구축해보자.

- 참고: Spring Boot in Visual Studio Code
[https://code.visualstudio.com/docs/java/java-spring-boot](https://code.visualstudio.com/docs/java/java-spring-boot)

# 설치

스프링 부트 개발환경을 갖추기에 앞서 설치되어 있어야하는 것이 있다.

- Java Development Kit(JDK): 8 이상(11이상 권장)
- VSCode Java Extension Pack: [https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack)
- VSCode 내려받기: [https://code.visualstudio.com/download](https://code.visualstudio.com/download)

![]({{"/assets/post/2021-01-06/2021-01-06-001.png" | absolute_url }})

## JDK 설치

JDK  설치와 관련해는 많은 포스팅이 있기 때문에 크게 설명하지 않고 윈도우즈를 기준으로 JDK를 설치하고 설정하는 내용을 정리한 자료를 공유한다.

<iframe src="https://docs.google.com/presentation/d/e/2PACX-1vRMGtGU2IUkeLa0MRTrLmmnPoYf4ceg-QKRdMvPJ1usASMt8Xa22FeE9kZ36KkE8rn0GzEvWAInZUtV/embed?start=false&loop=false&delayms=3000" frameborder="0" width="960" height="749" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>

리눅스나 맥OS 의 경우에는 패키지 관리자와 지원도구를 이용해서 손쉽게 사용할 수 있다. 보다 자세하게 설명하는 포스팅이 있어 공유하고 넘어간다.

- 여러 개의 JDK를 설치하고 선택해서 사용하기([https://blog.benelog.net/installing-jdk.html](https://blog.benelog.net/installing-jdk.html))

## VSCode Java Extension Pack 설치

VSCode 가 설치되어 있어야 한다.

### VSCode 설치

VSCode를 설치하자([https://code.visualstudio.com/](https://code.visualstudio.com/))

![]({{"/assets/post/2021-01-06/2021-01-06-002.png" | absolute_url }})

### 확장팩 설치하기

VSCode 에서 확장팩을 설치하는 방법은 2가지가 있다.

- 웹 마켓플레이스 검색: [https://marketplace.visualstudio.com/](https://marketplace.visualstudio.com/)
- VSCode 내 확장 마켓플레이스 검색: `Ctrl + Shift + X` 를 눌러 VSCode 'Extension Marketplace' 를 패널을 띄운다.

'웹 마켓플레이스' 에서 검색해보면 다음과 같이 "Installation" 아래에 VSCode 팔레트에 붙여넣기 하면 확장팩설치가 진행되는 명령어를 복사할 수 있는 코드를 제공한다.  

예: `ext install vscjava.vscode-java-pack`

![]({{"/assets/post/2021-01-06/2021-01-06-003.png" | absolute_url }})

'VSCode 내 확장 마켓플레이스'에서 'Install' 버튼을 눌렀을 때 `ext install {extension-identifier}`  이 실행된다고 추측할 수 있다.

설치해야하는 플러그인은 다음과 같다:

1. Java Extension Pack - Microsoft: [https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack)

    ![]({{"/assets/post/2021-01-06/2021-01-06-004.png" | absolute_url }})

2. Spring Boot Extension Pack - Pivotal: [https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-boot-dev-pack](https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-boot-dev-pack)

    ![]({{"/assets/post/2021-01-06/2021-01-06-005.png" | absolute_url }})

**"Spring Boot Extension Pack"** 전체를 설치해도 되고, 아래 3가지만 선택해서 설치(Install)해도 된다.

- **Spring Boot Tools - Pivotal**: [https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-spring-boot](https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-spring-boot)
- **Spring Initializr Java Support - Microsoft** : [https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-spring-initializr](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-spring-initializr)
- **Spring Boot Dashboard - Microsoft**: [https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-boot-dev-pack](https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-boot-dev-pack)

**"Lombok Annotations Support for VS Code"** 확장팩도 설치한다.

- [https://marketplace.visualstudio.com/items?itemName=GabrielBB.vscode-lombok](https://marketplace.visualstudio.com/items?itemName=GabrielBB.vscode-lombok)

**'Spring Boot Tools' 확장팩**은 다음 파일 패턴을 가지는 파일에 대해서 파일수정할 때 활성화된다.

- `.java`: 스프링 부트 사양을 따르는 경우(`@SpringBoot` 애너테이션과 `main()` 메서드가 함께있음) 활성화
- `application*.properties`
- `application*.yml`

다음 기능을 제공한다:

- `@RequiestMapping` 에 선언된 경로(path)를 탐색할 수 있는 기능
- 실행 중인 앱이 제공하는 경로에 접근할 수 있는 기능
- 스프링 부트에 정의된 ["Spring Boot Properties Metadata"](https://docs.spring.io/spring-boot/docs/current/reference/html/configuration-metadata.html) 를 이용해서 `.properties` 와 `.yml` 에서 자동완성 및 검증기능을 제공

**'Spring Initializr Java Support' 확장팩**은 VSCode 내에서 Spring Initialzr([https://start.spring.io/](https://start.spring.io/)) API를 이용하여 스프링 부트 프로젝트를 구성할 수 있다. 

**'Spring Boot Dashboard' 확장팩**은 피보탈이 이클립스를 통해 제공하는 대시보드와 유사하게 작동한다. 등록된 스프링 부트 애플리케이션 조회, 실행, 중단, 디브그 및 실행중인 스프링 부트 앱을 브라우저에서 열어볼 수 있다.

# 프로젝트 생성 및 실행

## 프로젝트 생성

`Ctrl + Shift + P` 를 눌러 커맨드 팔레트(Command palette)를 열어 **'Spring initalizr: Create a Gradle Project'** 를 선택한다.

- 경로: [https://raw.githubusercontent.com/Microsoft/vscode-spring-initializr/master/images/spring-initializr-vsc.gif](https://raw.githubusercontent.com/Microsoft/vscode-spring-initializr/master/images/spring-initializr-vsc.gif)

    ![]({{"/assets/post/2021-01-06/2021-01-06-006.png" | absolute_url }})

1. **Spring Boot version 선택:** 2.4.1(2021-01-05 기준)
2. **Project language 선택**: Kotlin
3. **Group Id 등록**: ex) io.honeymon.boot.springboot.vscode
4. **Artifact Id** 등록: spring-boot-of-vs-code
5. **Packaging type** 선택: JAR
6. **Java Version** 선택: 11
7. Dependnecies 선택(사용하려는 기술에 따라 다름)

    ![]({{"/assets/post/2021-01-06/2021-01-06-007.png" | absolute_url }})

    1. Spring Boot DevTools
    2. Lombok
    3. Spring Configuration Processor
    4. Spring Web
    5. Spring Data JPA
    6. H2 Database
    7. Flyway Migration
    8. MariaDB Driver
8. 저장소 생성위치 지정
    1. Spring Initializr 사이트에서 ZIP 파일을 내려받고 나면 다음과 같은 팝업이 VSCode 오른쪽 하단에 노출된다.

    ![]({{"/assets/post/2021-01-06/2021-01-06-008.png" | absolute_url }})

9. 오픈!
10. **VSCode 자바 프로젝트 구성파일**을 파일탐색기에서 제외할 지 묻는 팝업이 뜬다.
    1. Spring Initializr 사이트에서 ZIP 파일을 내려받고 나면 다음과 같은 팝업이 VSCode 오른쪽 하단에 노출된다.

        ![]({{"/assets/post/2021-01-06/2021-01-06-009.png" | absolute_url }})

11. 프로젝트 구성이 완료된 모습

    ![]({{"/assets/post/2021-01-06/2021-01-06-010.png" | absolute_url }})

- `[application.properties](http://application.properties)` → `application.yml`  변경

    ![]({{"/assets/post/2021-01-06/2021-01-06-011.png" | absolute_url }})

    - 스프링 부트 확장팩에서 `.properties` 와 `.yml` 사용시 스프링 부트 속성 자동완성기능을 지원한다. 보다 자세한 내용은 [https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-spring-boot](https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-spring-boot) 를 참조바란다.
    - properties 보다는 YAML([https://yaml.org/](https://yaml.org/)) 을 선호함
        - 작성하기 쉽다(문서 편집기 지원)
        - 읽기 쉽다
        - properties 와는 다르게 인코딩 영향을 받지 않는다.
        - properties 파일은 이클립스에서 인코딩 문제가 발생할 수 있다.

> VSCode 에서 지원하는 YAML 방식은 일반적으로 사용하는 방식과 달라서 일반적 사용방식에 맞춰 작동하도록 하는 방법을 확인할 필요가 있어 보인다.

일반적인 사용방법

```
logging.level:
  org.springframework.web: DEBG
```

VSCode 작성방법:

```
logging:
  level:
    '[org.springframework.web]': debug
```

## 코드작성

VSCode 는 우리가 사용했던 IDE(Eclipse, IntelliJ)와는 다르게 Java 파일을 생성하지 않는다. 다음과 같은 순서로 파일을 생성하고 Java 형식을 등록한다(Java 클래스 파일을 바로 생성하는 확장팩을 만들어도 되겠다).

[https://code.visualstudio.com/docs/java/java-tutorial/JavaHelloWorld.Standalone.mp4](https://code.visualstudio.com/docs/java/java-tutorial/JavaHelloWorld.Standalone.mp4)

1.  `GreetingController.java` 파일을 생성하면 `java` 파일형식을 인식하여 자바 형식을 생성한다.

    ![]({{"/assets/post/2021-01-06/2021-01-06-012.png" | absolute_url }})

2. 스프링 관련 코드(애노테이션) 을 등록하면 자동완성이 시작된다.

    ![]({{"/assets/post/2021-01-06/2021-01-06-013.png" | absolute_url }})

1. 작성되는 코드에 따라 **"OUTLINE"** 영역에 `[@RequestMapping](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/RequestMapping.html)`(`@GetMapping`, `@PostMapping`, `@PutMapping`, `@DeleteMapping`) 이 선언된 경로 등이 노출된다.

    ![]({{"/assets/post/2021-01-06/2021-01-06-014.png" | absolute_url }})

    1. `@RequestMapping` 애노테이션은 스프링 WebMVC 에서 요청을 수행할 핸들러(HttpMethod + URL)를 지정하는 용도로 사용된다.
    2. 단축키(`Ctrl + Shift + O`) 를 이용하면 프로젝트 내에 클래스, 스프링 빈 등을 

## 실행

메인클래스(`@SpringBootTest` 와 메인메서드(`public static void main(String[] args)`) 선언)를 선택하여 우클릭 후 Run 을 실행하거나 소스코드를 열면 Code lens([https://code.visualstudio.com/blogs/2017/02/12/code-lens-roundup](https://code.visualstudio.com/blogs/2017/02/12/code-lens-roundup)) 기능이 활성화 되어 메인메서드 위에 `Run | Debug` 가 노출된다.

![]({{"/assets/post/2021-01-06/2021-01-06-015.png" | absolute_url }})

실행하면 작은 팝업메뉴가 출력된다.

![]({{"/assets/post/2021-01-06/2021-01-06-016.png" | absolute_url }})

아직까지는 Code lens 를 이용해서 실행한 것과 SPRING BOOT DASHBOARD 에서 실행한 것 사이에 동기화는 지원하지 않는 것으로 보인다.

SPRING BOOT DASHBOARD 를 이용해서 실행하면 브라우저로 열거나 중단하는 것이 가능하다.

![]({{"/assets/post/2021-01-06/2021-01-06-017.png" | absolute_url }})

# 정리

묵직한 인텔리제이, 이클립스를 비롯한 IDE 대신 가볍게 사용할 수 있는 IDE로 써볼 수 있을 듯 하다. 단축키가 달라서 어색한 부분이 많이 있지만 그건 익숙함의 문제라고 생각한다. 

개인적으로는 인텔리제이 연간 라이센스를 구매해서 사용하고 있어서 굳이~ VSCode 에서 개발할 필요가 있을까 싶지만, 다른 이의 프로젝트를 가볍게 열어보고 실행하는데는 적당한 도구가 될 수 있다고 생각한다.

## VM 설정

- [https://code.visualstudio.com/docs/java/java-debugging](https://code.visualstudio.com/docs/java/java-debugging)
1. 왼쪽 메뉴에 있는 Run 탭을 선택한다.

    ![]({{"/assets/post/2021-01-06/2021-01-06-018.png" | absolute_url }})

2. 'Open `launch.json` ' 을 선택한다.

    ![]({{"/assets/post/2021-01-06/2021-01-06-019.png" | absolute_url }})

3. `launch.json`  파일 내에 args 값을 조정한다.

    ```
    {
        "configurations": [
            {
                "type": "java",
                "name": "Spring Boot-SpringBootForVsCodeApplication<spring-boot-for-vs-code>",
                "request": "launch",
                "cwd": "${workspaceFolder}",
                "console": "internalConsole",
                "mainClass": "io.honeymon.boot.springboot.vscode.springbootforvscode.SpringBootForVsCodeApplication",
                "projectName": "spring-boot-for-vs-code",
                "args": "",
                "vmArgs": "-Xmx2G -Xms512M"
            }
        ]
    }
    ```

# 참고

- **Getting Started with Java in VS Code**: [https://code.visualstudio.com/docs/java/java-tutorial#_before-you-begin](https://code.visualstudio.com/docs/java/java-tutorial#_before-you-begin)
- **Java Extension Pack**: [https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack)
- **Spring Boot in Visual Studio Code**: [https://code.visualstudio.com/docs/java/java-spring-boot](https://code.visualstudio.com/docs/java/java-spring-boot)
    - **Spring Boot Tools - Pivotal**: [https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-spring-boot](https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-spring-boot)
    - **Spring Initializr Java Support - Microsoft** : [https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-spring-initializr](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-spring-initializr)
    - **Spring Boot Dashboard - Microsoft**: [https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-boot-dev-pack](https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-boot-dev-pack)
- **My VS Code Setup - Ansh Dhingra**: [https://dev.to/anshdhinhgra47/my-vs-code-setup-4997](https://dev.to/anshdhinhgra47/my-vs-code-setup-4997)
- `@RequestMapping`: [https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/RequestMapping.html](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/RequestMapping.html)
    - 웹요청을 처리하는 핸들러에 선언한다.
- `@Service`: [https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/stereotype/Service.html](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/stereotype/Service.html)
    - 애플리케이션에서 서비스로직을 처리하는 클래스에 선언한다.