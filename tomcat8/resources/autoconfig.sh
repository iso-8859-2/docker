#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

CURRENT_PATH=$(cd $(dirname ${0}); pwd)

AUTO_INJECT_PATH=$1

#
# Don`t write "exit ${code}" expression in this script.
#

#
# function auto_config
#
auto_config() {
    if [ -z "${P_APP_ENV}" ]; then
        echo "[`date`] [INFO] Environment variable 'P_APP_ENV' not found, no need auto-config."
        return 0
    fi

    if [ -z "${AUTO_INJECT_JAR}" ]; then
        echo "[`date`] [ERROR] Environment variable 'AUTO_INJECT_JAR' not found."
        return 0
    fi

    if [ ! -f "${AUTO_INJECT_JAR}" ]; then
        echo "[`date`] [ERROR] JAR file ${AUTO_INJECT_JAR} not found."
        return 0
    fi

    if [ -z "${AUTO_INJECT_PATH}" ]; then
        echo "Usage: "
        echo "./${0} /target/directory"
        echo "./${0} /target/file (zip/jar/war)"
        return 0
    fi

    if [ ! -d "${AUTO_INJECT_PATH}" ] && [ ! -f "${AUTO_INJECT_PATH}" ]; then
        echo "[`date`] [ERROR] ${AUTO_INJECT_PATH} is not exists or not a directory."
        return 0
    fi

    AUTO_INJECT_INI=/etc/primeton/autoinject.ini
    if [ -f ${AUTO_INJECT_INI} ]; then
        echo "Application configuration already inject on first bootstrap."
        return 0
    fi

    # execute auto-config, to inject application configuration
    if [ -z "${AUTO_INJECT_MAIN}" ]; then
        # Use jar default main class
        ${JAVA_HOME}/bin/java -server -Xms64m -Xmx512m -Dfile.encoding=utf-8 -DAUTO_INJECT_PATH="${AUTO_INJECT_PATH}" -jar ${AUTO_INJECT_JAR}
    else
        # Use custome main class
        ${JAVA_HOME}/bin/java -server -Xms64m -Xmx512m -Dfile.encoding=utf-8 -DAUTO_INJECT_PATH="${AUTO_INJECT_PATH}" -cp ${AUTO_INJECT_JAR} ${AUTO_INJECT_MAIN}
    fi

    # Marked as injected
    if [ ! -d "/etc/primeton" ]; then
        mkdir /etc/primeton
    fi
    touch ${AUTO_INJECT_INI}
    echo "`date`" >> ${AUTO_INJECT_INI}
}

# execute auto_config
auto_config