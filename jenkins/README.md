# Jenkins Docker image
  
`------------------------------------------------------------------------`    
`Copyright (c) 2001-2016 Primeton Technologies, Ltd. All rights reserved.`  
  
`Author:	ZhongWen (mailto:lizw@primeton.com)`  
`Last update:	2016-07-06`  
`------------------------------------------------------------------------`  
  
  
The Jenkins Continuous Integration and Delivery server.

This is a fully functional Jenkins server, based on the Long Term Support release
[http://jenkins-ci.org/](http://jenkins-ci.org/).


<img src="http://jenkins-ci.org/sites/default/files/jenkins_logo.png"/>


# Usage
  
  
`docker run -p 8080:8080 -p 50000:50000 --privileged euler-registry.primeton.com/jenkins`  
  
NOTE: read below the _build executors_ part for the role of the `50000` port mapping. --privileged for docker-in-docker.

This will store the workspace in /jenkins. All Jenkins data lives in there - including plugins and configuration.
You will probably want to make that a persistent volume (recommended):
  
  
`docker run -d --restart always -p 8080:8080 -p 50000:50000 --privileged -v /your/home:/jenkins euler-registry.primeton.com/jenkins`
  
  
This will store the jenkins data in `/your/home` on the host.
Ensure that `/your/home` is accessible by the jenkins user in container (jenkins user - root) or use `-u some_other_user` parameter with `docker run`.  
  
  
`docker run --privileged --restart always -d -p 8080:8080 -p 50000:50000 -v /some/dir:/jenkins --add-host=euler-registry.primeton.com:10.15.15.172 -e JAVA_OPTS="-Xms1024m -Xmx2048m" euler-registry.primeton.com/jenkins:1.0.0`
  
  
Add insecure docker registry configuration  
  
  
`# Generate ubuntu docker configuration file`  
`echo "DOCKER_OPTS=\"--insecure-registry euler-registry.primeton.com\"" > /some/dir/docker`  
`# Run jenkins image`
`docker run --privileged --restart always -d -p 8080:8080 -p 50000:50000 -v /some/dir/docker:/etc/default/docker -v /some/dir:/jenkins --add-host=euler-registry.primeton.com:10.15.15.172 -e JAVA_OPTS="-Xms1024m -Xmx2048m" euler-registry.primeton.com/jenkins:1.0.0`
  
  
# VOLUME  
  
`/jenkins`  
`/root/.m2`  
`/var/lib/docker`  
  