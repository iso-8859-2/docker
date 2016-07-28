#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

CONTEXT_PATH=$(cd $(dirname ${0}); pwd)

if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "/bin/bash ${0} --REGISTRY_URL euler-registry.primeton.com --IMAGE_DIR /root/registry"
    exit 0
fi

# parse args
while [ -n "${1}" ]; do
	case "${1}" in
	--REGISTRY_URL) REGISTRY_URL="${2}"; shift 2;;
	--IMAGE_DIR) IMAGE_DIR="${2}"; shift 2;;
	*) shift 1;;
	esac
done

if [ -z "${IMAGE_DIR}" ]; then
    echo "Usage:"
    echo "/bin/bash ${0} --REGISTRY_URL euler-registry.primeton.com --IMAGE_DIR /root/registry"
    exit 0
fi

if [ ! -d "${IMAGE_DIR}" ]; then
    echo "[`date`] [WARN ] Directory ${IMAGE_DIR} not exists."
    exit 0
fi

if [ -z "${REGISTRY_URL}" ]; then
	REGISTRY_URL="euler-registry.primeton.com"
fi

#
# function upload
# @param $1 IMAGE_DIR
# Scan all ${IMAGE_NAME}-${IMAGE_VERSION}.tar file, include sub-folder.
#
upload() {
    if [ $# -eq 0 ] || [ -z "${1}" ] || [ ! -d ${1} ]; then
        echo "[`date`] [WARN ] Illegal argument \$1 = ${1}"
        return 1
    fi
    if [ -z "`ls ${1}`" ]; then
        echo "[`date`] [INFO ] Empty directory ${1}."
        return 0
    fi
    for f in `ls ${1}` ; do
        if [ -f "${1}/${f}" ]; then
            if [[ "${f}" == *.tar ]]; then
                # Compute image name and version by file name
                echo "[`date`] [INFO ] Begin push image file ${1}/${f} to ${REGISTRY_URL}"
                # euler-bpr-0.2.0.tar
                x=${f%.tar} # euler-bpr-0.2.0
                # find last '-'
                IFS='-' read -r -a array <<< "${x}"
                VERSION=${array[-1]} # 0.2.0
                echo "[`date`] [INFO ] VERSION=${VERSION}"
                let INDEX="${#x} - ${#VERSION} - 1"
                NAME=${x:0:${INDEX}} # euler-bpr
                echo "[`date`] [INFO ] NAME=${NAME}"

                /bin/bash ${CONTEXT_PATH}/upload.sh --REGISTRY_URL "${REGISTRY_URL}" --IMAGE_NAME "${NAME}" \
                    --IMAGE_VERSION "${VERSION}" --IMAGE_FILE "${1}/${f}"

                code=$?
                if [ ${code} -ne 0 ]; then
                    echo "[`date`] [ERROR] An error occured while try to push image file ${f} to ${REGISTRY_URL}."
                    exit ${code}
                fi
                echo "[`date`] [INFO ] Finished push image file ${f} to ${REGISTRY_URL}"
            else
                echo "[`date`] [WARN ] File ${1}/${f} extension is not .tar, skip it."
            fi
        elif [ -d "${1}/${f}" ]; then
            # Recursive call function upload
            upload "${1}/${f}"
        else
            echo "[`date`] [INFO ] ${1}/${f} is not file and directory, maybe is device."
        fi
    done
}

#
# invoke function upload
#
upload ${IMAGE_DIR}