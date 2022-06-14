#!/bin/sh
# 
# Set jdk for macOS - https://github.com/AdoptOpenJDK/homebrew-openjdk#switch-between-different-jdk-versions
if test "$(uname)" = "Darwin"
then
  jdk() {
    version=$1
    export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
    java -version
  }
fi
