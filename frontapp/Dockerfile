#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

FROM euler-registry.primeton.com/nginx:1.10
# FROM nginx:1.10

MAINTAINER www.primeton.com, registry@primeton.com

ENV JAVA_VERSION=1.6.0_45
ENV JAVA_HOME=/jre${JAVA_VERSION}
ENV PATH=${PATH}:${JAVA_HOME}/bin
ENV EULER_CI_TOOL=/usr/lib/euler-ci-tool.jar
ENV SERVICE_PORT=80
ENV APP_HOME=/app

ADD ./resources/jre${JAVA_VERSION}/ /jre${JAVA_VERSION}/
ADD ./resources/entrypoint.sh /bin/
ADD ./resources/autoconfig.sh /bin/
ADD ./resources/euler-ci-tool.jar ${EULER_CI_TOOL}

RUN chmod +x /bin/entrypoint.sh /bin/autoconfig.sh

ENTRYPOINT ["/bin/bash", "-c", "/bin/entrypoint.sh"]

