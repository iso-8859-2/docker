#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

FROM euler-registry.primeton.com/jre8

MAINTAINER www.primeton.com, euler@primeton.com

ENV APP_HOME="/opt/programs/application"
ENV DATA_DIR="${APP_HOME}/work"
ENV AUTO_INJECT_JAR=/opt/programs/auto-inject.jar

VOLUME ${DATA_DIR}

USER root

# RUN:8080, DEBUG:8888
EXPOSE 8080 8888

ADD ./resources/entrypoint.sh ${APP_HOME}/bin/
ADD ./resources/autoconfig.sh ${APP_HOME}/bin/
ADD ./resources/auto-inject.jar /opt/programs/

RUN chmod +x ${APP_HOME}/bin/entrypoint.sh ${APP_HOME}/bin/autoconfig.sh

ENTRYPOINT ["/bin/bash", "-c", "${APP_HOME}/bin/entrypoint.sh"]
