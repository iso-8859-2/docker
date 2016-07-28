#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#
 
CURRENT_PATH=$(cd $(dirname ${0}); pwd)
 
if [ -z "${APP_HOME}" ]; then
    APP_HOME=${CURRENT_PATH}
fi
if [ -z "${DATA_DIR}" ]; then
    DATA_DIR=${CURRENT_PATH}/work
fi
if [ ! -d ${DATA_DIR} ]; then
    mkdir -p ${DATA_DIR}
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
if [ -x ${CURRENT_PATH}/autoconfig.sh ]; then
    ${CURRENT_PATH}/autoconfig.sh ${APP_HOME}
elif [ -f ${CURRENT_PATH}/autoconfig.sh ]; then
    /bin/bash ${CURRENT_PATH}/autoconfig.sh ${APP_HOME}
else
    echo "[`date`] [WARN] ${CURRENT_PATH}/autoconfig.sh not found."
fi

TARGET_DIR=${APP_HOME}
if [ -d ${APP_HOME}/lib ]; then
    TARGET_DIR=${APP_HOME}/lib
fi

RUNJAR=${APP_HOME}/lib/bootstrap.jar
if [ ! -f ${RUNJAR} ]; then
	for f in `find ${TARGET_DIR} -name "*.jar"`
	do
		RUNJAR=${f}
		break
	done
fi

if [ -f ${RUNJAR} ]; then
    echo "[INFO ] Use jar file ${RUNJAR} as bootstrap."
else
    echo "[Error] Bootstrap jar file ${RUNJAR} not found."
    exit 0
fi

# JAVA_OPTS
# if [ -z "${JAVA_OPTS}" ]; then
#    JAVA_OPTS="-Xms256m -Xmx2048m"
#    echo "[WARN ] JAVA_OPTS environment variable not set, use default JAVA_OPTS=${JAVA_OPTS}"
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
JAVA_OPTS="${JAVA_OPTS} -DDATA_DIR=${DATA_DIR} -DAPP_HOME=${APP_HOME}"
JAVA_OPTS="${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom"
echo "JAVA_OPTS=${JAVA_OPTS}"
# JAVA_HOME
if [ -z "${JAVA_HOME}" ] || [ ! -d ${JAVA_HOME} ]; then
    echo "[Error] JAVA_HOME environment variable not set or not exists."
    exit 0
fi

# start command
CMD="${JAVA_HOME}/bin/java -server ${JAVA_OPTS} -jar ${RUNJAR}"

# spring-boot external-config reference documents
# http://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-external-config.html
# conf/application.yml
CONF_FILE="${APP_HOME}/conf/application.yml"
if [ -f "${CONF_FILE}" ]; then
    echo "[INFO ] Springboot application configuration file ${CONF_FILE} exists, then use it as bootstrap configuration."
    CMD="${CMD} --spring.config.location=file://${CONF_FILE}"
else
    # conf/application.properties
    CONF_FILE="${APP_HOME}/conf/application.properties"
    if [ -f "${CONF_FILE}" ]; then
        echo "[INFO ] Springboot application configuration file ${CONF_FILE} exists, then use it as bootstrap configuration."
        CMD="${CMD} --spring.config.location=file://${CONF_FILE}"
    fi
fi
echo "[INFO ] CMD=${CMD}"
 
# execute start command
${CMD}