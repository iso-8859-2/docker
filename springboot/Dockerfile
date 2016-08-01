#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

FROM euler-registry.primeton.com/jre8

MAINTAINER www.primeton.com, euler@primeton.com

ENV APP_HOME="/app"
ENV DATA_DIR="${APP_HOME}/work"
ENV EULER_CI_TOOL=/usr/lib/euler-ci-tool.jar
ENV SERVICE_PORT=8080
ENV DEBUG_PORT=8888

VOLUME ${DATA_DIR}

USER root

# RUN:8080, DEBUG:8888
EXPOSE ${SERVICE_PORT} ${DEBUG_PORT}

ADD ./Dockerfile /
ADD ./resources/entrypoint.sh ${APP_HOME}/bin/
ADD ./resources/autoconfig.sh ${APP_HOME}/bin/
ADD ./resources/euler-ci-tool.jar ${EULER_CI_TOOL}

RUN chmod +x ${APP_HOME}/bin/entrypoint.sh ${APP_HOME}/bin/autoconfig.sh

ENTRYPOINT ["/bin/bash", "-c", "${APP_HOME}/bin/entrypoint.sh"]
