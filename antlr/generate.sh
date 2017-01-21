#!/usr/bin/env bash

set -e

PROGRAM="${0}"

while [ -h "${PROGRAM}" ]; do
  LS=`ls -ld "${PROGRAM}"`
  LINK=`expr "${LS}" : '.*-> \(.*\)$'`

  if expr "${LINK}" : '.*/.*' > /dev/null; then
    PROGRAM="${LINK}"
  else
    PROGRAM=`dirname "${PROGRAM}"`/"${LINK}"
  fi
done

PROGRAM_DIRECTORY=`dirname "${PROGRAM}"`

antlr="${GOPATH}/src/github.com/antlr/antlr4/tool/target/antlr4-4.6-complete.jar"

echo "Deleting old lexer/parser files..."
rm -vf $PROGRAM_DIRECTORY/*.tokens
rm -vf $PROGRAM_DIRECTORY/*.go

echo "Generating new lexer/parser files..."
$JAVA_HOME/bin/java -jar "${antlr}" -Dlanguage=Go -visitor -package antlr $PROGRAM_DIRECTORY/Monkey.g4

echo "Done :-)"
