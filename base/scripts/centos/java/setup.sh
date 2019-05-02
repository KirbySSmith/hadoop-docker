#!/bin/bash

JAVA_VER=$1
DEST=$2
USER=$3

case $JAVA_VER in
7*)
  echo "========== INSTATLL JAVA (Java $JAVA_VER)=========="
  ;;
8*)
  echo "========== INSTATLL JAVA (Java $JAVA_VER)=========="
  ;;
*)
  echo "Invalid Java version ($JAVA_VER)"
  ;;
esac

yum -y install java-1.$JAVA_VER.0-openjdk-devel
