#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

CONTEXT_PATH=$(cd $(dirname ${0}); pwd)

REGISTRY_URL="registry.primeton.com"

PUSH_IMG="no"
RM_IMG="no"
LATEST="no"

PARAMS="--REGISTRY_URL ${REGISTRY_URL} --PUSH_IMG ${PUSH_IMG} --RM_IMG ${RM_IMG} --LATEST ${LATEST}"

/bin/bash ${CONTEXT_PATH}/jre8/build.sh ${PARAMS}

/bin/bash ${CONTEXT_PATH}/jdk8/build.sh ${PARAMS}

/bin/bash ${CONTEXT_PATH}/tomcat8/build.sh ${PARAMS}