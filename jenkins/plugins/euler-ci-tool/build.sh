#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

CONTEXT_PATH=$(cd $(dirname ${0}); pwd)

cd ${CONTEXT_PATH}

if [ -z "`which mvn`" ]; then
    echo "[`date`] [WARN ] apache-maven command mvn not found."
    exit 1
fi

echo "[`date`] [INFO ] Execute 'mvn clean package' to compile euler-ci-tool."
mvn clean package -Dmaven.test.skip=true -Dfile.encoding=utf-8

RUN_JAR="${CONTEXT_PATH}/target/euler-ci-tool-1.0.0-jar-with-dependencies.jar"
if [ -f ${RUN_JAR} ]; then
    cp -f ${RUN_JAR} ${CONTEXT_PATH}/target/euler-ci-tool.jar
else
    echo "[`date`] [ERROR] Failed to compile euler-ci-tool project."
    exit 1
fi