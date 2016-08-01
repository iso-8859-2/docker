#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

FROM euler-registry.primeton.com/jdk6
# FROM euler-registry.primeton.com/jdk6:1.0.0
# FROM jdk6
# FROM jdk6:1.0.0

MAINTAINER www.primeton.com, registry@primeton.com

ENV TOMCAT_VERSION=7.0.70
ENV TOMCAT_HOME=/tomcat
ENV APP_HOME=${TOMCAT_HOME}/webapps/ROOT
ENV EULER_CI_TOOL=/usr/lib/euler-ci-tool.jar
ENV SERVICE_PORT=8080
ENV DEBUG_PORT=8888

ADD ./resources/apache-tomcat-${TOMCAT_VERSION}.tar.gz /tmp/
RUN mv -f /tmp/apache-tomcat-${TOMCAT_VERSION} ${TOMCAT_HOME}

ADD ./resources/entrypoint.sh ${TOMCAT_HOME}/bin/
ADD ./resources/autoconfig.sh ${TOMCAT_HOME}/bin/
ADD ./resources/euler-ci-tool.jar ${EULER_CI_TOOL}
# Ubuntu apt source
ADD ./resources/sources.list /etc/apt/

# unzip tool for unpackage war file to ROOT application directory
RUN apt-get update \
    && apt-get install -y unzip \
    && chmod +x ${TOMCAT_HOME}/bin/entrypoint.sh ${TOMCAT_HOME}/bin/autoconfig.sh \
    && rm -rf ${TOMCAT_HOME}/webapps/*

# In your Dockerfile
# ADD ./resources/app.war ${TOMCAT_HOME}/webapps/ROOT.war
# or
# ADD ./resources/app.war /tmp/ROOT.war
# RUN unzip /tmp/ROOT.war -d ${TOMCAT_HOME}/webapps/ROOT/

# If need debug, docker run with param "-p 8888:8888 -e JAVA_OPTS='-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8888'"
# or "-p 8888:8888 -e USE_DEBUG_PORT=true"
# listen 8080, debug 8888
EXPOSE ${SERVICE_PORT} ${DEBUG_PORT}

ENTRYPOINT ["/bin/sh", "-c", "${TOMCAT_HOME}/bin/entrypoint.sh"]