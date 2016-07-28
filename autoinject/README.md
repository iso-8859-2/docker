# Tomcat-8.0 Docker Image  
  
`------------------------------------------------------------------------`    
`Copyright (c) 2001-2016 Primeton Technologies, Ltd. All rights reserved.`  
  
`Author:	ZhongWen (mailto:lizw@primeton.com)`  
`Last update:	2016-07-26`  
`------------------------------------------------------------------------`  
  
  
## Package auto-inject-1.0.0-jar-with-dependencies.jar  
  
`mvn clean assembly:assembly -Dmaven.test.skip=true -Dfile.encoding=utf-8`  
`# or execute shell file ./build.sh`  
`/bin/bash ./build.sh`  

## Usage
  
`java -DAUTO_INJECT_PATH="/target/app_home" -jar auto-inject-1.0.0-jar-with-dependencies.jar`

`java -DAUTO_INJECT_PATH="/target/app.jar" -jar auto-inject-1.0.0-jar-with-dependencies.jar`

`java -DAUTO_INJECT_PATH="/target/app.war" -jar auto-inject-1.0.0-jar-with-dependencies.jar`

`java -DAUTO_INJECT_PATH="/target/app.zip" -jar auto-inject-1.0.0-jar-with-dependencies.jar`

## Environment

`echo "P_APP_ENV=${P_APP_ENV}"`


## TestCase in local

### UNIX

`export P_APP_ENV="{'k1':'v1', 'k2':'v2', ...}"`
`java -DAUTO_INJECT_PATH="/target/app.zip" -jar auto-inject-1.0.0-jar-with-dependencies.jar`


### Windows

Setting environment, Windows Desktop -> Computer -> Properties -> Advanced system settings -> Environment variables -> ADD P_APP_ENV veriable.

`# Open win32 command line window`
`java -DAUTO_INJECT_PATH="/target/app.zip" -jar auto-inject-1.0.0-jar-with-dependencies.jar`