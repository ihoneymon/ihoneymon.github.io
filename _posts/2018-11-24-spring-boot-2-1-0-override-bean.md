---
layout: post
title: "[spring-boot] BeanDefinitionOverrideException 발생시"
category: [spring-boot]
tags: [springboot, BeanDefinitionOverrideException]
date: 2018-11-24 00:00
---

스프링 부트 2.1.0 에는 스프링 5.1.0 프레임워크가 반영되었다.

스프링 5.1.0 은 컴포넌트 탐색과정에서 발생하는 오버헤드를 감소시키기 위한 여러가지 정책이 반영되었는데, 그 중에 하나가
생성한 빈을 덮어쓰는 상황을 강제적으로 제한한다.

그래서 동일한 이름을 가진 스프링 빈이 등록되려고 하면 BeanDefinitionOverrideException 이 발생한다.

**`DefaultListableBeanFactory` 중 일부.**
``` java
BeanDefinition existingDefinition = this.beanDefinitionMap.get(beanName);
if (existingDefinition != null) {
    if (!isAllowBeanDefinitionOverriding()) {
        throw new BeanDefinitionOverrideException(beanName, beanDefinition, existingDefinition);
    }
    else if (existingDefinition.getRole() < beanDefinition.getRole()) {
        // e.g. was ROLE_APPLICATION, now overriding with ROLE_SUPPORT or ROLE_INFRASTRUCTURE
        if (logger.isInfoEnabled()) {
            logger.info("Overriding user-defined bean definition for bean '" + beanName +
                    "' with a framework-generated bean definition: replacing [" +
                    existingDefinition + "] with [" + beanDefinition + "]");
        }
    }
    else if (!beanDefinition.equals(existingDefinition)) {
        if (logger.isDebugEnabled()) {
            logger.debug("Overriding bean definition for bean '" + beanName +
                    "' with a different definition: replacing [" + existingDefinition +
                    "] with [" + beanDefinition + "]");
        }
    }
    else {
        if (logger.isTraceEnabled()) {
            logger.trace("Overriding bean definition for bean '" + beanName +
                    "' with an equivalent definition: replacing [" + existingDefinition +
                    "] with [" + beanDefinition + "]");
        }
    }
    this.beanDefinitionMap.put(beanName, beanDefinition);
}
```

이는 스프링 부트의 설정이 아닌 스프링 프레임워크에서 빈을 등록하는 과정에서 발생하는 것으로 이에 대한 속성을 비활성화할 수 있는
기능을 제공한다.

```
spring.main.allow-bean-definition-overriding: true
```
위와 같이 `spring.main.allow-bean-definition-overriding` 속성을 `true` 로 선언하면
문제가 해결될 것이다. 이후에는 중복되는 빈을 찾아서 중복이 발생하지 않도록 조치해야 한다.
