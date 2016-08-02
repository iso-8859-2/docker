# Tomcat-7.0 Docker Image  
  
`------------------------------------------------------------------------`    
`Copyright (c) 2001-2016 Primeton Technologies, Ltd. All rights reserved.`  
  
`Author:	ZhongWen (mailto:lizw@primeton.com)`  
`Last update:	2016-07-22`
`------------------------------------------------------------------------`  
  
  
## Usage  
  
### As base image  
Base on tomcat7 docker image to build your webapp image.  
  
### Dockerfile example
  
`# Example 1`  
`FROM tomcat7:1.0.0`  
`MAINTAINER www.your.org, registry@your.com`  
`ADD resources/app.war ${TOMCAT_HOME}/webapps/ROOT.war`  

`# Example 2`  
`FROM tomcat7:1.0.0`  
`MAINTAINER www.your.org, registry@your.com`  
`ADD resources/app.war /tmp/ROOT.war`  
`RUN unzip /tmp/ROOT.war -d ${TOMCAT_HOME}/webapps/ROOT/ \`  
`   && rm -f /tmp/ROOT.war`   
  
### Run example  
`docker run -d -p 8080:8080 -v ~/myapp/app.war:/tomcat/webapps/ROOT.war tomcat7:1.0.0`
  
`docker run -d -p 8080:8080 -v ~/myapp/app.war:/tomcat/webapps/ROOT.war \`
`-e P_APP_ENV="{'key1':'value1', ..., 'keyn':'valuen'} -e JAVA_OPTS="..." tomcat7:1.0.0`  
  
## Environment  
  
`echo "JAVA_VERSION=${JAVA_VERSION}"`  
`echo "JAVA_HOME=${JAVA_HOME}"`  
`echo "TOMCAT_HOME=${TOMECAT_HOME}"`  
  
`echo "P_APP_ENV=${P_APP_ENV}"`  
  
`# if docker run with environment parameter "-e P_APP_ENV=..."`  
`# will generate autoconfig.properties file`  
`if [ -f /etc/primeton/autoconfig.properties ]; then`  
`cat /etc/primeton/autoconfig.properties; `
`fi`  