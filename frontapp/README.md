# frontapp Docker Image  
  
`------------------------------------------------------------------------`  
`Copyright (c) 2001-2016 Primeton Technologies, Ltd. All rights reserved.`  
  
`Author:	ZhongWen (mailto:lizw@primeton.com)`  
`Last update:	2016-07-30`  
`------------------------------------------------------------------------`  
  
  
## Usage:  
  
  
Base on frontapp docker image to build your image.  
  
`FROM euler-registry.primeton.com/frontapp`  
`# Copy resources`  
`ADD ./app/ ${APP_HOME}/`  
`# or`  
`# ADD app.zip /tmp/app.zip`  
`# RUN unzip /tmp/app.zip -d ${APP_HOME} \`  
`#  && rm -f /tmp/app.zip`  
  
  
## App Directory  
  
  
`application.zip`  
`    |- META-INF`  
`    | 	|- autoconf`  
`    | 	| 	|- auto-config.xml`  
`    | 	| 	|- nginx.template`  
`    | 	| 	|- ...`  
`    | 	|- ...`  
`    |- nginx`  
`    |     |- nginx.conf`  
`    |     |- conf.d`  
`    |     |   |-default.conf`  
`    |     |- ...`  
`    |- html`  
`    |     |- index.html`  
`    |     |- images`  
`    |     |   |- ...`  
`    |     |- ...`  
  
  
## Environment  
  
  
`echo "JAVA_VERSION=${JAVA_VERSION}"`  
  
`echo "JAVA_HOME=${JAVA_HOME}"`  
  