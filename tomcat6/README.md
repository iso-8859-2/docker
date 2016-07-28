# Tomcat-7.0 Docker Image  
  
`------------------------------------------------------------------------`    
`Copyright (c) 2001-2016 Primeton Technologies, Ltd. All rights reserved.`  
  
`Author:	ZhongWen (mailto:lizw@primeton.com)`  
`Last update:	2016-07-19`  
`------------------------------------------------------------------------`  
  
  
## Usage  
  
### As base image  
Base on tomcat6 docker image to build your webapp image.  
  
### Dockerfile example
  
`# Example 1`  
`FROM tomcat6:1.0.0`  
`MAINTAINER www.your.org, registry@your.com`  
`ADD resources/app.war ${TOMCAT_HOME}/webapps/ROOT.war`  

`# Example 2`  
`FROM tomcat6:1.0.0`  
`MAINTAINER www.your.org, registry@your.com`  
`ADD resources/app.war /tmp/ROOT.war`  
`RUN unzip /tmp/ROOT.war -d ${TOMCAT_HOME}/webapps/ROOT/ \`  
`   && rm -f /tmp/ROOT.war`   
  
### Run example  
`docker run -d -p 8080:8080 -v ~/myapp/app.war:/opt/programs/apache-tomcat-6.0.45/webapps/ROOT.war tomcat6:1.0.0`  
  
## Environment  
  
`echo "JAVA_VERSION=${JAVA_VERSION}"`  
`echo "JAVA_HOME=${JAVA_HOME}"`  
`echo "TOMCAT_HOME=${TOMECAT_HOME}"`  