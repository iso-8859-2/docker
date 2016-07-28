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
IMAGE_NAME="jenkins"

NODEJS_FILE="node-v6.2.0-linux-x64.tar.gz"
JENKINS_FILE="jenkins.war"
MAVEN_FILE="apache-maven-3.3.9-bin.tar.gz"

#
# function main
#
main() {
    if [ ! -f "${CONTEXT_PATH}/resources/${MAVEN_FILE}" ] ; then
        curl --fail --location --retry 3 \
        http://mirrors.hust.edu.cn/apache/maven/maven-3/3.3.9/binaries/${MAVEN_FILE} -o ${CONTEXT_PATH}/resources/${MAVEN_FILE}
    fi
    if [ ! -f "${CONTEXT_PATH}/resources/${NODEJS_FILE}" ] ; then
        curl --fail --location --retry 3 \
            https://nodejs.org/dist/v6.2.0/${NODEJS_FILE} -o ${CONTEXT_PATH}/resources/${NODEJS_FILE}
    fi
    # http://ftp.tsukuba.wide.ad.jp/software/jenkins/war/2.14/jenkins.war
    # http://ftp.yz.yamagata-u.ac.jp/pub/misc/jenkins/war/2.14/jenkins.war
    if [ -f "${CONTEXT_PATH}/resources/${JENKINS_FILE}" ] ; then
        rm -f ${CONTEXT_PATH}/resources/${JENKINS_FILE}
    fi
    curl --fail --location --retry 3 \
        http://ftp.yz.yamagata-u.ac.jp/pub/misc/jenkins/war/latest/jenkins.war \
        -o ${CONTEXT_PATH}/resources/${JENKINS_FILE}
    if [ ! -f "${CONTEXT_PATH}/resources/${JENKINS_FILE}" ] ; then
        echo "[`date`] [ERROR] Failed to download jenkins.war."
        exit 1
    fi
}

# docker build/tag/push
source ${CONTEXT_PATH}/../common/template.sh