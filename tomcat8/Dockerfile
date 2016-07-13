#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

FROM euler-registry.primeton.com/jdk8:1.0.0
# FROM jdk8:1.0.0

MAINTAINER www.primeton.com, registry@primeton.com

ENV TOMCAT_HOME=/opt/programs/apache-tomcat-8.0.35

ADD ./resources/apache-tomcat-8.0.35.tar.gz /opt/programs/
ADD ./resources/entrypoint.sh ${TOMCAT_HOME}/bin

# unzip tool for unpackage war file to ROOT application directory
RUN apt-get install -y unzip \
    && chmod +x ${TOMCAT_HOME}/bin/entrypoint.sh \
    && rm -rf ${TOMCAT_HOME}/webapps/* \
    && mkdir ${TOMCAT_HOME}/webapps/ROOT \
    && ln -sf ${TOMCAT_HOME}/webapps/ROOT /opt/application

# If need debug, docker run with param "-e JAVA_OPTS='-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8888'"
# listen 8080, debug 8888
EXPOSE 8080 8888

VOLUME /opt/application

ENTRYPOINT ["/bin/sh", "-c", "${TOMCAT_HOME}/bin/entrypoint.sh"]