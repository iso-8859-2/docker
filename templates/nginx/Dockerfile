#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

# https://hub.docker.com/_/nginx/

FROM euler-registry.primeton.com/nginx:1.10
# FROM euler-registry.primeton.com/nginx
# FROM ${registry.url}/${image.name}:${image.version}
# FROM ${registry.url}/${image.name}

# MAINTAINER www.primeton.com, euler@primeton.com

# local time region
RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && mv /etc/nginx/nginx.conf /etc/nginx/nginx-origin.conf

#
# app.zip
#
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

# If Dockerfile in app.zip ROOT directory
# Add nginx configuration file
ADD ./nginx/nginx.conf /etc/nginx/
ADD ./nginx/conf.d/default.conf /etc/nginx/conf.d/

# Add html/js/etc. static resource files
ADD ./html/ /usr/share/nginx/html/

# ADD app.zip /tmp/
# RUN unzip /tmp/app.zip -d /tmp/app/ \
#    && mkdir -p /usr/share/nginx/html/ \
#    && cp -rf /tmp/app/html/* /usr/share/nginx/html/ \
#    && cp -rf /tmp/app/nginx/* /etc/nginx/ \
#    && rm -rf /tmp/app
