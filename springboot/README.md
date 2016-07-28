# springboot Docker Image  
  
`------------------------------------------------------------------------`    
`Copyright (c) 2001-2016 Primeton Technologies, Ltd. All rights reserved.`  
  
`Author:	ZhongWen (mailto:lizw@primeton.com)`  
`Last update:	2016-06-06`  
`------------------------------------------------------------------------`  
  
  
## Usage:  
  
  
Base on springboot docker image to build your image.  
  
### Example  
  
`# Dockerfile`  
`FROM euler-registry.primeton.com/springboot`  
`ADD app.jar ${APP_HOME}/lib/`  
  
`# Dockerfile`  
`FROM euler-registry.primeton.com/springboot`  
`ADD . ${APP_HOME}/`    
  
`# Dockerfile`  
`FROM euler-registry.primeton.com/springboot`  
`ADD app.jar ${APP_HOME}/lib/`  
`# autoconf`  
`ADD META-INF ${APP_HOME}/META-INF`  
  
  
## Environment  
  
  
`echo "JAVA_VERSION=${JAVA_VERSION}"`  
  
`echo "JAVA_HOME=${JAVA_HOME}"`   
   
`echo "APP_HOME=${APP_HOME}"`  
  
`echo "DATA_DIR=${DATA_DIR}"`  
  
   