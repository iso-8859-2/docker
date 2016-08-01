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

ENV JAVA_VERSION=1.7.0_80
ENV JAVA_HOME=/jdk${JAVA_VERSION}
ENV PATH=${PATH}:${JAVA_HOME}/bin

ADD ./resources/jdk-7u80-linux-x64.tar.gz /

RUN rm -f ${JAVA_HOME}/src.zip ${JAVA_HOME}/javafx-src.zip

CMD ["/bin/bash"]
