#!/usr/bin/env bash


cd `dirname $0`
BASE_DIR=`pwd`


source ${BASE_DIR}/env.properties


MASTER_NAME=${POOL_NAME}-master
SECURITY_GROUP_NAME=sg-${POOL_NAME}

#sh  -x create-kv.sh ${KV_NAME}
cat master.list  | xargs -n1 -P1 sh -x create-swarm-master.sh  ${KV_URL} 
cat node.list | xargs -n1 -P3 sh -x create-swarm-node.sh ${KV_URL}


cd -
