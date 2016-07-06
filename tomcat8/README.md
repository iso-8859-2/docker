# Tomcat-8.0 Docker Image  
  
`------------------------------------------------------------------------`    
`Copyright (c) 2001-2016 Primeton Technologies, Ltd. All rights reserved.`  
  
`Author:	ZhongWen (mailto:lizw@primeton.com)`  
`Last update:	2016-06-06`  
`------------------------------------------------------------------------`  
  
  
## Usage  
  
### As base image  
Base on tomcat8 docker image to build your webapp image.  

### Run example  
`docker run -d -p 8080:8080 tomcat8:1.0`  
`docker run -d -p 8080:8080 -v /root/myapp:/opt/application tomcat8:1.0` 
  
## Environment  
  
`echo "JAVA_VERSION=${JAVA_VERSION}"`  
`echo "JAVA_HOME=${JAVA_HOME}"`  
`echo "TOMCAT_HOME=${TOMECAT_HOME}"`  