#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

CONTEXT_PATH=$(cd $(dirname ${0}); pwd)

source ${CONTEXT_PATH}/../common/env.sh

IMAGE_VERSION="3.2.1"
IMAGE_NAME="redis"

#
# main code
#
main() {
    echo "${IMAGE_NAME}:${IMAGE_VERSION}"
}

# docker build/tag/push
source ${CONTEXT_PATH}/../common/template.sh