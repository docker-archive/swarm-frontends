#!/bin/bash

set -e

DOCKER_MACHINE_DRIVER=${DOCKER_MACHINE_DRIVER:-'virtualbox'}

echo ${DOCKER_MACHINE_DRIVER}
exit 0

# create network
echo "----- Setup machine to deploy the key-value store -----"
docker-machine create -d ${DOCKER_MACHINE_DRIVER} mh-keystore

echo "----- Start consul -----"
docker $(docker-machine config mh-keystore) run -d -p "8500:8500" --name="consul" -h "consul" progrium/consul -server -bootstrap

echo "----- create a machine with the swarm master -----"
docker-machine create -d ${DOCKER_MACHINE_DRIVER} --swarm --swarm-master \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-master

echo "----- create a machine for swarm node 1 -----"
docker-machine create -d ${DOCKER_MACHINE_DRIVER} --swarm \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-node-01

echo "----- create a machine for swarm node 2 -----"
docker-machine create -d ${DOCKER_MACHINE_DRIVER} --swarm \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-node-02

echo "----- create a machine for swarm node 3 -----"
docker-machine create -d ${DOCKER_MACHINE_DRIVER} --swarm \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-node-03

echo "----- create a machine for swarm node 4 -----"
docker-machine create -d ${DOCKER_MACHINE_DRIVER} --swarm \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-node-04

echo "----- create a machine for swarm node 5 -----"
docker-machine create -d ${DOCKER_MACHINE_DRIVER} --swarm \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-node-05


echo "----- Set environment to point to swarm-master -----"
eval $(docker-machine env --swarm swarm-master)

echo "----- Create overlay network -----"
docker network create --driver overlay my-net

echo "---- -------------------- -----"
echo "---- Check network status -----"
echo "---- -------------------- -----"
docker network ls

echo " "
echo "---- ---------------- -----"
echo "---- Ready to deploy  -----"
echo "---- ---------------- -----"
