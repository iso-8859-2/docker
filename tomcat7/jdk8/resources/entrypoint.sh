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

#
# Java Remote Debug Enable
#
if [ -z "${USE_DEBUG_PORT}" ]; then
    USE_DEBUG_PORT=false
fi

#
# auto-config if exists environment 'P_APP_ENV'
# {"key1": "value1", ..., "keyn": "valuen"}
#
TARGET_PATH=""
if [ -d "${TOMCAT_HOME}/webapps/ROOT" ]; then
    TARGET_PATH="${TOMCAT_HOME}/webapps/ROOT"
elif [ -f "${TOMCAT_HOME}/webapps/ROOT.war" ]; then
    TARGET_PATH="${TOMCAT_HOME}/webapps"
else
    TARGET_PATH="${TOMCAT_HOME}/webapps"
fi
if [ -x ${TOMCAT_HOME}/bin/autoconfig.sh ]; then
    ${TOMCAT_HOME}/bin/autoconfig.sh ${TARGET_PATH}
elif [ -f ${TOMCAT_HOME}/bin/autoconfig.sh ]; then
    /bin/bash ${TOMCAT_HOME}/bin/autoconfig.sh ${TARGET_PATH}
else
    echo "[`date`] [WARN] ${TOMCAT_HOME}/bin/autoconfig.sh not found."
fi

# if [ -z "${JAVA_OPTS}" ]; then
#	echo "Environment variable 'JAVA_OPTS' not found, then use default."
#	JAVA_OPTS="-Xms256m -Xmx2048m"
# fi

# Memory Limit
if [ -z "${MEM_MIN}" ]; then
    MEM_MIN=256
fi
if [ -z "${MEM_MAX}" ]; then
    MEM_MAX=2048
fi
JAVA_OPTS="${JAVA_OPTS} -Xms${MEM_MIN}m -Xmx${MEM_MAX}m"

# Common JVM Settings
JAVA_OPTS="${JAVA_OPTS} -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled"
JAVA_OPTS="${JAVA_OPTS} -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+CMSClassUnloadingEnabled -XX:SurvivorRatio=8"
JAVA_OPTS="${JAVA_OPTS} -XX:+DisableExplicitGC -XX:-OmitStackTraceInFastThrow -Djava.net.preferIPv4Stack=true"
JAVA_OPTS="${JAVA_OPTS} -Dfile.encoding=utf-8"

# Java Remote Debug Enabled
if [ "true" == "${USE_DEBUG_PORT}" ]; then
    JAVA_OPTS="${JAVA_OPTS} -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8888"
fi

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
${JAVA_HOME}/bin/java -server ${JAVA_OPTS} org.apache.catalina.startup.Bootstrap start