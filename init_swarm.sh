# initialize docker
echo "----- Initialize environment -----"
eval $(docker-machine env default)

# create network
echo "----- Setup machine to deploy the key-value store -----"
docker-machine create -d virtualbox \
    --engine-insecure-registry acs-reg.alipay.com \
    --engine-registry-mirror https://rmw18jx4.mirror.aliyuncs.com \
  mh-keystore

echo "----- Start consul -----"
docker $(docker-machine config mh-keystore) run -d -p "8500:8500" -h "consul" acs-reg.alipay.com/progrium/consul -server -bootstrap

eval $(docker-machine env mh-keystore)

echo "----- create a machine with the swarm master -----"
docker-machine create -d virtualbox --swarm --swarm-master \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --swarm-image acs-reg.alipay.com/acs/swarm \
    --engine-insecure-registry acs-reg.alipay.com \
    --engine-registry-mirror https://rmw18jx4.mirror.aliyuncs.com \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-master
docker-machine ssh swarm-master "sudo modprobe openvswitch"


echo "----- create a machine for swarm node 1 -----"
docker-machine create -d virtualbox --swarm \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --swarm-image acs-reg.alipay.com/acs/swarm \
    --engine-insecure-registry acs-reg.alipay.com \
    --engine-registry-mirror https://rmw18jx4.mirror.aliyuncs.com \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-node-01
docker-machine ssh swarm-node-01 "sudo modprobe openvswitch"

echo "----- create a machine for swarm node 2 -----"
docker-machine create -d virtualbox --swarm \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --swarm-image acs-reg.alipay.com/acs/swarm \
    --engine-insecure-registry acs-reg.alipay.com \
    --engine-registry-mirror https://rmw18jx4.mirror.aliyuncs.com \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-node-02
docker-machine ssh swarm-node-02 "sudo modprobe openvswitch"


echo "----- create a machine for swarm node 3 -----"
docker-machine create -d virtualbox --swarm \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --swarm-image acs-reg.alipay.com/acs/swarm \
    --engine-insecure-registry acs-reg.alipay.com \
    --engine-registry-mirror https://rmw18jx4.mirror.aliyuncs.com \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-node-03
docker-machine ssh swarm-node-03 "sudo modprobe openvswitch"



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


