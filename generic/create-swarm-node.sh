#!/usr/bin/env bash

cd `dirname $0`
BASE_DIR=`pwd`
cd -

source ${BASE_DIR}/env.properties


KV_URL=$1
IP=$2
NODE_NAME=$3

docker-machine  create -d generic --swarm \
    --swarm-discovery=${KV_URL} \
    --swarm-image ${SWARM_IMAGE} \
    --engine-install-url  ${ENGINE_INSTALL_URL} \
    --engine-insecure-registry ${PRIVATE_REGISTRY} \
    --engine-registry-mirror ${REGISTRY_MIRROR} \
    --engine-storage-driver overlay \
    --engine-opt="cluster-store=${KV_URL}" \
    --engine-opt="cluster-advertise=eth1:2376" \
    --generic-ip-address ${IP} \
    ${NODE_NAME}
