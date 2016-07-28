#!/bin/bash

#
# Copyright (c) 2001-2016 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

CONTEXT_PATH=$(cd $(dirname ${0}); pwd)

#
# export images
#

if [ -z "${REGISTRY_URL}" ]; then
    REGISTRY_URL="euler-registry.primeton.com"
fi

# pull images
if [ ! -z "${TARGET_IMAGES}" ]; then
    for x in ${TARGET_IMAGES} ; do
        docker pull ${REGISTRY_URL}/${x}
    done
fi

if [ -z ${EXPORT_IMAGE_PATH} ]; then
	EXPORT_IMAGE_PATH=${CONTEXT_PATH}/target
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
			# if exist '/', replace all '/' with '_'
			t="/"
			r="_"
			repository=${repository//${t}/${r}}
			echo "${repository}"
			if [ "none" == "${repository}" ]; then
			    break
			fi
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