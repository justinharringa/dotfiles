#!/bin/sh
# 
# Set JAVA_HOME for macOS
if test "$(uname)" = "Darwin"
then
  jdk() {
    version=$1
    export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
    java -version
  }
  export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
fi
