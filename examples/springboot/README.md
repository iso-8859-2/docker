# example springboot Docker Image
  
`------------------------------------------------------------------------`  
`Copyright (c) 2001-2016 Primeton Technologies, Ltd. All rights reserved.`  
  
`Author:	ZhongWen (mailto:lizw@primeton.com)`   
`Last update:	2016-07-25`  
`------------------------------------------------------------------------`
  
  
## Description  
  
Support auto-config while docker run, see docker run usage with "`-e P_APP_ENV`"      
  
  
## Usage  
  
`docker run -d -p 8080:8080 euler-registry.primeton.com/example/springboot`
  
`docker run -d -p 8080:8080 euler-registry.primeton.com/example/springboot:1.0.0`
  
`docker run -d -p 8080:8080 -e P_APP_ENV="{'v11':'Hello Primeton', 'v12':false, 'v13':123.456, 'v21':'Hello 普元', 'v22':true, 'v23':456.123}" euler-registry.primeton.com/example/springboot`
  
`docker run -d -p 8080:8080 -e JAVA_OPTS="..." -e P_APP_ENV="{'v11':'Hello Primeton', 'v12':false, 'v13':123.456, 'v21':'Hello 普元', 'v22':true, 'v23':456.123}" euler-registry.primeton.com/example/springboot`
  
  
## Environment
  
`echo "JAVA_VERSION=${JAVA_VERSION}"`  
`echo "JAVA_HOME=${JAVA_HOME}"`  
`echo "APP_HOME=${APP_HOME}"`

`echo "P_APP_ENV=${P_APP_ENV}"`

`if [ -f /etc/primeton/appconfig.properties ]; then`  
`more /etc/primeton/appconfig.properties `  
`fi`  
  