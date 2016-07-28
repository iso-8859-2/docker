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

ENV TOMCAT_HOME=/opt/programs/apache-tomcat-6.0.45
ENV AUTO_INJECT_JAR=/opt/programs/auto-inject.jar

ADD ./resources/apache-tomcat-6.0.45.tar.gz /opt/programs/
ADD ./resources/entrypoint.sh ${TOMCAT_HOME}/bin
ADD ./resources/autoconfig.sh ${TOMCAT_HOME}/bin/
ADD ./resources/auto-inject.jar /opt/programs/
# Ubuntu apt source
ADD ./resources/sources.list /etc/apt/

# unzip tool for unpackage war file to ROOT application directory
RUN apt-get update \
    && apt-get install -y unzip \
    && chmod +x ${TOMCAT_HOME}/bin/entrypoint.sh \
    && chmod +x ${TOMCAT_HOME}/bin/autoconfig.sh \
    && rm -rf ${TOMCAT_HOME}/webapps/*

# In your Dockerfile
# ADD ./resources/app.war ${TOMCAT_HOME}/webapps/ROOT.war
# or
# ADD ./resources/app.war /tmp/ROOT.war
# RUN unzip /tmp/ROOT.war -d ${TOMCAT_HOME}/webapps/ROOT/

# If need debug, docker run with param "-e JAVA_OPTS='-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8888'"
# listen 8080, debug 8888
EXPOSE 8080 8888

ENTRYPOINT ["/bin/sh", "-c", "${TOMCAT_HOME}/bin/entrypoint.sh"]