#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

FROM euler-registry.primeton.com/ubuntu:16.04
# FROM ubuntu:16.04

MAINTAINER www.primeton.com, registry@primeton.com

ADD ./resources/etcd-v2.3.7-linux-amd64.tar.gz /tmp/

RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && cp -f /tmp/etcd-v2.3.7-linux-amd64/etcd* /usr/bin/ \
    && rm -rf /tmp/etcd-v2.3.7-linux-amd64

EXPOSE 12379 12380

VOLUME /data

CMD ["/usr/bin/etcd", "--data-dir", "/data"]
