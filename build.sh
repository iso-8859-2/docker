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
    *) echo "Ignore no use key ${1}"; shift 1;;
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

PARAMS="--REGISTRY_URL ${REGISTRY_URL} --PUSH_IMG ${PUSH_IMG} --RM_IMG ${RM_IMG} --LATEST ${LATEST}"

targets="etcd etcd2 etcd3 jre6 jdk6 jre7 jdk7 jre8 jdk8 jenkins tomcat6 tomcat7 tomcat7/jdk6 tomcat7/jdk8 tomcat8 springboot frontapp rds redis mysql/5.7 examples/tomcat6 examples/tomcat7 examples/tomcat8 examples/springboot"
for target in ${targets} ; do
    /bin/bash ${CONTEXT_PATH}/${target}/build.sh ${PARAMS}
done
