#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

CONTEXT_PATH=$(cd $(dirname ${0}); pwd)

if [ -z ${OFFICIAL} ]; then
    OFFICIAL="no"
fi

if [ -z ${PRIMETON} ]; then
    PRIMETON="no"
fi

if [ -z ${COMMON} ]; then
    COMMON="no"
fi

if [ "no" == "${OFFICIAL}" ] && [ "no" == "${PRIMETON}" ] && [ "no" == "${COMMON}" ]; then
    echo "Usage:"
    echo "export OFFICIAL=yes # default no"
    echo "export PRIMETON=yes # default no"
    echo "export COMMON=yes # default no"
    echo "/bin/bash ${0}"
    exit 0
fi

#
# docker hub official images
#
official() {
    IMAGES=(
        registry
        ubuntu
        nginx
        nginx
        mysql
        redis
        sonatype/nexus3
        gitlab/gitlab-ce
        httpd
        node
        nats
    )

    VERSIONS=(
        2
        16.04
        1.8
        1.10
        5.7
        3.2.1
        latest
        latest
        2.4
        6.3
        0.8.1
    )

    LENGTH=${#IMAGES[@]}
    for (( i=0; i<${LENGTH}; i++)) ; do
        /bin/bash ${CONTEXT_PATH}/download.sh --IMAGE_NAME ${IMAGES[${i}]} --IMAGE_VERSION ${VERSIONS[${i}]}
    done
}

#
# Primeton euler images
#
primeton() {
    IMAGES=(
        euler-bpr
        euler-ci
        euler-iam
        euler-mkt
        euler-pfe
        euler-pm
        euler-pse
        euler-scm
        euler-sem
        euler-spm
        euler-srm
        euler-tm
        euler-vcs
    )

    LENGTH=${#IMAGES[@]}
    VERSION=0.2.0
    # VERSION=latest
    for (( i=0; i<${LENGTH}; i++)) ; do
        /bin/bash ${CONTEXT_PATH}/download.sh --IMAGE_NAME ${IMAGES[${i}]} --IMAGE_VERSION ${VERSION} \
            --REGISTRY_URL "euler-registry.primeton.com"
    done
}

#
# Primeton Common
#
common() {
    IMAGES=(
        jenkins
        jdk6
        jdk7
        jdk8
        jre6
        jre7
        jre8
        tomcat6
        tomcat7
        tomcat7j6
        tomcat7j8
        tomcat8
        jetty8
        jetty9
        springboot
        etcd
        etcd2
        etcd3
        rds
    )

    LENGTH=${#IMAGES[@]}
    VERSION=1.0.0
    # VERSION=latest
    for (( i=0; i<${LENGTH}; i++)) ; do
        /bin/bash ${CONTEXT_PATH}/download.sh --IMAGE_NAME ${IMAGES[${i}]} --IMAGE_VERSION ${VERSION} \
            --REGISTRY_URL "euler-registry.primeton.com"
    done
}

#
# Which module be enabled
#

if [ "yes" == "${OFFICIAL}" ]; then
    official
fi

if [ "yes" == "${PRIMETON}" ]; then
    primeton
fi

if [ "yes" == "${COMMON}" ]; then
    common
fi