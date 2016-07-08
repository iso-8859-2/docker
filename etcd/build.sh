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
IMAGE_NAME="etcd"

PKG_FILE="etcd-v2.3.7-linux-amd64.tar.gz"

#
# main code
#
main() {
    if [ ! -f ${CONTEXT_PATH}/resources/${PKG_FILE} ]; then
        echo "${CONTEXT_PATH}/resources/${PKG_FILE} not found, then download from official site."
        mkdir -p ${CONTEXT_PATH}/resources
        # --silent
        curl --fail --location --retry 3 \
        https://github.com/coreos/etcd/releases/download/v2.3.7/etcd-v2.3.7-linux-amd64.tar.gz \
        -o ${CONTEXT_PATH}/resources/${PKG_FILE}
    fi
    if [ ! -f ${CONTEXT_PATH}/resources/${PKG_FILE} ]; then
        echo "${CONTEXT_PATH}/resources/${PKG_FILE} not found, download from official site error."
        exit 0
    fi
}

# docker build/tag/push
source ${CONTEXT_PATH}/../common/template.sh