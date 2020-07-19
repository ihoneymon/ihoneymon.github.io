---
title: "[gradle] 그레이들 Annotation processor 와 Querydsl"
layout: post
category: [tech]
tags: [tech, gradle, annotation-processor, querydsl]
date: 2020-07-09
---

새로운 맥북을 받고 스프링 부트 버전업을 하면 그레이들도 버전업을 해야하는 상황이 온다. 

- 그레이들 4.X 에서 5.X, 최근에는 6.5 까지 출시되었다.

나는 내가 관리하는 프로젝트에서 사용하는 라이브러리 버전업을 가급적이면 최신버전으로 유지하려고 한다. 이 과정에서 많은 시행착오를 겪는다(삽질...). 그 삽질을 정리해서 공유하는데, 이 글 도 그런 과정에서 나온 것 중 하나다.

이 과정에서 기존에 Querydsl 로 생성한 Q클래스를 불러올 수 없다는 경고가 노출된다. Intellij IDEA 에서 build 를 Gradle 로 하면 큰 문제없이 넘어가지만 Intellij IDEA 로 선택하면 정상적으로 작동되지 않는다. build 를 Gradle 로 하면 그 속도가 너무 느린 탓에 짜증이 난다.

이 문제를 조만간 해결해야지 하다가 약간의 여유가 생겨 해결방법을 찾아보기로 한다.

# 개요

- Querydsl 이 생성한 Q클래스를 찾을 수 없을 때
- [그레이들 4.6](https://docs.gradle.org/4.6/release-notes.html): "Convenient declaration of annotation processor dependencies"  추가됨
    - 롬복(Lombok) 등을 비롯한 애노테이션 기반 코드처리성능 향상목적
    - [https://blog.gradle.org/incremental-compiler-avoidance#about-annotation-processors](https://blog.gradle.org/incremental-compiler-avoidance#about-annotation-processors)
- JPA 엔티티(`@Entity`)를 기반으로 작동하는 Querydsl 사용하는 경우
    - 그레이들 플러그인 사용 [https://plugins.gradle.org/plugin/com.ewerk.gradle.plugins.querydsl](https://plugins.gradle.org/plugin/com.ewerk.gradle.plugins.querydsl)
    - Querydsl 이 작동하기 위한 클래스를 생성하는 JPAAnnotationProcessor 작동 DSL 적용안됨
- Gradle AnnotationProcessor 작동에 내맞기자.

# 상세내역

프로젝트 코드를 관리하다보면 자연스레 개발도구(IDE)와 빌드도구를 새로운 버전에 맞춰 업데이트를 진행하게 된다. 그런데 이 과정에서 꽤 골치를 썩게된다. 버전업이 되면서 과거에 있던 기능이 제외(Deprecated)되거나 변경되고 새로운 기능이 추가되고, 다른 기능으로 대체되는 등의 변동이 발생하기 때문이다. 그러면 한땀한땀 이전 버전과의 차이점을 비교하고 릴리즈 노트와 참고문서(Refernece document)를 찾아보고 생각보다 많은 시간을 허비하게 된다.

그레이들은 프로젝트의 의존성을 관리하고 작성된 코드를 배포가능한 형태로 가공하는 개발도구다. 그리고 그 버전이 매우 빠른 속도로 업데이트 된다. 그리고 기능의 변동도 많다. 그 탓에 기존에 작성한 스크립트가 쓸모가 없어지거나 동작하지 않는 등의 상황이 발생한다. 그레이들 플러그인(gradle plugin, [https://plugins.gradle.org/](https://plugins.gradle.org/)) 을 사용하다보면 그런 상황을 많이 마주하게 된다.

그 중에 하나가 JPA 엔티티 클래스(`javax.persistence.Entity` 선언클래스)를  가공하여 Querydsl 클래스로 만드는 Queyrdsl JPA([https://github.com/querydsl/querydsl](https://github.com/querydsl/querydsl), [http://www.querydsl.com/static/querydsl/latest/reference/html/ch02.html#jpa_integration](http://www.querydsl.com/static/querydsl/latest/reference/html/ch02.html#jpa_integration))는 꽤 많은 시간을 허비하게 한다.

Querydsl JPA 는 지정된 경로에서 `@Entity` 애노테이션이 선언되어 있는 클래스를 찾아서 `JPAAnnotationProcessor` 를 이용하여 Querydsl 클래스를 생성한다. 이렇게 생성된 Querydsl 클래스는 자바 언어가 가지는 정적코드의 장점을 활용하여 안전한 쿼리문을 작성할 수 있도록 한다. 이 `JPAAnnotationProcessor` 의 작동을 정의하는 스크립트를 정의하는 것이 꽤 까다로롭다.

그레이들에서 Querydsl 을 사용하기 위한 설정방법은 크게 2가지가 있다.

- 그레이들 플러그인 "com.ewerk.gradle.plugins.querydsl"  설정
- Annotation Processor 설정

Querydsl 을 지원하는 많은 그레이들 플러그인 중에서 널리 쓰이는 것이 "com.ewerk.gradle.plugins.querydsl" 플러그인([https://plugins.gradle.org/plugin/com.ewerk.gradle.plugins.querydsl](https://plugins.gradle.org/plugin/com.ewerk.gradle.plugins.querydsl))이다. 

## 그레이들 플러그인 "com.ewerk.gradle.plugins.querydsl"  설정

```groovy
apply plugin: "com.ewerk.gradle.plugins.querydsl"

def queryDslDir = "src/main/generated"
querydsl {
    library = "com.querydsl:querydsl-apt:4.2.2" // 사용할 AnnotationProcesoor 정의
    jpa = true
    querydslSourcesDir = queryDslDir
}
sourceSets {
    main {
        java {
            srcDir queryDslDir
        }
    }
}

compileQuerydsl {
    options.annotationProcessorPath = configurations.querydsl
}

configurations { // 손권남님이 공유해주신 팁 
    // 아래를 지정하지 않으면, compile 로 걸린 JPA 의존성에 접근하지 못한다.
    querydsl.extendsFrom compileClasspath
}
```

이 그레이들 플러그인은 2018.7 에 출시된  `1.0.10` 를 마지막으로 더이상 업데이트가 이뤄지고 있지 않다. 그레이들 4.6 에서 Annotation Processor 가 소개되었고, 이를 반영한 그레이들 5.X 붜는 정상적으로 작동하지 않았다. 그래서 위 스크립트 부분 중 다음 부분이 추가되었다.

```groovy
compileQuerydsl {
    options.annotationProcessorPath = configurations.querydsl
}
```

querydsl-apt 에 있는 AnnotationProcessor 의 경로를 설정해준다. 그리고 그레이들 6.x 에서는 다음 코드를 추가해주면 정상작동한다고 한다.

```groovy
configurations { // 손권남님이 공유해주신 팁 
    // 아래를 지정하지 않으면, compile 로 걸린 JPA 의존성에 접근하지 못한다.
    querydsl.extendsFrom compileClasspath
}
```

2년 전 작성된 그레이들 플러그인을 최신 버전의 그레이들에서 정상동작 시키기 위해 뭔가 하나씩 설정을 추가하는 상황이 발생한다. 그래서 **이 플러그인을 걷어내기로 결심한다.**

## Annotation Processor 설정

그레이들 4.6([https://docs.gradle.org/4.6/release-notes.html](https://docs.gradle.org/4.6/release-notes.html)) 에서 소개된 Annotation processor 는 애노테이션이 선언된 클래스처리를 별도의 프로세서에서 처리하여 성능향상을 꽤했다. 

```groovy
compile("org.projectlombok:lombok")
annotationProcessor("org.projectlombok:lombok")
```

### 과거형

```groovy
/** QueryDSL Class Generate Script */
def generatedJavaSrcDir = 'src/main/generated'
def queryDslOutput = file(generatedJavaSrcDir)

sourceSets {
    main {
        java {
            srcDirs = ['src/main/java', generatedJavaSrcDir]
        }
    }
}

/** QClass 생성 */
task generateQueryDSL(type: JavaCompile, group: 'build') {
    doFirst {
        delete queryDslOutput
        queryDslOutput.mkdirs()
    }
    source = sourceSets.main.java
    classpath = configurations.compile
    destinationDir = queryDslOutput
    options.compilerArgs = [
            '-proc:only',
            '-processor',
            'com.querydsl.apt.jpa.JPAAnnotationProcessor' // 여기에 각 라이브러리에서 제공하는 annotation processor 를 선언해야함
    ]
}
compileJava.dependsOn(generateQueryDSL)

/** clean 태스크 실행시 QClass 삭제 */
clean {
    delete queryDslOutput
}
```

과거형은 **querydsl-apt** 외에 Lombok 등 Annotation Processor 를 사용하는 라이브러리가 추가될 때마다 `-processor` 에 클래스를 추가해줘야하는 번거로움이 있다. 

### 변경된 Gradle Annotation processor 설정

```groovy
configure(querydslProjects) {
    apply plugin: "io.spring.dependency-management"

    dependencies {
        compile("com.querydsl:querydsl-core")
        compile("com.querydsl:querydsl-jpa")

        annotationProcessor("com.querydsl:querydsl-apt:${dependencyManagement.importedProperties['querydsl.version']}:jpa") // querydsl JPAAnnotationProcessor 사용 지정
        annotationProcessor("jakarta.persistence:jakarta.persistence-api") // java.lang.NoClassDefFoundError(javax.annotation.Entity) 발생 대응 
        annotationProcessor("jakarta.annotation:jakarta.annotation-api") // java.lang.NoClassDefFoundError (javax.annotation.Generated) 발생 대응 
    }

    
}
```

변경된 그레이들 Annotation processor 를 사용하면 별다른 설정을 하지 않아도 그레이들 자체에서 `annotationProcessor` 선언되어있는 라이브러리를 이용하여 적절한 AnnotationProcessor 를 선택하여 사용한다. lombok 도 이와 유사하게 사용가능한 것을 확인할 수 있다.

사내에 위 내용을 정리하고 공유했을 때 몇 번의 피드백을 받아 정리되었다.

변경된 Gradle annotation processor 설정으로 작성하면 굉장히 깔끔해진다. 그리고 그레이들 5.x 부터 6.x 까지 큰 문제없이 동작한다.

Intellij IDEA 에서 어떤 빌드방식(Gradle or Intellij IDEA)을 선택하는지에 따라서 Querydsl Annotation processor 처리 생성물이 생성되는 위치도 변동이 생긴다.

## Intellij IDEA build 설정

**Intellij IDEA - Build, Execution, Deployment - Build tools → Gradle** 에서 'Build and run' 설정값에 따라 Annotation processor 생성물 위치가 달라짐

- Gradle: 각 모듈별 `build/generated/sources/annotationProcessor/java/main`
- IntellijI IDEA: 각 모듈별 `src/main/generated`
    - Compiler Annotation procesoors 설정영향받음

# 정리

- 그레이들 플러그인의 사용은 자제한다.
    - 그레이들의 변동을 따라오지 못한다.
    - 오픈소스 프로젝트인 경우가 많다보니 지속적인 관리가 되지 않는다.
- 그레이들에서 제공하는 기본기능을 활용한다.
    - 그레이들 메이저 버전이 변경될 때는 레퍼런스문서를 살펴보도록 하자.

# 참고

- [https://stackoverflow.com/questions/62521275/problem-with-generating-querydsl-classes-with-gradle](https://stackoverflow.com/questions/62521275/problem-with-generating-querydsl-classes-with-gradle) ← Good!
- [https://blog.ddoong2.com/2020/01/02/Querydsl-build-gradle-설정/#](https://blog.ddoong2.com/2020/01/02/Querydsl-build-gradle-%EC%84%A4%EC%A0%95/)
- [https://github.com/querydsl/querydsl/issues/2444](https://github.com/querydsl/querydsl/issues/2444)
- [https://kwonnam.pe.kr/wiki/gradle/jpa_metamodel_generation](https://kwonnam.pe.kr/wiki/gradle/jpa_metamodel_generation)
- [https://medium.com/@geminikim/개인취향-jpa-사용기-querydsl-gradle-lombok-76c509aec60e](https://medium.com/@geminikim/%EA%B0%9C%EC%9D%B8%EC%B7%A8%ED%96%A5-jpa-%EC%82%AC%EC%9A%A9%EA%B8%B0-querydsl-gradle-lombok-76c509aec60e)