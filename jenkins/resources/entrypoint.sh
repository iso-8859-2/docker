#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

if [ -z "${JENKINS_WORK}" ]; then
    JENKINS_WORK="/jenkins"
fi

if [ -z "${JAVA_OPTS}" ]; then
    JAVA_OPTS="-Xms256m -Xmx1024m"
    echo "[WARN ] JAVA_OPTS environment variable not set, use default JAVA_OPTS=${JAVA_OPTS}"
fi

#
# Common JVM settings
#
JAVA_OPTS="${JAVA_OPTS} -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=70"
JAVA_OPTS="${JAVA_OPTS} -XX:+CMSParallelRemarkEnabled -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+CMSClassUnloadingEnabled"
JAVA_OPTS="${JAVA_OPTS} -XX:SurvivorRatio=8 -XX:+DisableExplicitGC -XX:-OmitStackTraceInFastThrow"
JAVA_OPTS="${JAVA_OPTS} -Djava.net.preferIPv4Stack=true -Dfile.encoding=utf-8"

#
# Jenkins workspace setting
#
JAVA_OPTS="${JAVA_OPTS} -DJENKINS_HOME=${JENKINS_WORK}"

if [ ! -f ${JENKINS_HOME}/jenkins.war ]; then
    echo "${JENKINS_HOME}/jenkins.war not found."
    exit 1
fi

# run docker daemon process
# nohup wrapdocker >> /dev/null &
# nohup wrapdocker >> /dev/stdout &

# if docker shutdown will auto start
# nohup health.sh >> /dev/stdout &

# systemctl enable docker.service
service docker start

echo "JAVA_OPTS=${JAVA_OPTS}"

${JAVA_HOME}/bin/java ${JAVA_OPTS} -jar ${JENKINS_HOME}/jenkins.war

