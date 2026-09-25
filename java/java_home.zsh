#!/bin/sh
# 
# Set jdk for macOS - https://github.com/AdoptOpenJDK/homebrew-openjdk#switch-between-different-jdk-versions
if test "$(uname)" = "Darwin"
then
  jdk() {
    local version=$1
    local home
    # --failfast errors when that version isn't installed, instead of silently
    # returning another JDK (e.g. `jdk 21` giving you 17). Leave JAVA_HOME alone then.
    home=$(/usr/libexec/java_home -v"$version" --failfast) || return 1
    export JAVA_HOME=$home
    java -version
  }
fi
