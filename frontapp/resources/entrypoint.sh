#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

#
# auto-config if exists environment 'P_APP_ENV'
# {"key1": "value1", ..., "keyn": "valuen"}
#
if [ -x /bin/autoconfig.sh ]; then
    /bin/autoconfig.sh ${APP_HOME}
elif [ -f /bin/autoconfig.sh ]; then
    /bin/bash /bin/autoconfig.sh ${APP_HOME}
else
    echo "[`date`] [WARN] /bin/autoconfig.sh not found."
fi

if [ ! -d ${APP_HOME} ]; then
    mkdir -p ${APP_HOME}
fi

if [ ! -f "${APP_HOME}/nginx.ini" ]; then
    if [ ! -d "/usr/share/nginx/html/" ]; then
        mkdir -p /usr/share/nginx/html/
    fi
    if [ -d "${APP_HOME}/html" ]; then
        cp -rf ${APP_HOME}/html/* /usr/share/nginx/html/
    fi
    if [ -d "${APP_HOME}/nginx" ]; then
        cp -rf ${APP_HOME}/nginx/* /etc/nginx/
    fi
    touch ${APP_HOME}/nginx.ini
    echo -n "`date`" >> ${APP_HOME}/nginx.ini
fi

# run nginx
/usr/sbin/nginx -g "daemon off;"