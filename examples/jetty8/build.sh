#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

CONTEXT_PATH=$(cd $(dirname ${0}); pwd)

source ${CONTEXT_PATH}/../../common/env.sh

IMAGE_VERSION="1.0.0"
IMAGE_NAME="example/war5"

#
# main code
#
main() {
    echo "${IMAGE_NAME}:${IMAGE_VERSION}"
    if [ -d ${CONTEXT_PATH}/resources/war ]; then
        rm -rf ${CONTEXT_PATH}/resources/war
    fi
    if [ ! -d ${CONTEXT_PATH}/resources ]; then
        mkdir -p ${CONTEXT_PATH}/resources
    fi
    if [ -d ${CONTEXT_PATH}/../tomcat8/resources/war ]; then
        cp -rf ${CONTEXT_PATH}/../tomcat8/resources/war ${CONTEXT_PATH}/resources/
    fi
}

# docker build/tag/push
source ${CONTEXT_PATH}/../../common/template.sh