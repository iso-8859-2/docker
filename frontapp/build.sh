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
IMAGE_NAME="frontapp"

JAVA_VERSION_MAJOR=6
JAVA_VERSION_MINOR=45
JAVA_VERSION_BUILD=06

JRE_PKG_FILE="jre-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.bin"

#
# function main
#
main() {
    # download Oracle JDK
    if [ -f ${CONTEXT_PATH}/resources/${JRE_PKG_FILE} ]; then
        echo "Oracle jre file ${CONTEXT_PATH}/resources/${JRE_PKG_FILE} exists."
    else
        echo "Oracle jre ${CONTEXT_PATH}/resources/${JRE_PKG_FILE} not found, then download from Oracle site."
        # Download from oracle site
        mkdir -p ${CONTEXT_PATH}/resources
        if [ -f "${CONTEXT_PATH}/../jre6/resources/${JRE_PKG_FILE}" ]; then
            cp -f ${CONTEXT_PATH}/../jre6/resources/${JRE_PKG_FILE} ${CONTEXT_PATH}/resources/
        else
            curl --fail --location --retry 3 \
                --header "Cookie: oraclelicense=accept-securebackup-cookie; " \
                http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.bin \
                -o ${CONTEXT_PATH}/resources/${JRE_PKG_FILE}
        fi
    fi

    if [ ! -f ${CONTEXT_PATH}/resources/${JRE_PKG_FILE} ]; then
        echo "Oracle JDK ${CONTEXT_PATH}/resources/${JRE_PKG_FILE} not found, download from Oracle site error."
        exit 1
    fi

    if [ ! -d ${CONTEXT_PATH}/resources/jre1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} ]; then
        chmod +x ${CONTEXT_PATH}/resources/${JRE_PKG_FILE}
        cd ${CONTEXT_PATH}/resources/
        ${CONTEXT_PATH}/resources/${JRE_PKG_FILE}
        rm -f ${CONTEXT_PATH}/resources/jre1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}/src.zip
    fi

    # compile runnable jar euler-ci-tool.jar
    /bin/bash ${CONTEXT_PATH}/../jenkins/plugins/euler-ci-tool/build.sh
    # Copy resource file
    CI_TOOL_JAR="${CONTEXT_PATH}/../jenkins/plugins/euler-ci-tool/target/euler-ci-tool.jar"
    if [ -f "${CI_TOOL_JAR}" ]; then
        cp -f ${CI_TOOL_JAR} ${CONTEXT_PATH}/resources/
    else
        echo "[`date`] [WARN ] ${CI_TOOL_JAR} not found."
        exit 1
    fi

    AUTO_CONF_SCRIPT=${CONTEXT_PATH}/../tomcat8/resources/autoconfig.sh
    if [ -f "${AUTO_CONF_SCRIPT}" ]; then
        cp -f ${AUTO_CONF_SCRIPT} ${CONTEXT_PATH}/resources/
    else
        echo "[`date`] [WARN ] ${AUTO_CONF_SCRIPT} not found."
    fi
}

# docker build/tag/push
source ${CONTEXT_PATH}/../common/template.sh