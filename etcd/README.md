# ETCD docker image
  
  
## Usage  
  
`docker run -d -p 12379:12379 -p 12380:12380 -v /your/data:/data --name etcd etcd:1.0.0`  
`docker run -d -p 12379:12379 -p 12380:12380 -v /your/data:/data --name etcd etcd:1.0.0 -name etcd ...`  
  