#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

CONTEXT_PATH=$(cd $(dirname ${0}); pwd)

source ${CONTEXT_PATH}/../common/env.sh

IMAGE_VERSION="1.0.0"
IMAGE_NAME="jdk8"

JAVA_VERSION_MAJOR=8
JAVA_VERSION_MINOR=92
JAVA_VERSION_BUILD=14

JDK_PKG_FILE="jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz"

#
# function main
#
main() {
  # download Oracle JDK
  if [ -f ${CONTEXT_PATH}/resources/${JDK_PKG_FILE} ]; then
    echo "Oracle JDK resources/${JDK_PKG_FILE} is OK."
  else
    echo "Oracle JDK ${CONTEXT_PATH}/resources/${JDK_PKG_FILE} not found, then download from Oracle site."
    # Download from oracle site
    mkdir -p ${CONTEXT_PATH}/resources
    cd ${CONTEXT_PATH}/resources
    # --silent
    curl --fail --location --retry 3 \
    --header "Cookie: oraclelicense=accept-securebackup-cookie; " \
    http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz \
    -o ${JDK_PKG_FILE}
  fi

  if [ ! -f ${CONTEXT_PATH}/resources/${JDK_PKG_FILE} ]; then
    echo "Oracle JDK ${CONTEXT_PATH}/resources/${JDK_PKG_FILE} not found, download from Oracle site error."
    exit 0
  fi
}

# docker build/tag/push
source ${CONTEXT_PATH}/../common/template.sh