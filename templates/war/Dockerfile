#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#

# FROM euler-registry.primeton.com/tomcat6
# FROM euler-registry.primeton.com/tomcat6:1.0.0
# FROM euler-registry.primeton.com/tomcat7
# FROM euler-registry.primeton.com/tomcat7:1.0.0
# FROM euler-registry.primeton.com/tomcat8
FROM euler-registry.primeton.com/tomcat8:1.0.0
# FROM ${registry.url}/${image.name}:${image.version}

# MAINTAINER www.primeton.com, registry@primeton.com

# If Dockerfile in WAR root directory
ADD . ${TOMCAT_HOME}/webapps/ROOT/

# If WAR no need unpack
# ADD app.war ${TOMCAT_HOME}/webapps/ROOT.war

# If WAR need unpack
# ADD app.war /tmp/ROOT.war
# RUN unzip /tmp/ROOT.war -d ${TOMCAT_HOME}/webapps/ROOT/
