# Tomcat-7.0 Docker Image  
  
`------------------------------------------------------------------------`    
`Copyright (c) 2001-2016 Primeton Technologies, Ltd. All rights reserved.`  
  
`Author:	ZhongWen (mailto:lizw@primeton.com)`  
`Last update:	2016-07-07`  
`------------------------------------------------------------------------`  
  
  
## Usage  
  
### As base image  
Base on tomcat7 docker image to build your webapp image.  

### Run example  
`docker run -d -p 8080:8080 tomcat7:1.0.0`  
`docker run -d -p 8080:8080 -v /root/myapp:/opt/application tomcat7:1.0.0` 
  
## Environment  
  
`echo "JAVA_VERSION=${JAVA_VERSION}"`  
`echo "JAVA_HOME=${JAVA_HOME}"`  
`echo "TOMCAT_HOME=${TOMECAT_HOME}"`  