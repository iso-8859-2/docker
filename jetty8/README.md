# Jetty-8 Docker Image
  
`------------------------------------------------------------------------`    
`Copyright (c) 2001-2016 Primeton Technologies, Ltd. All rights reserved.`  
  
`Author:	ZhongWen (mailto:lizw@primeton.com)`  
  
`Last update:	2016-08-02`  
`------------------------------------------------------------------------`  
  
  
## Usage  
  
### As base image  
Base on jetty8 docker image to build your webapp image.
  
### Dockerfile example
  
`# Example 1`  
`FROM jetty8:1.0.0`
`MAINTAINER www.your.org, registry@your.com`  
`ADD resources/app.war ${JETTY_HOME}/webapps/ROOT.war`  

`# Example 2`  
`FROM jetty8:1.0.0`
`MAINTAINER www.your.org, registry@your.com`  
`ADD resources/app.war /tmp/ROOT.war`  
`RUN unzip /tmp/ROOT.war -d ${JETTY_HOME}/webapps/ROOT/ \`  
`   && rm -f /tmp/ROOT.war`   
  
### Run example  
`docker run -d -p 8080:8080 -v ~/myapp/app.war:/jetty/webapps/ROOT.war jetty8:1.0.0`
  
## Environment  
  
`echo "JAVA_VERSION=${JAVA_VERSION}"`  
`echo "JAVA_HOME=${JAVA_HOME}"`  
`echo "JETTY_HOME=${JETTY_HOME}"`  
`echo "JETTY_VERSION=${JETTY_VERSION}"`  
`echo "APP_HOME=${APP_HOME}"`  