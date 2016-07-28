#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

#
# Check the container main process is started normally. Invoked by docker entrypoint.sh on container startup.
#

CURRENT_PATH=$(cd $(dirname ${0}); pwd)

# Master Process Service Port
SERVICE_PORT=$1
# Check service timeout
TIMEOUT=$2

if [ -z "${SERVICE_PORT}" ]; then
    SERVICE_PORT=8080
    echo "[`date`] [WARN ] Use default SERVICE_PORT=${SERVICE_PORT}"
fi
echo "[`date`] [INFO ] SERVICE_PORT=${SERVICE_PORT}"

if [ -z "${TIMEOUT}" ]; then
    TIMEOUT=60
    echo "[`date`] [WARN ] Use default TIMEOUT=${TIMEOUT}"
fi

PID_FILE=/var/run/app/pid
if [ ! -d /var/run/app ]; then
    mkdir -p /var/run/app
fi

#
# Compute Service PID
#
PID=`ps -ef | grep java | grep -v grep | awk '{print $2}'`
echo "[`date`] [INFO ] Container master service PID ${PID}."

if [ -z "`which curl`" ]; then
    echo "[`date`] [ERROR] curl command should be installed in container."
    exit 1
fi

# Compute HTTP status code
# curl -I http://www.baidu.com 2>/dev/null | head -n 1 | cut -d$' ' -f2
# curl -s -o /dev/null -I -w "%{http_code}" http://www.baidu.com/

# status=`curl --retry 2 -I -m 20 -o /dev/null -s -w %{http_code}  ${target_url}`
STATUS_CODE=`curl --retry 10 -I -m ${TIMEOUT} -o /dev/stdout -s -w %{http_code}  http://127.0.0.1:${SERVICE_PORT}`
if [ "200" == "${STATUS_CODE}" ]; then
    touch ${PID_FILE}
    echo -n "${PID}" > ${PID_FILE}
else
    echo "[`date`] [ERROR] Call local service http://127.0.0.1:${SERVICE_PORT} response code ${STATUS_CODE}"
fi