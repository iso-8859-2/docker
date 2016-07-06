#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

# FROM registry.primeton.com/jdk8:1.0
FROM jdk8:1.0

MAINTAINER www.primeton.com, registry@primeton.com

ENV TOMCAT_HOME=/opt/programs/apache-tomcat-8.0.35
ADD ./resources/apache-tomcat-8.0.35.tar.gz /opt/programs/
ADD ./resources/entrypoint.sh ${TOMCAT_HOME}/bin

RUN chmod +x ${TOMCAT_HOME}/bin/entrypoint.sh && rm -rf ${TOMCAT_HOME}/webapps/* && mkdir ${TOMCAT_HOME}/webapps/ROOT && ln -sf ${TOMCAT_HOME}/webapps/ROOT /opt/application

EXPOSE 8080

VOLUME /opt/application

ENTRYPOINT ["/bin/sh", "-c", "${TOMCAT_HOME}/bin/entrypoint.sh"]