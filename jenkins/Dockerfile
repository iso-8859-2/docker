#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

FROM euler-registry.primeton.com/jdk8:1.0.0
# FROM jdk8:1.0.0

MAINTAINER www.primeton.com, euler@primeton.com

# Ubuntu apt source
ADD ./resources/sources.list /etc/apt/

RUN apt-get update && apt-get install -y git curl zip unzip wget expect tar ftp iputils-ping

# install docker
# https://docs.docker.com/engine/installation/linux/ubuntulinux/
# RUN apt-get install -y apt-transport-https ca-certificates
# RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# RUN echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list
# RUN apt-get update && apt-get purge lxc-docker && apt-cache policy docker-engine
# RUN apt-get install -y linux-image-extra-$(uname -r)
# RUN apt-get update && apt-get install -y docker-engine
# RUN echo "DOCKER_OPTS=\"--insecure-registry euler-registry.primeton.com\"" >> /etc/default/docker

# environments
ENV JENKINS_HOME=/opt/workspaces/jenkins
ENV JENKINS_SLAVE_AGENT_PORT=50000
ENV PROGRAMS_HOME=/opt/programs
ENV MAVEN_HOME=${PROGRAMS_HOME}/apache-maven-3.3.9
ENV NODE_HOME=${PROGRAMS_HOME}/node-v6.2.0-linux-x64
ENV PATH=${PATH}:${MAVEN_HOME}/bin:${NODE_HOME}/bin

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME ${JENKINS_HOME}

# 8080 for main web interface, 50000 will be used by attached slave agents
EXPOSE 8080 50000

USER root

# install maven, nodejs, jenkins, auto-config
ADD ./resources/apache-maven-3.3.9-bin.tar.gz ${PROGRAMS_HOME}/
ADD ./resources/node-v6.2.0-linux-x64.tar.gz ${PROGRAMS_HOME}/
ADD ./resources/jenkins.war ${PROGRAMS_HOME}/jenkins/
ADD ./resources/entrypoint.sh ${PROGRAMS_HOME}/jenkins/
ADD ./resources/euler-ci-autoconfig.jar ${PROGRAMS_HOME}/autoconfig/

RUN chmod u+x ${PROGRAMS_HOME}/jenkins/entrypoint.sh

ENTRYPOINT ["/bin/sh", "-c", "${PROGRAMS_HOME}/jenkins/entrypoint.sh"]
