#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

EXIT="no"

systemctl enable docker.service

while [ "${EXIT}" == "no" ]; do
    if [ -z "`ps -ef | grep docker | grep daemon`" ]; then
        # nohup wrapdocker >> /dev/stdout &
        service docker start
    fi
    sleep 10
done