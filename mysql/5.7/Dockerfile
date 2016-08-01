#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

FROM mysql:5.7
# FROM euler-registry.primeton.com/mysql:5.7

MAINTAINER www.primeton.com, euler@primeton.com

# localtime
RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ADD ./resources/my.cnf /etc/mysql/conf.d/