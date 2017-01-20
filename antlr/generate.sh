#!/usr/bin/env sh

java -jar ${GOPATH}/src/github.com/antlr/antlr4/tool/target/antlr4-4.6-complete.jar -Dlanguage=Go -visitor -package antlr Monkey.g4