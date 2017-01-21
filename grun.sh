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

if [ "${1}" == "" ] ; then
    echo "No source to parse given!"
    exit 1;
fi

echo "Show AST for ${1}..."

grammarFile="Monkey.g4"
antlr="${GOPATH}/src/github.com/antlr/antlr4/tool/target/antlr4-4.6-complete.jar"
workDir="${PROGRAM_DIRECTORY}/.grun"

if [ -e "${workDir}" ] ; then
    rm -rfv "${workDir}"
fi

mkdir -pv "${workDir}"
cp -v "${PROGRAM_DIRECTORY}/antlr/${grammarFile}" "${workDir}/"
cp -v "${1}" "${workDir}/"

cd "${workDir}"
$JAVA_HOME/bin/java -jar "${antlr}" -Dlanguage=Java -visitor ${grammarFile}
$JAVA_HOME/bin/javac -cp "${antlr}:${CLASSPATH}" Monkey*.java
$JAVA_HOME/bin/java -cp "${antlr}:${CLASSPATH}" org.antlr.v4.gui.TestRig Monkey program -gui ${1}

cd -