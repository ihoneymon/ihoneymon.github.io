---
layout: post
title: "[java.util] StringJoiner 사용법 확인"
tags: [java,util,stringjoiner]
categories: [tech]
date: 2018-03-25 12:00
---

자바로 코딩을 하다보면 문자열 중간에 `-` 혹은 `,` 등을 넣어야 할 때가 있다. 이때 쉽게 할 수 있는 방법으로 다음과 같은 방식을 사용하곤 했다.

```java
@Test
public void testUseForeach() {
    int[] source = {1, 2, 3, 4};
    String separator = ",";

    StringBuilder sb = new StringBuilder();
    int sourceLength = source.length;
    for (int i = 0; i < sourceLength; i++) {
        sb.append(Integer.toString(source[i]));
        if (i < sourceLength - 1) {
            sb.append(separator);
        }
    }

    assertThat(sb.toString()).isEqualTo("1,2,3,4");
}
```

루프를 돌면서 ``if (i < sourceLength - 1)`` 조건식을 통해서 배열의 끝이 아닌 경우 ``separator``를 문자열에 추가하는 방식을 사용했다. 이렇게 주먹구구식으로 대응하는 것에 익숙했다. 뭐 크게 고민하지 않고 대응할 수 있는 방법일 것이다.

자바 ``List`` 인터페이스에는 내부 요소(Element)사이에 ``join``으로 지정된 구분자를 넣어주는 기능은 없다. 예를 들면,

```groovy
List<String> array = new ArrayList<>("apple", "banana", "tomato");
array.join("\n AND ");
```

대신 ``StringBuilder``와 유사한 형태로 지정된 문자열이 추가될때마다 구분자를 넣어주는 기능이 있다. 바로 link:https://docs.oracle.com/javase/10/docs/api/java/util/StringJoiner.html[`StringJoiner`]가 그렇다.

```java
@Test
public void testDelimiter() {
    int[] source = {1, 2, 3, 4};

    StringJoiner strJoiner = new StringJoiner(",");
    for (int el : source) {
        strJoiner.add(Integer.toString(el));
    }

    assertThat(strJoiner.toString()).isEqualTo("1,2,3,4");
}
```

``StringJoiner``에서 구획문자(Delimiter), 접두사(Prefix)와 접미사(Suffix)를 추가할 수 있다.

```java
@Test
public void testPrefixDelimiterSuffixByStringBuilder() {
    int[] source = {1, 2, 3, 4};

    StringBuilder sb = new StringBuilder();
    sb.append("[");
    int sourceLength = source.length;
    for (int i = 0; i < sourceLength; i++) {
        sb.append(Integer.toString(source[i]));
        if (i < sourceLength - 1) {
            sb.append(",");
        }
    }
    sb.append("]");

    assertThat(sb.toString()).isEqualTo("[1,2,3,4]");
}

@Test
public void testDelimiterPrefixSuffix() {
    int[] source = {1, 2, 3, 4};

    StringJoiner strJoiner = new StringJoiner(",", "[", "]");
    for (int el : source) {
        strJoiner.add(Integer.toString(el));
    }

    assertThat(strJoiner.toString()).isEqualTo("[1,2,3,4]");
}
```

이런 이야기가 나온 것은 페북에서 케빈님이 동적쿼리를 만드는데 link:https://www.facebook.com/k3vin.lee/posts/611087802567014[`WHERE 1 = 1`]를 사용하는 것에 대해 이해하지 못하겠다는 이야기를 하면서 그에 대한 제안을 살피다가 그렇게 다시한번 상기하게 되었다.

```java
@Test
public void testOneElement() {
    String name = "name = `test`";
    StringJoiner stringJoiner = new StringJoiner("AND ", "WHERE ", "");
    stringJoiner.add(name);

    assertThat(stringJoiner.toString()).isEqualTo("WHERE name = `test`");
}

@Test
public void testTwoElements() {
    String[] source = {"name = `test`", "nick = `nick`"};

    StringJoiner stringJoiner = new StringJoiner(" AND ", "WHERE ", "");
    for (String el : source) {
        stringJoiner.add(el);
    }

    assertThat(stringJoiner.toString()).isEqualTo("WHERE name = `test` AND nick = `nick`");

    // List<String> conditions = new ArrayList<>();
    // 배열에 join 기능이 있는건 groovy 구나...
    // conditions.join("\nAND ");
    // 이게 없어서 StringJoin을 쓰는 것인지도...
}
```

## 다른 방법
link:https://docs.oracle.com/javase/10/docs/api/java/util/StringJoiner.html[`StringJoiner`]를 살펴보니 스트림(stream)과 ``Collector.joining({delimiter}) 이용하는 예제코드가 있다.

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4);
String commaSeparatedNumbers = numbers.stream()
   .map(i -> i.toString())
   .collect(Collectors.joining(", "));
```

> 이렇게도 사용가능하군. 내가 이런 걸 기억해낼 수 있을까?

## 정리
* 자바 프로그래머라면 종종 ``java.util`` 과 ``java.lang`` 패키지를 살펴보기 바란다.
* 관습을 무심코 따르기보다는 보다 나은 해결책을 찾을 수 있는 방법을 모색하고 연구하자.
* 코딜리티에서 코딩시험 보다가 긴장하고 시간에 좇기면 기억 못할 가능성이 있으니 손가락이 기억하도록 만들어두자.
