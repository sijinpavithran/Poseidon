#!/bin/bash
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-14.0.2.jdk/Contents/Home"

#export JAVA_HOME="/usr/lib/jvm/java-14-openjdk-amd64/"
export JAVA_OPTS="-Xms512m -Xmx512m"
exec ./gradlew "$@"
