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
IMAGE_NAME="example/runnablejar"

#
# main code
#
main() {
    # echo "${IMAGE_NAME}:${IMAGE_VERSION}"
    cd ${CONTEXT_PATH}/resources/
    mvn clean package -Dmaven.test.skip=true
    if [ ! -f ${CONTEXT_PATH}/resources/target/runnable-jar-example-1.0.0-jar-with-dependencies.jar ]; then
        echo "[`date`] [ERROR] ${CONTEXT_PATH}/resources/target/runnable-jar-example-1.0.0-jar-with-dependencies.jar file not found."
        exit 1
    fi
}

# docker build/tag/push
source ${CONTEXT_PATH}/../../common/template.sh