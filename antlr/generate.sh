#!/usr/bin/env sh

antlr="${GOPATH}/src/github.com/antlr/antlr4/tool/target/antlr4-4.6-complete.jar"

java -jar "${antlr}" -Dlanguage=Go -visitor -package antlr Monkey.g4