#!/usr/bin/env sh

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

$JAVA_HOME/bin/java -cp "${antlr}:${CLASSPATH}" org.antlr.v4.runtime.misc.TestRig $@
