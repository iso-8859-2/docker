#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

CONTEXT_PATH=$(cd $(dirname ${0}); pwd)

#
# help function
#
help() {
    echo "Usage:"
    echo "/bin/bash ${0} --IMAGE_NAME nginx --IMAGE_VERSION 1.10"
    echo "/bin/bash ${0} --IMAGE_NAME euler-bpr --IMAGE_VERSION 0.2.0 --REGISTRY_URL euler-registry.primeton.com"
    echo "--REGISTRY_URL)   Default from docker official registry pull image, docker private registry url"
    echo "--RM_IMG)         yes | no, default yes, after save target image as file, execute docker rmi \${IMAGE_NAME}:\${IMAGE_VERSION} ?"
    echo "--IMAGE_NAME}     Not null, which image to be download and save as file ?"
    echo "--IMAGE_VERSION)  Default latest, image tag (version)"
    echo "--TARGET_DIR)      Default ${CONTEXT_PATH}/target, which directory to be save docker image file ?"
    exit 0
}
#
# parse args
#
while [ -n "${1}" ]; do
    case "${1}" in
        --REGISTRY_URL) REGISTRY_URL="${2}"; shift 2;;
        --RM_IMG) RM_IMG="${2}"; shift 2;;
        --IMAGE_NAME) IMAGE_NAME="${2}"; shift 2;;
        --IMAGE_VERSION) IMAGE_VERSION="${2}"; shift 2;;
        --TARGET_DIR) TARGET_DIR="${2}"; shift 2;;
        *) echo "Skip key ${1}"; shift 1;;
    esac
done

if [ -z "${IMAGE_NAME}" ]; then
    help
fi

if [ -z "${IMAGE_VERSION}" ]; then
    IMAGE_VERSION="latest"
fi

if [ -z "${TARGET_DIR}" ]; then
    TARGET_DIR=${CONTEXT_PATH}/target
fi
if [ ! -d ${TARGET_DIR} ]; then
    mkdir -p ${TARGET_DIR}
fi

if [ -z "${RM_IMG}" ]; then
    RM_IMG="yes"
fi

IMAGE_FILE=${TARGET_DIR}/${IMAGE_NAME}-${IMAGE_VERSION}.tar
if [ -f ${IMAGE_FILE} ]; then
    rm -f ${IMAGE_FILE}
fi

if [ -z "${REGISTRY_URL}" ]; then
    docker pull ${IMAGE_NAME}:${IMAGE_VERSION}
    if [ -z "`docker images | grep "${IMAGE_NAME}" | grep "${IMAGE_VERSION}"`" ]; then
        echo "[`date`] [ERROR] Failed to pull image ${IMAGE_NAME}:${IMAGE_VERSION} from docker official registry."
        exit 1
    else
        docker save -o ${IMAGE_FILE} ${IMAGE_NAME}:${IMAGE_VERSION}
        if [ -f ${IMAGE_FILE} ]; then
            echo "[`date`] [INFO ] Save image ${IMAGE_NAME}:${IMAGE_VERSION} to ${IMAGE_FILE} success."
        else
            echo "[`date`] [INFO ] Save image ${IMAGE_NAME}:${IMAGE_VERSION} to ${IMAGE_FILE} error."
        fi
        if [ "yes" == "${RM_IMG}" ]; then
            echo "[`date`] [INFO ] Delete docker host local image ${IMAGE_NAME}:${IMAGE_VERSION}."
            docker rmi -f ${IMAGE_NAME}:${IMAGE_VERSION}
        fi
    fi
else
    docker pull ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_VERSION}
    if [ -z "`docker images | grep "${REGISTRY_URL}/${IMAGE_NAME}" | grep "${IMAGE_VERSION}"`" ]; then
        echo "[`date`] [ERROR] Failed to pull image ${IMAGE_NAME}:${IMAGE_VERSION} from ${REGISTRY_URL}."
        exit 1
    else
        docker save -o ${IMAGE_FILE} ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_VERSION}
        if [ -f ${IMAGE_FILE} ]; then
            echo "[`date`] [INFO ] Save image ${IMAGE_NAME}:${IMAGE_VERSION} to ${IMAGE_FILE} success."
        else
            echo "[`date`] [INFO ] Save image ${IMAGE_NAME}:${IMAGE_VERSION} to ${IMAGE_FILE} error."
        fi
        if [ "yes" == "${RM_IMG}" ]; then
            echo "[`date`] [INFO ] Delete docker host local image ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_VERSION}."
            docker rmi -f ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_VERSION}
        fi
    fi
fi

ls -al ${TARGET_DIR}