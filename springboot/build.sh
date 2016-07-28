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
IMAGE_NAME="springboot"

#
# main code
#
main() {
    echo "${IMAGE_NAME}:${IMAGE_VERSION}"
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

    AUTO_CONF_SCRIPT=${CONTEXT_PATH}/../tomcat8/resources/autoconfig.sh
    if [ -f "${AUTO_CONF_SCRIPT}" ]; then
        cp -f ${AUTO_CONF_SCRIPT} ${CONTEXT_PATH}/resources/
    else
        echo "[`date`] [WARN ] ${AUTO_CONF_SCRIPT} not found."
    fi
}

# docker build/tag/push
source ${CONTEXT_PATH}/../common/template.sh