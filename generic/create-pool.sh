#!/usr/bin/env bash


cd `dirname $0`
BASE_DIR=`pwd`


source ${BASE_DIR}/env.properties


MASTER_NAME=${POOL_NAME}-master
SECURITY_GROUP_NAME=sg-${POOL_NAME}

#sh  -x create-kv.sh ${KV_NAME}
cat master.list  | xargs -n2 -P1 sh create-swarm-master.sh  ${KV_URL} 
cat node.list | xargs -n2 -P3 sh create-swarm-node.sh ${KV_URL}


cd -
