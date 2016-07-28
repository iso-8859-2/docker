#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#

FROM euler-registry.primeton.com/springboot
# FROM euler-registry.primeton.com/springboot:1.0.0
# FROM ${registry.url}/${image.name}:${image.version}

# MAINTAINER www.primeton.com, registry@primeton.com

# If Dockerfile in zip ROOT directory
ADD *.jar ${APP_HOME}/lib/

# If Dockerfile not in zip package
# ADD ./app.zip  /tmp/app.zip
# RUN unzip /tmp/app.zip -d ${APP_HOME} && rm -f /tmp/app.zip