#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

CONTEXT_PATH=$(cd $(dirname ${0}); pwd)

if [ -z ${EXPORT_IMAGE_PATH} ]; then
	EXPORT_IMAGE_PATH=${CONTEXT_PATH}/../target
	mkdir -p ${EXPORT_IMAGE_PATH}
fi
if [ ! -d ${EXPORT_IMAGE_PATH} ]; then
	mkdir -p ${EXPORT_IMAGE_PATH}
fi

for x in $(docker images -q); do
	i=0
	for y in $(docker images | grep "${x}"); do
		if [ ${i} -eq 0 ]; then
			repository=${y}
		fi
		if [ ${i} -eq 1 ]; then
			tag=${y}
			# save images
			if [ -f ${EXPORT_IMAGE_PATH}/${repository}-${tag}.tar ]; then
				rm -f ${EXPORT_IMAGE_PATH}/${repository}-${tag}.tar
			fi
			cmd="docker save -o ${EXPORT_IMAGE_PATH}/${repository}-${tag}.tar ${x}"
			echo ${cmd}
			${cmd}
			break
		fi
		let "i += 1"
	done
done

ls -al ${EXPORT_IMAGE_PATH}