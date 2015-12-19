# Mesos-Marathon over Swarm

This folder contains a sample `compose.yml` file describing a Mesos-Marathon deployment. It is not meant to be used in a production cluster but shows how easy it is to create and scale a Mesos-Marathon cluster on top of Swarm.

As noted previously, a nice benefit is that you can use the regular docker commands against the Mesos-Marathon cluster: `inspect`/`logs`/`attach`, etc.

## Usage

To deploy your cluster, use:

`docker-compose --x-networking -f mesos-marathon-swarm.yml up -d`

You'll see logs from all the containers being deployed.

Run `docker ps` to find the ip addresses of the marathon and mesos containers. You can open those URLs in a browser (e.g.: `mesos-master - 192.168.99.132:5050`, `marathon - 192.168.99.132:8080`) to view the Mesos and Marathon dashboards.


## Scale

To scale mesos-slave instances you can now use:

`docker-compose --x-networking -f mesos-marathon-swarm.yml scale mesosslave=4`

New nodes show up in the Mesos dashboard as expected.

## Known limits / Possible enhancements

This is a base Compose file but it can be used to tweak a complete Production deployment, securing it with TLS, using distributed volumes (Ceph, GlusterFS) for the Zookeeper cluster, etc. Feel free to propose enhancements! We'd like to see it working better.

A needed enhancement on the Swarm side is the use of ACLs to deploy the Mesos-Marathon cluster. This allows an admin user to deploy the cluster and regular users will not be able to delete the Mesos-Marathon components (It's in the work in [Swarm #1366](https://github.com/docker/swarm/pull/1366))



