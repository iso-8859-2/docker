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
IMAGE_NAME="tomcat8"

TOMCAT_PKG="apache-tomcat-8.0.36.tar.gz"

#
# main code
#
main() {
    # download apache tomcat
    if [ ! -f "${CONTEXT_PATH}/resources/${TOMCAT_PKG}" ] ; then
        curl --fail --location --retry 3 \
            http://apache.fayea.com/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz \
            -o ${CONTEXT_PATH}/resources/${TOMCAT_PKG}
    fi
    if [ ! -f "${CONTEXT_PATH}/resources/${TOMCAT_PKG}" ] ; then
        echo "${CONTEXT_PATH}/resources/${TOMCAT_PKG} not found."
        exit 0
    fi
    # compile runnable jar auto-inject.jar
    /bin/bash ${CONTEXT_PATH}/../autoinject/build.sh
    # Copy resource file
    AUTO_INJECT_JAR="${CONTEXT_PATH}/../autoinject/target/auto-inject.jar"
    if [ -f "${AUTO_INJECT_JAR}" ]; then
        cp -f ${AUTO_INJECT_JAR} ${CONTEXT_PATH}/resources/
    else
        echo "[`date`] [WARN ] ${AUTO_INJECT_JAR} not found."
        exit 1
    fi
}

# docker build/tag/push
source ${CONTEXT_PATH}/../common/template.sh