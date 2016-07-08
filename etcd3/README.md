# ETCD docker image
  
  
## Usage  
  
`docker run -d -p 12379:12379 -p 12380:12380 -v /your/data:/data --name etcd etcd:1.0.0`  
`docker run -d -p 12379:12379 -p 12380:12380 -v /your/data:/data --name etcd etcd:1.0.0 -name etcd ...`  
  
## References  
  
[https://github.com/coreos/etcd/blob/release-2.3/Documentation/docker_guide.md](https://github.com/coreos/etcd/blob/release-2.3/Documentation/docker_guide.md)  
  
[https://github.com/coreos/etcd/blob/v3.0.1/Documentation/v2/docker_guide.md](https://github.com/coreos/etcd/blob/v3.0.1/Documentation/v2/docker_guide.md)  
  
[https://github.com/coreos/etcd/releases/tag/v3.0.1](https://github.com/coreos/etcd/releases/tag/v3.0.1)  
  
[https://quay.io/repository/coreos/etcd?tab=tags](https://quay.io/repository/coreos/etcd?tab=tags)  
  