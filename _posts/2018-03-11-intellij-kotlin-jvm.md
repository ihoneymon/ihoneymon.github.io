---
layout: post
title: Intellij에서 코틀린 프로젝트 빌드시 JVM target 잘못됐다 할 때
categories: [tech]
tags: [kotlin,intellij,jvm]
date: 2018-03-08 17:30
---

```
Kotlin: Cannot inline bytecode built with JVM target 1.8 into bytecode that is being built with JVM target 1.6. Please specify proper '-jvm-target' option
```

## 상황
MSA 트레이닝을 위한 프로젝트([https://github.com/ihoneymon/msa-training](https://github.com/ihoneymon/msa-training))를 만들고 [``spring-config-server``](https://github.com/ihoneymon/msa-training/config-server)를 코틀린(kotlin)으로 언어를 지정하고 빌드를 마치니 다음과 같은 에러 메시지가 애플리케이션 컴파일 중에 뜬다.

```
Kotlin: Cannot inline bytecode built with JVM target 1.8 into bytecode that is being built with JVM target 1.6. Please specify proper '-jvm-target' option
```

이와 관련된 내용을 다음에서 찾았다.

* [M12.1 - Intellij complains ‘Cannot inline bytecode build with JVM target 1.8 into bytecode that is being built with JVM target 1.6’](https://discourse.corda.net/t/m12-1-intellij-complains-cannot-inline-bytecode-build-with-jvm-target-1-8-into-bytecode-that-is-being-built-with-jvm-target-1-6/1249/4)

## 정리
* 코틀린 컴파일러에서 사용하는 JVM 버전을 1.6 에서 1.8로 변경하면 된다.
![Intellij > Settings > Kotlin Compiler]({{"/assets/post/2018-03-11/2018-03-11-intellij-kotlin-jvm.png" | absolute_url }})
