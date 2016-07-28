#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

if [ -z "${JENKINS_HOME}" ]; then
    JENKINS_HOME=~/jenkins_home
fi

if [ -z "${JAVA_OPTS}" ]; then
    JAVA_OPTS="-Xms256m -Xmx1024m"
    echo "[WARN ] JAVA_OPTS environment variable not set, use default JAVA_OPTS=${JAVA_OPTS}"
fi

#
# Common JVM settings
#
JAVA_OPTS="${JAVA_OPTS} -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:CMSInitiatingOccupancyFraction=70"
JAVA_OPTS="${JAVA_OPTS} -XX:+CMSParallelRemarkEnabled -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+CMSClassUnloadingEnabled"
JAVA_OPTS="${JAVA_OPTS} -XX:SurvivorRatio=8 -XX:+DisableExplicitGC -XX:-OmitStackTraceInFastThrow"
JAVA_OPTS="${JAVA_OPTS} -Djava.net.preferIPv4Stack=true -Dfile.encoding=utf-8"

#
# Jenkins workspace setting
#
JAVA_OPTS="${JAVA_OPTS} -DJENKINS_HOME=${JENKINS_HOME}"

JENKINS_WAR=${PROGRAMS_HOME}/jenkins/jenkins.war
if [ ! -f ${JENKINS_WAR} ]; then
    echo "${JENKINS_WAR} not found."
    exit 0
fi

# run docker daemon
nohup wrapdocker >> /dev/null &

CMD="${JAVA_HOME}/bin/java -server ${JAVA_OPTS} -jar ${JENKINS_WAR}"
echo ${CMD}
${CMD}

