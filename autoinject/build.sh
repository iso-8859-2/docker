#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

CONTEXT_PATH=$(cd $(dirname ${0}); pwd)

cd ${CONTEXT_PATH}

echo "[`date`] [INFO ] Execute 'mvn clean assembly:assembly' to compile auto-inject."
mvn clean assembly:assembly -Dmaven.test.skip=true -Dfile.encoding=utf-8

RUN_JAR="${CONTEXT_PATH}/target/auto-inject-1.0.0-jar-with-dependencies.jar"
if [ -f ${RUN_JAR} ]; then
    cp -f ${RUN_JAR} ${CONTEXT_PATH}/target/auto-inject.jar
else
    echo "[`date`] [ERROR] Failed to compile auto-inject project."
    exit 1
fi