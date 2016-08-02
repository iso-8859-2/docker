#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

FROM euler-registry.primeton.com/jdk7

MAINTAINER www.primeton.com, registry@primeton.com

#
# http://www.eclipse.org/jetty/download.html
#

ENV JETTY_VERSION=8.1.19.v20160209
ENV JETTY_HOME=/jetty
ENV APP_HOME=${JETTY_HOME}/webapps/ROOT
ENV EULER_CI_TOOL=/usr/lib/euler-ci-tool.jar
ENV SERVICE_PORT=8080
ENV DEBUG_PORT=8888

# If need debug, docker run with param "-p 8888:8888 -e JAVA_OPTS='-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8888'"
# or "-p 8888:8888 -e USE_DEBUG_PORT=true"
# listen 8080, debug 8888
EXPOSE ${SERVICE_PORT} ${DEBUG_PORT}

ADD ./resources/jetty-distribution-${JETTY_VERSION}.tar.gz /tmp/
RUN mv /tmp/jetty-distribution-${JETTY_VERSION} ${JETTY_HOME}/ \
    && rm -rf ${JETTY_HOME}/webapps/*.war \
    && rm -rf ${JETTY_HOME}/contexts/* \
    && rm -rf ${JETTY_HOME}/contexts-available/* \
    && rm -rf ${JETTY_HOME}/javadoc

ADD ./resources/entrypoint.sh ${JETTY_HOME}/bin/
ADD ./resources/autoconfig.sh ${JETTY_HOME}/bin/
ADD ./resources/euler-ci-tool.jar ${EULER_CI_TOOL}
ADD ./resources/sources.list /etc/apt/

RUN apt-get update \
    && apt-get install -y unzip \
    && chmod +x ${JETTY_HOME}/bin/entrypoint.sh ${JETTY_HOME}/bin/autoconfig.sh

ENTRYPOINT ["/bin/sh", "-c", "${JETTY_HOME}/bin/entrypoint.sh"]
