#!/usr/bin/env bash

cd `dirname $0`
BASE_DIR=`pwd`
cd -

source ${BASE_DIR}/env.properties


KV_URL=$1
NODE_NAME=$2

docker-machine  create -d aliyunecs --swarm \
    --swarm-discovery=${KV_URL} \
    --swarm-image ${SWARM_IMAGE} \
    --engine-install-url  ${ENGINE_INSTALL_URL} \
    --engine-insecure-registry ${PRIVATE_REGISTRY} \
    --engine-registry-mirror ${REGISTRY_MIRROR} \
    --engine-storage-driver overlay \
    --engine-opt="cluster-store=${KV_URL}" \
    --engine-opt="cluster-advertise=eth1:2376" \
    --aliyunecs-access-key-id ${ALIYUNECS_ACCESS_KEY_ID} \
    --aliyunecs-access-key-secret ${ALIYUNECS_ACCESS_KEY_SECRET} \
    --aliyunecs-api-endpoint ${ALIYUNECS_API_ENDPOINT} \
    --aliyunecs-region ${ALIYUNECS_RGION_ID} \
    --aliyunecs-image-id ${ImageId} \
    --aliyunecs-ssh-password ${Password} \
    --aliyunecs-security-group sg-acs  \
    --aliyunecs-instance-type ${InstanceType} \
    --aliyunecs-disk-size 100 \
    --aliyunecs-upgrade-kernel \
    ${NODE_NAME}
