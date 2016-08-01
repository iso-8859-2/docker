#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

FROM euler-registry.primeton.com/jdk8
# FROM jdk8:1.0.0

MAINTAINER www.primeton.com, euler@primeton.com

# environments
ENV JENKINS_SLAVE_AGENT_PORT=50000
# jenkins_home, data directory
ENV JENKINS_WORK=/jenkins
# jenkins programs, jenkins.war, entrypoint.sh
ENV JENKINS_HOME=/opt/jenkins
ENV MAVEN_HOME=/opt/apache-maven-3.3.9
ENV NODE_HOME=/opt/node-v6.2.0-linux-x64
ENV PATH=${PATH}:${MAVEN_HOME}/bin:${NODE_HOME}/bin

# jenkins job need this environment variables
ENV EULER_CI_TOOL=/usr/lib/euler-ci-tool.jar
ENV AUTO_CONF_MAIN_CLASS="com.primeton.euler.ci.tool.AutoConfigMain"
ENV POM_RELEASE_MAIN_CLASS="com.primeton.euler.ci.tool.PomReleaseConvertMain"

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME ${JENKINS_WORK}

# Maven local repository
VOLUME /root/.m2

# Define additional metadata for our image.
VOLUME /var/lib/docker

# 8080 for main web interface, 50000 will be used by attached slave agents
EXPOSE 8080 50000

USER root

# install maven, nodejs, jenkins, auto-config
ADD ./resources/apache-maven-3.3.9-bin.tar.gz /opt/
ADD ./resources/node-v6.2.0-linux-x64.tar.gz /opt/
ADD ./resources/jenkins.war ${JENKINS_HOME}/
ADD ./resources/entrypoint.sh ${JENKINS_HOME}/
# ADD ./resources/wrapdocker /usr/local/bin/wrapdocker
# ADD ./resources/health.sh /usr/local/bin/health.sh
ADD ./resources/euler-ci-tool.jar ${EULER_CI_TOOL}
# Ubuntu apt source
ADD ./resources/sources.list /etc/apt/

# RUN chmod +x /usr/local/bin/wrapdocker /usr/local/bin/health.sh \
#    ${JENKINS_HOME}/entrypoint.sh

RUN apt-get update && apt-get install -y git curl zip unzip wget expect tar ftp iputils-ping apt-transport-https ca-certificates lxc iptables dmsetup

# docker-in-docker
# https://github.com/jpetazzo/dind

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

# RUN echo "DOCKER_OPTS=\"--insecure-registry euler-registry.primeton.com\"" >> /etc/default/docker

# https://docs.docker.com/engine/installation/linux/ubuntulinux/
# RUN apt-get install -y apt-transport-https ca-certificates
# RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# RUN echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list
# RUN apt-get update && apt-get purge lxc-docker && apt-cache policy docker-engine
# RUN apt-get install -y linux-image-extra-$(uname -r)
# RUN apt-get update && apt-get install -y docker-engine
# RUN echo "DOCKER_OPTS=\"--insecure-registry euler-registry.primeton.com\"" >> /etc/default/docker

RUN chmod +x ${JENKINS_HOME}/entrypoint.sh && systemctl enable docker.service

ENTRYPOINT ["/bin/sh", "-c", "${JENKINS_HOME}/entrypoint.sh"]
