#!/bin/bash
asciidoctor -b docbook $1.adoc
pandoc -f docbook -t markdown_strict $1.xml -o $1.md
rm $1.xml
