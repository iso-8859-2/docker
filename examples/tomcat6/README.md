# example/war3 Docker Image

`------------------------------------------------------------------------`  
`Copyright (c) 2001-2016 Primeton Technologies, Ltd. All rights reserved.`  
  
`Author:	ZhongWen (mailto:lizw@primeton.com)`  
`Last update:	2016-07-22`  
`------------------------------------------------------------------------`
  
  
## Description  
  
Support auto-config while docker run, see docker run usage with "`-e P_APP_ENV`"      
  
  
## Usage  
  
`docker run -d -p 8080:8080 euler-registry.primeton.com/example/war3`
  
`docker run -d -p 8080:8080 euler-registry.primeton.com/example/war3:1.0.0`
  
`docker run -d -p 8080:8080 -e P_APP_ENV="{'title':'Hello World', 'body':'Hello Boby', 'key1':'Primeton', 'key2':true, 'key3':1234, 'key4':1234.56}" euler-registry.primeton.com/example/war3`
  
`docker run -d -p 8080:8080 -e JAVA_OPTS="..." -e P_APP_ENV="{'title':'Hello World', 'body':'Hello Boby', 'key1':'Primeton', 'key2':true, 'key3':1234, 'key4':1234.56}" euler-registry.primeton.com/example/war3`
  
  
## Environment
  
`echo "JAVA_VERSION=${JAVA_VERSION}"`  
`echo "JAVA_HOME=${JAVA_HOME}"`  
`echo "TOMCAT_HOME=${TOMECAT_HOME}"`

`echo "P_APP_ENV=${P_APP_ENV}"`

`if [ -f /etc/primeton/appconfig.properties ]; then more /etc/primeton/appconfig.properties fi`

  