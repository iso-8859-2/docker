#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

# https://hub.docker.com/_/nginx/

FROM euler-registry.primeton.com/frontapp
# FROM euler-registry.primeton.com/frontapp:1.0.0

# MAINTAINER www.primeton.com, euler@primeton.com

#
# app.zip
#
# |- META-INF
# |     |-autoconf
# |     |   |- auto-config.xml
# |     |   |- nginx.conf.template
# |     |   |- ...
# |- nginx
# |     |- nginx.conf
# |     |- conf.d
# |     |   |-default.conf
# |     |- ...
# |- html
# |     |- index.html
# |     |- images
# |     |   |- ...
# |     |- ...
#


# Add html/js/etc. static resource files
ADD . ${APP_HOME}

# or
ADD ./html/ ${APP_HOME}/html/
ADD ./META-INF ${APP_HOME}/META-INF/
ADD ./nginx/ ${APP_HOME}/nginx/

# ADD app.zip /tmp/
# RUN unzip /tmp/app.zip -d ${APP_HOME}/ \
#   && rm -f /tmp/app.zip
