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

`docker run -p 8080:8080 -p 50000:50000 euler-registry.primeton.com/jenkins`  
  
NOTE: read below the _build executors_ part for the role of the `50000` port mapping.

This will store the workspace in /opt/jenkins_home. All Jenkins data lives in there - including plugins and configuration.
You will probably want to make that a persistent volume (recommended):
  
`docker run -d --restart always -p 8080:8080 -p 50000:50000 -v /your/home:/opt/workspaces/jenkins euler-registry.primeton.com/jenkins`  
  
  
This will store the jenkins data in `/your/home` on the host.
Ensure that `/your/home` is accessible by the jenkins user in container (jenkins user - root) or use `-u some_other_user` parameter with `docker run`.
  
  