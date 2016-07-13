#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

# Print help information to terminal
_help() {
  echo "${CONTEXT_PATH}/build.sh"
  echo "${CONTEXT_PATH}/build.sh --REGISTRY_URL registry.primeton.com"
  echo "${CONTEXT_PATH}/build.sh --REGISTRY_URL registry.primeton.com --PUSH_IMG yes --LATEST yes --RM_IMG yes"
  echo ""
  echo "--help            Print help information;"
  echo "--REGISTRY_URL    Private docker registry (image repository);"
  echo "--IMAGE_NAME      The name of target image to build;"
  echo "--IMAGE_VERSION   The version of target image to build;"
  echo "--PUSH_IMG        Default no, push docker image to registry after build, (yes | no)"
  echo "--RM_IMG          Default no, remove local docker image after push, (yes | no)"
  echo "--LATEST          Default no, tag latest and push again, (yes | no)"
  echo ""
  _dohelp
  exit 0
}

if [ $# -eq 1 ] ; then
  case "${1}" in
    --h|--help) _help;;
    *) ;;
  esac
fi

# parse args
while [ -n "${1}" ]; do
  case "${1}" in
  --REGISTRY_URL) REGISTRY_URL="${2}"; shift 2;;
  --PUSH_IMG) PUSH_IMG="${2}"; shift 2;;
  --RM_IMG) RM_IMG="${2}"; shift 2;;
  --LATEST) LATEST="${2}"; shift 2;;
  --IMAGE_NAME) IMAGE_NAME="${2}"; shift 2;;
  --IMAGE_VERSION) IMAGE_VERSION="${2}"; shift 2;;
  --help) _help; exit 0;;
  *) _doparse "${1}" "${2}"; shift 1;;
  esac
done

# execute main function
# ready build resources if need
main

# force clean image
# docker rmi -f ${IMAGE_NAME}:${IMAGE_VERSION}

# docker build
echo "[`date`] Begin build docker image : ${IMAGE_NAME}:${IMAGE_VERSION}."
cd ${CONTEXT_PATH}
docker build --rm -t ${IMAGE_NAME}:${IMAGE_VERSION} .
echo "[`date`] End build docker image : ${IMAGE_NAME}:${IMAGE_VERSION}."

# docker images | grep "${IMAGE_NAME}"
if [ -z "`docker images | grep "${IMAGE_NAME}" | grep "${IMAGE_VERSION}"`" ]; then
    echo "[`date`] Failed to build docker image : ${IMAGE_NAME}:${IMAGE_VERSION}."
else
    echo "[`date`] Build docker image : ${IMAGE_NAME}:${IMAGE_VERSION} success."
fi

if [ -z "${REGISTRY_URL}" ]; then
  REGISTRY_URL="registry.primeton.com"
  echo "[`date`] [ERROR] REGISTRY_URL is empty, use default ${REGISTRY_URL}."
fi

if [ "yes" == "${PUSH_IMG}" ]; then
  # docker tag
  echo "[`date`] Begin tag image : ${IMAGE_NAME}:${IMAGE_VERSION}."
  docker tag ${IMAGE_NAME}:${IMAGE_VERSION} ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_VERSION}
  echo "[`date`] End tag image : ${IMAGE_NAME}:${IMAGE_VERSION}."

  # docker push
  echo "[`date`] Begin push image : ${IMAGE_NAME}:${IMAGE_VERSION} to ${REGISTRY_URL}."
  docker push ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_VERSION}
  echo "[`date`] End push image : ${IMAGE_NAME}:${IMAGE_VERSION} to ${REGISTRY_URL}."

  # clean docker tag
  echo "[`date`] [INFO ] Begin clean image tag : ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_VERSION}."
  docker rmi -f ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_VERSION}
  echo "[`date`] [INFO ] End clean image tag : ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_VERSION}."

  if [ "yes" == "${LATEST}" ]; then
    # docker tag latest
      echo "[`date`] [INFO ] Begin tag image : ${IMAGE_NAME}:latest."
      docker tag ${IMAGE_NAME}:${IMAGE_VERSION} ${REGISTRY_URL}/${IMAGE_NAME}:latest
      echo "[`date`] [INFO ] End tag image : ${IMAGE_NAME}:latest."
      # docker push latest
      echo "[`date`] [INFO ] Begin push image : ${IMAGE_NAME}:latest to ${REGISTRY_URL}."
      docker push ${REGISTRY_URL}/${IMAGE_NAME}:latest
      echo "[`date`] [INFO ] End push image : ${IMAGE_NAME}:latest to ${REGISTRY_URL}."
      # clean docker tag
      echo "[`date`] [INFO ] Begin clean image tag : ${REGISTRY_URL}/${IMAGE_NAME}:latest."
      docker rmi -f ${REGISTRY_URL}/${IMAGE_NAME}:latest
      echo "[`date`] [INFO ] End clean image tag : ${REGISTRY_URL}/${IMAGE_NAME}:latest."
  fi
fi

# clean docker image
if [ "yes" == "${RM_IMG}" ]; then
  echo "[`date`] [INFO ] Begin remove image ${IMAGE_NAME}:${IMAGE_VERSION}."
  docker rmi -f ${IMAGE_NAME}:${IMAGE_VERSION}
  echo "[`date`] [INFO ] End remove image ${IMAGE_NAME}:${IMAGE_VERSION}."
fi