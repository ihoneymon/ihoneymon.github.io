---
title: "[lombok] 생성자에 선언된 애노테이션 복사하기"
layout: post
category: [tech]
tags: [tech, lombok, annotation]
date: 2020-07-18
---

* 부제: 스프링 `@Qualifier` 가 안먹힐 때

스프링에서 사용할 수 있는 스프링 빈 주입방식은 크게 3가지가 있다.

- 생성자 주입
- 설정자(Setter)를 이용한 주입
- 애노테이션(`@Autowired`, `@Inject`, `@Resource`)이 선언된 필드(field) 주입

이 중에서 권장되는 방식은 "**생성자 주입**"이다. 객체를 생성하는 단계에서 필요한 스프링 빈을 주입할 수 있어서 누락되는 것을 피할 수 있다.

> 스프링 환경에서 생성자 주입이 작동되려면 클래스에는 생성자가 하나만 선언되어 있어야 한다.

```jsx
@Slf4j
@Service
public class BootService {

    private ExampleProperties properties;

    public BootService(ExampleProperties properties) {
        this.properties = properties;
    }

    @PostConstruct
    public void init() {
        log.debug("Injected properties: {}", this.properties);
    }
```

> 해당 클래스를 테스트할 때 테스트용 스프링 애플리케이션컨텍스트를 구동하지 않고 원하는 코드로 바꿔치기도 가능하다.

자바 개발환경에서는 반복적으로 작성하게 되는 접근자/설정자(Getter(`get`)/Setter(`set`)), `toString()` 과 `equals()` 등을 애노테이션으로 대체할 수 있는 롬복(lombok, [https://projectlombok.org/](https://projectlombok.org/)) 이 널리 사용된다(개발자에 따라서 호불호가 갈린다. 애노테이션 사용이 남발되고 있다고…​).

가끔 동일한 타입의 스프링 빈을 다른 이름으로 사용해야 하는 상황이 생긴다. 그럴 때면 다음과 같이 스프링 빈의 이름을 각각 다르게 선언하여 사용하기도 한다. 아래코드는 서로다른 데이터베이스 설정으로 구성된 `DataSource` 를 `primaryDataSource` 와 `secondaryDataSource` 라는 이름으로 가지는 스프링 빈을 선언하고 있다.

```java
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Component;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Component
@RequiredArgsConstructor
public class MigrationBatchConfiguration {

    @Qualifier("primaryJdbcTemplate")
    private final JdbcTemplate primaryJdbcTemplate;
    @Qualifier("secondaryNpJdbcTemplate")
    private final NamedParameterJdbcTemplate secondaryNpJdbcTemplate;

    public void migrate() {
        List<MigrationDto> sources = primaryJdbcTemplate.query("SELECT name, age FROM primary_person", new MigrationDtoRowMapper());

        SqlParameterSource[] parameterSources = generateParameterSources(sources);
        secondaryNpJdbcTemplate.batchUpdate("INSERT INTO secondary_person(name, age) VALUES(?, ?)", parameterSources);
    }

    private SqlParameterSource[] generateParameterSources(List<MigrationDto> sources) {
        MapSqlParameterSource[] sqlParameterSources = new MapSqlParameterSource[sources.size()];
        for (int i = 0; i < sources.size(); i++) {
            sqlParameterSources[i] = new MapSqlParameterSource()
                    .addValue("name", sources.get(i).getName())
                    .addValue("age", sources.get(i).getAge());

        }
        return sqlParameterSources;
    }

    @Getter
    public static class MigrationDto {
        private String name;
        private Integer age;

        public MigrationDto(String name, Integer age) {
            this.name = name;
            this.age = age;
        }
    }

    public static class MigrationDtoRowMapper implements RowMapper<MigrationDto> {

        @Override
        public MigrationDto mapRow(ResultSet rs, int rowNum) throws SQLException {
            return new MigrationDto(rs.getString("name"), rs.getInt("age"));
        }
    }
}
```

위 `DatabaseConfig` 클래스에서 선언한 서로 다른 `primary~` 와 `secondary~` 빈을 사용하기 위해 다음과 같은 코드를 사용했다.

```java
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;

@SpringBootTest
class MigrationBatchConfigurationTest {

    @Autowired
    @Qualifier("primaryJdbcTemplate")
    private JdbcTemplate primaryJdbcTemplate;
    @Autowired
    @Qualifier("secondaryJdbcTemplate")
    private JdbcTemplate secondaryJdbcTemplate;
    @Autowired
    @Qualifier("secondaryNpJdbcTemplate")
    private NamedParameterJdbcTemplate secondaryNpJdbcTemplate;

    @BeforeEach
    void setUp() {
        primaryJdbcTemplate.execute("DELETE FROM primary_person");
        secondaryJdbcTemplate.execute("DELETE FROM secondary_person");
    }

    @Test
    @DisplayName("기본실행")
    void test01() {
        // 생략
    }
}
```

그런데 내 의도와는 다르게 `@Qualifier("secondaryNpJdbcTemplate")` 에 `primaryNpJdbcTempate` 가 주입되었다.

> @Priamry 선언을 했기 때문에 그런 것인가?

하고 고민을 했다. 그런데 이 클래스를 테스트하기 위해 다음과 같은 코드를 작성했을 때는 정상적으로 주입되는 것을 확인했다. 즉, 기본 구성은 정상적으로 주입받아 사용했다.

```java
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;

@SpringBootTest
class MigrationBatchConfigurationTest {

    @Autowired
    @Qualifier("primaryJdbcTemplate")
    private JdbcTemplate primaryJdbcTemplate;
    @Autowired
    @Qualifier("secondaryJdbcTemplate")
    private JdbcTemplate secondaryJdbcTemplate;
    @Autowired
    @Qualifier("secondaryNpJdbcTemplate")
    private NamedParameterJdbcTemplate secondaryNpJdbcTemplate;

    @BeforeEach
    void setUp() {
        primaryJdbcTemplate.execute("DELETE FROM primary_person");
        secondaryJdbcTemplate.execute("DELETE FROM secondary_person");
    }

    @Test
    @DisplayName("기본실행")
    void test01() {
        // 생략
    }
}
```

디버거를 이용해서 `MigrationBatchConfiguration` 를 살펴봤을 때는 계속 `primaryNpJdbcTemplate` 빈이 주입되는 상황이 발생했다. 생각을 정리하니,

> 다음과 같이 '`@Qualifier("secondaryNpJdbcTemplate")` 이 안먹는다.' 는 결론에 도달했다. 롬복 `@RequiredArgsConstructor` 가 `@Qualifier` 를 무시하고 있다는 생각을 하게 되었다.

```java
@RequiredArgsConstructor
public class MigrationBatchConfiguration {

    @Qualifier("primaryJdbcTemplate")
    private final JdbcTemplate primaryJdbcTemplate;
    @Qualifier("secondaryNpJdbcTemplate")
    private final NamedParameterJdbcTemplate secondaryNpJdbcTemplate;
    //생략
```

인터넷 검색을 시작한다. 'lombok constructor Qualifier annotation not work', 그리고 답을 찾았다.

- [How to make Lombok copy @Qualifier on generated constructors for a Spring Component/Service](https://ath3nd.wordpress.com/2018/12/13/spring-lombok-or-injection-just-became-a-bit-easier-part-2-of-2/)

문서를 살펴보면 프로젝트 루트에 롬복 구성파일 `lombok.config` 를 생서앟고 다음과 같은 코드를 추가하면 된다.

```yaml
# see https://projectlombok.org/features/constructor lombok.copyableAnnotations
lombok.copyableAnnotations += org.springframework.beans.factory.annotation.Qualifier
```

이렇게 추가해주면 롬복 애노테이션 프로세서(AnnotationProcessor)는 생성자(필드에 선언된 애노테이션 포함)를 생성는데 사용할 필드에 선언된 `@Qualifier` 를 복사한다.

## 정리

- 롬복을 사용하지 않는 경우, `@Qualifier` 애노테이션은 정상적으로 작동한다.
- 롬복을 사용하는 경우, `@Qualifier` 애노테이션은 적용되지 않는다.
- 롬복 구성파일(lombok.config) 파일을 만들어 롬복 애노테이션 프로세서가 복사할 대상(필드에 선언된 애노테이션)을 명시적으로 선언한다.

## 참고

- [@NoArgsConstructor, @RequiredArgsConstructor, @AllArgsConstructor](https://projectlombok.org/features/constructor)
- [How to make Lombok copy @Qualifier on generated constructors for a Spring Component/Service](https://ath3nd.wordpress.com/2018/12/13/spring-lombok-or-injection-just-became-a-bit-easier-part-2-of-2/)