#!/bin/bash
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-10.jdk/Contents/Home/"
export JAVA_OPTS="-Xms512m -Xmx512m"
exec ./gradlew "$@"
