#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

CONTEXT_PATH=$(cd $(dirname ${0}); pwd)

REGISTRY_URL="euler-registry.primeton.com"
IMAGE_NAME=""
IMAGE_VERSION="latest"
IMAGE_FILE=""

#
# function help
#
help() {
    echo "Usage:"
    echo "/bin/bash ${0} --REGISTRY_URL euler-registry.primeton.com --IMAGE_NAME ubuntu --IMAGE_VERSION 16.04 --IMAGE_FILE /root/registry/ubuntu-16.04.tar"
    echo "--REGISTRY_URL)   Target registry to push image"
    echo "--IMAGE_NAME)     Image name"
    echo "--IMAGE_ERSION)   Image version"
    echo "--IMAGE_FILE)     Image file package"
}

if [ $# -eq 0 ]; then
    help
    exit 0
fi

# parse args
while [ -n "${1}" ]; do
	case "${1}" in
	--REGISTRY_URL) REGISTRY_URL="${2}"; shift 2;;
	--IMAGE_NAME) IMAGE_NAME="${2}"; shift 2;;
	--IMAGE_VERSION) IMAGE_VERSION="${2}"; shift 2;;
	--IMAGE_FILE) IMAGE_FILE="${2}"; shift 2;;
	*) shift 1;;
	esac
done

if [ -z "${IMAGE_FILE}" ]; then
	echo "[ERROR] IMAGE_FILE is empty."
	exit 1
fi

if [ ! -f ${IMAGE_FILE} ]; then
	echo "[ERROR] ${IMAGE_FILE} not found"
	exit 1
fi

if [ -z "${IMAGE_NAME}" ]; then
    help
    exit 1
fi

if [ -z "${IMAGE_VERSION}" ]; then
    IMAGE_VERSION="latest"
fi

# clean
if [ ! -z "`docker images | grep "${IMAGE_NAME}" | grep "${IMAGE_VERSION}"`" ]; then
    docker rmi -f ${IMAGE_NAME}:${IMAGE_VERSION}
fi
if [ ! -z "`docker images | grep "${REGISTRY_URL}/${IMAGE_NAME}" | grep "${IMAGE_VERSION}"`" ]; then
    docker rmi -f ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_VERSION}
fi

local_images=`docker images -q`

docker load -i ${IMAGE_FILE}
code=$?
if [ ${code} -ne 0 ]; then
	echo "An error occured while try to execute docker load -i ${IMAGE_FILE}"
	exit ${code}
fi

for x in $(docker images -q); do
	if [ -z "${local_images}" ]; then
		IMAGE_ID="${x}"
		break
	else
		exist="no"
		for y in ${local_images}; do
			if [ "X${x}" == "X${y}" ]; then
				exist="yes"
				break
			fi
		done
		if [ "X${exist}" == "Xno" ]; then
			IMAGE_ID="${x}"
			break
		fi
	fi
done

if [ -z ${IMAGE_ID} ]; then
	echo "[ERROR] Failed to execute command \"docker load -i ${IMAGE_FILE}\"."
	exit 1
fi

i=0
for x in $(docker images | grep "${IMAGE_ID}"); do
	if [ ${i} -eq 0 ]; then
		repository=${x}
	fi
	if [ ${i} -eq 1 ]; then
		tag=${x}
		break
	fi
	let "i += 1"
done

if [ -z "${IMAGE_NAME}" ]; then
	IMAGE_NAME=${repository}
fi
if [ -z "${IMAGE_VERSION}" ]; then
	IMAGE_VERSION=${tag}
fi
if [ -z "${REGISTRY_URL}" ]; then
	REGISTRY_URL="euler-registry.primeton.com"
fi

docker tag ${IMAGE_ID} ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_VERSION}

docker push ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_VERSION}

code=$?
# if [ ${code} -ne 0 ]; then
#	exit ${code}
# fi

# clean
docker rmi -f ${IMAGE_ID}

exit ${code}