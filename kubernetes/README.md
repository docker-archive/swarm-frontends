# Kubernetes over Swarm

This folder contains a sample `compose.yml` file describing a Kubernetes deployment. It is not meant to be used in a production cluster but shows how easy it is to create and scale a Kubernetes cluster on top of Swarm.

Using Kubernetes on top of Swarm has many advantages: You can now use the *Replication Controller* alongside the *Pod* concept. Try to `rm` a container deployed with Kubernetes using Swarm, it will be still running thanks to Kubernetes.

As noted previously, a nice benefit is that you can use the regular docker commands against the Kubernetes cluster: `inspect`/`logs`/`attach`, etc.

## Usage

To deploy your cluster, use:

```
eval $(docker-machine env --swarm swarm-master)
docker-compose -f k8s-swarm.yml up -d
```
 
You'll see logs from all the containers being deployed.

You can then list nodes using:

`kubectl -s $(docker port apiserver 8080) get nodes`

You can omit the `-s` flag if you modify your `kube/config` to point to your kubernetes cluster.

## Scale

To scale the kubelet instances you can now use:

`docker-compose -f k8s-swarm.yml scale kubelet=2 proxy=2`

If you list nodes with `kubectl get nodes` you'll see the added node in the cluster

## Known limits / Possible enhancements

This is a base Compose file but it can be used to tweak a complete Production deployment, securing it with TLS, using distributed volumes (Ceph, GlusterFS) for the etcd cluster, etc. Feel free to propose enhancements! We'd like to see it working better.

Known issues are mainly the kubelet running in `privileged` mode. It is supposed to live on the Node so this might limit some capabilities/use cases. It does not prevent using the additional Kubernetes concepts on top of Swarm though.

One main limitation is also the networking of containers created on top of a Kubernetes cluster living inside an overlay network. The mapping of virtual IPs to Internal cluster Ips accessible from other services through the Proxy is not yet clear without using external tools (interlock, etc.), and even in this case, `docker inspect` does not list Networking informations for containers created with Kubernetes. Integration to use Network labels for Pods with libnetwork can also greatly improve the experience (see [Kubernetes #10166](https://github.com/kubernetes/kubernetes/issues/10166)).

A needed enhancement on the Swarm side is the use of ACLs to deploy the Kubernetes cluster. This allows an admin user to deploy the cluster and regular users will not be able to delete the kubernetes components (It's in the work in [Swarm #1366](https://github.com/docker/swarm/pull/1366))
