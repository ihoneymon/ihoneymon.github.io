---
layout: post
title: "[ide] STS 패키지 탐색기(Package Explorer) 폰트 크기 변경"
categories: [tech]
tags: [ide,eclipse,sts]
date: 2019-01-12 00:00
---

회사에서는 IDE로 Intellij를 사용할 때는 몰랐는데, 최근에 STS를 기준으로 뭔가를 하게 되면서 맥북에서 사용하면서 불편함을 느끼게 되는 부분 중에 하나가 'Package Explorer' 내에 있는 트리 항목의 폰트가 너무 작다는 것이다. 각 화면을 구성하고 있는 값이 절대값으로 되어 있는 탓에 고해상도 모니터에서는 폰트가 작아지는 단점이 있다.

![2019-01-01 한라산]({{"/assets/post/2019-01-12/2019-01-12-eclipse-small-font.png" | absolute_url }})

그래서 이 불편함을 해소하기 위해 어떻게 폰트를 키울 수 있는지 인터넷을 검색했다.

그 결과 다음과 같이 변경되었다.

// 그림 크게 보이는 explorer
![2019-01-01 한라산]({{"/assets/post/2019-01-12/2019-01-12-eclipse-large-font.png" | absolute_url }})

STS4(SpringTools 4)를 기준으로, ``{eclipse 설치위치}/plugins/org.eclipse.ui.themes_1.2.200.v20180828-1350/css/e4_basestyle.css`` 파일 마지막에 다음과 같은 코드를 추가하면 'Package Explorer' 폰트 크기를 조정할 수 있다.

```
.MPart Tree{
  font-size: 18;
}
```
