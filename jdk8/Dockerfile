#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

FROM euler-registry.primeton.com/ubuntu:16.04
# FROM ubuntu:16.04

MAINTAINER www.primeton.com, registry@primeton.com

# set localtime and default language environment
RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# set locale (language)
# RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales
# ENV LC_ALL=en_US.UTF-8
# ENV LANG=en_US.UTF-8
# ENV LANGUAGE=en_US.UTF-8

ENV JAVA_VERSION=1.8.0_92
ENV JAVA_HOME=/opt/programs/jdk${JAVA_VERSION}
ENV PATH=${PATH}:${JAVA_HOME}/bin

ADD ./resources/jdk-8u92-linux-x64.tar.gz /opt/programs/

RUN rm -f ${JAVA_HOME}/src.zip ${JAVA_HOME}/javafx-src.zip

CMD ["/bin/bash"]
