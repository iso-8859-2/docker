#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

CONTEXT_PATH=$(cd $(dirname ${0}); pwd)

# parse args
while [ -n "${1}" ]; do
  case "${1}" in
  --REGISTRY_URL) REGISTRY_URL="${2}"; shift 2;;
  --PUSH_IMG) PUSH_IMG="${2}"; shift 2;;
  --RM_IMG) RM_IMG="${2}"; shift 2;;
  --LATEST) LATEST="${2}"; shift 2;;
  --TARGET) TARGET="${2}"; shift 2;;
  *) echo "Skip key ${1}"; shift 1;;
  esac
done

if [ -z "${REGISTRY_URL}" ]; then
    REGISTRY_URL="euler-registry.primeton.com"
fi
if [ -z "${PUSH_IMG}" ]; then
    PUSH_IMG="no"
fi
if [ -z "${RM_IMG}" ]; then
    RM_IMG="no"
fi
if [ -z "${LATEST}" ]; then
    LATEST="no"
fi
if [ -z "${TARGET}" ]; then
    exit 0
fi

/bin/bash ${CONTEXT_PATH}/${TARGET}/build.sh --REGISTRY_URL ${REGISTRY_URL} --PUSH_IMG ${PUSH_IMG} --RM_IMG ${RM_IMG} --LATEST ${LATEST}
