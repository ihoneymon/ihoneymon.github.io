---
title: "[spring] Deprecate MediaType.APPLICATION_JSON_UTF8 in favor of APPLICATION_JSON"
layout: post
category: [tech]
tags: [tech, java, spring, spring-boot]
date: 2019-10-23 08:00:00
---

* 참고: [Deprecate MediaType.APPLICATION_JSON_UTF8 in favor of APPLICATION_JSON · Issue #22788 · spring-projects/spring-framework](https://github.com/spring-projects/spring-framework/issues/22788)

## 개요

- Spring Boot 2.2.0.RELEASE: `MediaType.APPLICATION_JSON_UTF8` Deprecated
    - `Content-Type` 으로 전달되는 속성값은 1가지 성질만 가진다.
    - `MediaType.APPLICATION_JSON_UTF8` 의 경우 `application/json; charset=UTF-8` 로 2개의 속성으 ㄹ가지고 있음
- `Content-Type: application/json;charset=UTF-8` 요청에 대해 `Content-Type: application/json` 으로 응답
- `StringHttpMessageConverter` 기본 Charset 은 `ISO_8859_1` 이다.
    - 한글깨짐 발생함
    - Charset 을 UTF-8 변경등록해야함

## 세부사항

- Deprecated `MediaType.APPLICATION_JSON_UTF_8`
    
    /**
     * Public constant media type for {@code application/json;charset=UTF-8}.
     * @deprecated Deprecated as of Spring Framework 5.2 in favor of {@link #APPLICATION_JSON}
     * since major browsers like Chrome
     * <a href="https://bugs.chromium.org/p/chromium/issues/detail?id=438464">
     * now comply with the specification</a> and interpret correctly UTF-8 special
     * characters without requiring a {@code charset=UTF-8} parameter.
     */
    @Deprecated
    public static final MediaType APPLICATION_JSON_UTF8;
    

### 예제: `HelloController`
    
    @RestController
    public class HelloController {
    
        @GetMapping("/greeting")
        public Greeting greeting(@RequestParam(defaultValue = "허니몬") String name) {
            return new Greeting("Hello, " + name);
        }
    
        @Getter
        public static class Greeting {
            private String statement;
    
            public Greeting(String statement) {
                this.statement = statement;
            }
        }
    }
    

### 테스트코드
    
    @RunWith(SpringRunner.class)
    @WebMvcTest(HelloController.class)
    public class HelloControllerTest {
        @Autowired
        private MockMvc mvc;
    
        @Test
        public void test() throws Exception {
            ResultActions result = mvc.perform(get("/greeting")
                    .contentType(MediaType.APPLICATION_JSON_UTF8));
    
            //then
            result
                    .andExpect(status().isOk())
                    .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON_UTF8))
                    .andExpect(jsonPath("$.statement").value("Hello, 허니몬"));
        }
    }
    

### Spring Boot 2.1.8
    
    MockHttpServletRequest:
          HTTP Method = GET
          Request URI = /greeting
           Parameters = {}
              Headers = [Content-Type:"application/json;charset=UTF-8"]
                 Body = null
        Session Attrs = {}
    
    Handler:
                 Type = io.honeymon.training.programming.api.HelloController
               Method = public io.honeymon.training.programming.api.HelloController$Greeting io.honeymon.training.programming.api.HelloController.greeting(java.lang.String)
    
    Async:
        Async started = false
         Async result = null
    
    Resolved Exception:
                 Type = null
    
    ModelAndView:
            View name = null
                 View = null
                Model = null
    
    FlashMap:
           Attributes = null
    
    MockHttpServletResponse:
               Status = 200
        Error message = null
              Headers = [Content-Type:"application/json;charset=UTF-8"] // charset 유지
         Content type = application/json;charset=UTF-8
                 Body = {"statement":"Hello, 허니몬"}
        Forwarded URL = null
       Redirected URL = null
              Cookies = []
    

### Spring Boot 2.2.0
    
    MockHttpServletRequest:
          HTTP Method = GET
          Request URI = /greeting
           Parameters = {}
              Headers = [Content-Type:"application/json;charset=UTF-8"]
                 Body = null
        Session Attrs = {}
    
    Handler:
                 Type = io.honeymon.training.programming.api.HelloController
               Method = io.honeymon.training.programming.api.HelloController#greeting(String)
    
    Async:
        Async started = false
         Async result = null
    
    Resolved Exception:
                 Type = null
    
    ModelAndView:
            View name = null
                 View = null
                Model = null
    
    FlashMap:
           Attributes = null
    
    MockHttpServletResponse:
               Status = 200
        Error message = null
              Headers = [Content-Type:"application/json"] // charset 제거
         Content type = application/json
                 Body = {"statement":"Hello, íëëª¬"}
        Forwarded URL = null
       Redirected URL = null
              Cookies = []
    

## 정리

- 스프링 5.2 부터는 UTF-8 이 기본 Charset 이라고 인식바람
- 스프링 부트 2.2.0 업그레이드 후 응답 `Content-Type` 에서 `Charset` 빠짐
    - `Content-Type: application/json; charset=UTF-8` 을 `Content-Type: application/json;`으로 변경함
- `RestTemplate` 를 그대로 사용하는 경우 문자열(`String`) 으로 응답값을 받아 처리하는 경우 한글 깨짐
    - `StringHttpMessageConverter` 의 기본 Charset 이 `StandardCharsets.ISO_8859_1` 으로 되어 있다.
    - 스프링이 요청에서 `Content-Type` 에서 `charset` 을 무시(제거)
    - `StringHttpMessageConverter.getContentTypeCharset` 메서드에서 기본Charset `StandardCharsets.ISO_8859_1`  처리

            
            private Charset getContentTypeCharset(@Nullable MediaType contentType) { // contentType == MediaType.APPLICATION_JSON
            	if (contentType != null && contentType.getCharset() != null) {
            		return contentType.getCharset();
            	}
            	else {
            		Charset charset = getDefaultCharset(); //DEFAULT_CHARSET = StandardCharsets.ISO_8859_1
            		Assert.state(charset != null, "No default charset");
            		return charset;
            	}
            }


    - 한글(UTF-8)이 깨진 것처럼 보임

## **해결방법**

1. **응답값을 문자열(`String`) 대신 객체로 변환하여 처리 ← 추천!!**
    - `MappingJackson2HttpMessageConverter` 기본 Charset 은 `UTF-8`
2. `RestTemplateBuilder.addtionalMessageConverts` 메시지 컨버터 추가

        
        RestTemplate restTemplate = new RestTemplateBuilder()
                        .rootUri(ROOT_URI)
                        .additionalInterceptors(new ApiClientHttpRequestInterceptor(DEFAULT_AUTHORIZATION))
                        .additionalMessageConverters(
                                new StringHttpMessageConverter(StandardCharsets.UTF_8), 
                                new MappingJackson2HttpMessageConverter())
                        .setConnectTimeout(Duration.ofSeconds(10))
                        .setReadTimeout(Duration.ofSeconds(5))
                        .build();
        
        public static class ApiClientHttpRequestInterceptor implements ClientHttpRequestInterceptor {
            private final String apiKey;
        
        
            public ApiClientHttpRequestInterceptor(String apiKey) {
                Assert.hasText(apiKey, "Required apiKey.");
        
                this.apiKey = apiKey;
            }
        
            @Override
            public ClientHttpResponse intercept(HttpRequest request, byte[] body, ClientHttpRequestExecution execution) throws IOException {
                HttpHeaders headers = request.getHeaders();
                headers.setContentType(MediaType.APPLICATION_JSON);
        
                if (StringUtils.hasText(apiKey)) {
                    headers.set(HttpHeaders.AUTHORIZATION, apiKey);
                }
                return execution.execute(request, body);
            }
        }
        

3. 기본 Charset 이`UTF-8`인 `StringHttpMessageConverter` 를 RestTemplate  추가

        
        restTemplate.getMessageConverters()
          .add(0, new StringHttpMessageConverter(StandardCharsets.UTF-8));
        // 기본설정된 StringHttpMessageConverter 보다 앞에 추가하여 미리 처리하도록 하는 케이스
        

## 참고

- Spring Boot Http Encoding Default: UTF-8

    [](https://www.notion.so/62eb16a2f2f248a48b6b13cb7d479c9e#899c43cc93ca465997ae62185c16bc43)

- [https://github.com/spring-projects/spring-framework/issues/22788](https://github.com/spring-projects/spring-framework/issues/22788)
    - RFC 7159 는 RFC 8259 에 의해 폐기됐다.
    - `Charset` 매개변수가 정의되어 있지 않다.
    - 브라우저에서는 이에 대한 수정이 이뤄졌다.
- [https://bugs.chromium.org/p/chromium/issues/detail?id=438464](https://bugs.chromium.org/p/chromium/issues/detail?id=438464)
- [https://github.com/spring-projects/spring-framework/issues/22954](https://github.com/spring-projects/spring-framework/issues/22954)
- [https://developer.mozilla.org/ko/docs/Web/HTTP/Headers/Accept-Charset](https://developer.mozilla.org/ko/docs/Web/HTTP/Headers/Accept-Charset)
- [spring-web 5.1.x AbstractJackson2HttpMessageConverter](https://github.com/spring-projects/spring-framework/blob/5.1.x/spring-web/src/main/java/org/springframework/http/converter/json/AbstractJackson2HttpMessageConverter.java)
- [spring-web 5.2.x AbstractJackson2HttpMessageConverter](https://github.com/spring-projects/spring-framework/blob/master/spring-web/src/main/java/org/springframework/http/converter/json/AbstractJackson2HttpMessageConverter.java)
