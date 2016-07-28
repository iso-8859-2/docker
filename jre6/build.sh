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
IMAGE_NAME="jre6"

JAVA_VERSION_MAJOR=6
JAVA_VERSION_MINOR=45
JAVA_VERSION_BUILD=06

JRE_PKG_FILE="jre-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.bin"

#
# main code
#
main() {
  # download Oracle JRE
  if [ -f ${CONTEXT_PATH}/resources/${JRE_PKG_FILE} ]; then
    echo "Oracle JRE resources/${JRE_PKG_FILE} is OK."
  else
    echo "Oracle JRE ${CONTEXT_PATH}/resources/${JRE_PKG_FILE} not found, then download from Oracle site."
    # Download from oracle site
    mkdir -p ${CONTEXT_PATH}/resources
    # --silent
    curl --fail --location --retry 3 \
      --header "Cookie: oraclelicense=accept-securebackup-cookie; " \
      http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/jre-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.bin \
      -o ${CONTEXT_PATH}/resources/${JRE_PKG_FILE}
  fi
  # http://download.oracle.com/otn/java/jdk/6u45-b06/jre-6u45-linux-x64.bin?AuthParam=1468912017_9b56da3f5f8ab6d21d49bdaec5826407
  if [ ! -f ${CONTEXT_PATH}/resources/${JRE_PKG_FILE} ]; then
    echo "Oracle JRE ${CONTEXT_PATH}/resources/${JRE_PKG_FILE} not found, download from Oracle site error."
    exit 0
  fi
  if [ ! -d ${CONTEXT_PATH}/resources/jre1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} ]; then
    chmod u+x ${CONTEXT_PATH}/resources/${JRE_PKG_FILE}
    cd ${CONTEXT_PATH}/resources/
    ${CONTEXT_PATH}/resources/${JRE_PKG_FILE}
  fi
}

# docker build/tag/push
source ${CONTEXT_PATH}/../common/template.sh