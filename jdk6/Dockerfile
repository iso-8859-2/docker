#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

FROM euler-registry.primeton.com/ubuntu:16.04
# FROM ubuntu:16.04

MAINTAINER www.primeton.com, registry@primeton.com

RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ENV JAVA_VERSION=1.6.0_45
ENV JAVA_HOME=/opt/programs/jdk${JAVA_VERSION}
ENV PATH=${PATH}:${JAVA_HOME}/bin

ADD ./resources/jdk${JAVA_VERSION}/ /opt/programs/jdk${JAVA_VERSION}/

# RUN rm -f ${JAVA_HOME}/src.zip

CMD ["/bin/bash"]
