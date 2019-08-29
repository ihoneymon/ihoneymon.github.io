---
layout: post
title: "[rubygmes] cannot load such file -- /usr/share/rubygems-integration/all/specifications/exe/rake"
category: [tech]
tags: [ruby, rubygems]
date: 2018-12-15 11:00
---

rake 를 이용해서 asciidoctor 를 실행하려던 중에 다음과 같은 문제가 발생했다.

```
bundle exec rake
Traceback (most recent call last):
	1: from /usr/local/bin/rake:23:in `<main>'
/usr/local/bin/rake:23:in `load': cannot load such file -- /usr/share/rubygems-integration/all/specifications/exe/rake (LoadError)
```

인터넷 검색으로 관련된 해답을 찾았다. [Cannot load /usr/share/rubygems-integration/all/specifications/bin/rake](https://github.com/Shopify/mruby-engine/issues/33)

해결책:

```
$ sudo rm /usr/share/rubygems-integration/all/specifications/rake-{version}.gemspec
$ bundle install
```

구버전을 삭제하고 신버전을 설치하면서 재설정을 하면 긑!