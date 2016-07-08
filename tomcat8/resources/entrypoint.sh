#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

if [ -z ${TOMCAT_HOME} ]; then
	echo "Error, TOMCAT_HOME environment variable not found."
	exit 0
fi

if [ -z "${JAVA_OPTS}" ]; then
	echo "Environment variable 'JAVA_OPTS' not found, then use default."
	JAVA_OPTS="-Xms256m -Xmx2048m"
fi

JAVA_OPTS="${JAVA_OPTS} -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+CMSClassUnloadingEnabled -XX:SurvivorRatio=8 -XX:+DisableExplicitGC -XX:-OmitStackTraceInFastThrow -Djava.net.preferIPv4Stack=true"

echo "JAVA_HOME=${JAVA_HOME}"

JAVA_OPTS="${JAVA_OPTS} -Djava.util.logging.config.file=${TOMCAT_HOME}/conf/logging.properties"
JAVA_OPTS="${JAVA_OPTS} -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager"
JAVA_OPTS="${JAVA_OPTS} -Djava.endorsed.dirs=${TOMCAT_HOME}/endorsed"
JAVA_OPTS="${JAVA_OPTS} -Dcatalina.base=${TOMCAT_HOME}"
JAVA_OPTS="${JAVA_OPTS} -Dcatalina.home=${TOMCAT_HOME}"
JAVA_OPTS="${JAVA_OPTS} -Djava.io.tmpdir=${TOMCAT_HOME}/temp"
JAVA_OPTS="${JAVA_OPTS} -classpath ${TOMCAT_HOME}/bin/bootstrap.jar:${TOMCAT_HOME}/bin/tomcat-juli.jar"

# CMD="${JAVA_HOME}/bin/java ${JAVA_OPTS} org.apache.catalina.startup.Bootstrap start"
# echo ${CMD}
# ${CMD}
${JAVA_HOME}/bin/java ${JAVA_OPTS} org.apache.catalina.startup.Bootstrap start