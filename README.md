# Swarm frontends
This project contains [Docker Compose](https://docs.docker.com/compose/) files used to easily deploy distributed containerized applications. Currently the project contains Docker Compose files for Kubernetes and Mesos-Marathon.

The rationale behind this is that Swarm is lightweight enough to deploy additional orchestration tools on top. You begin with the regular docker experience and you can enhance this by adding orchestration/schedulers on top (`kubernetes`/`nomad`/`mesos`), etc. It is not yet production ready.

An added benefit is that you can use the regular docker commands against the Mesos/Marathon and Kubernetes clusters: `inspect`/`logs`/`attach`, etc.

## Prerequisites

- Master version of Docker Compose: (see [Issue #2334](https://github.com/docker/compose/pull/2334))
- Latest version of Swarm: `1.0.0`
- Point Compose to the Swarm cluster if not local by setting `DOCKER_HOST`, `DOCKER_TLS_VERIFY`, `DOCKER_CERT_PATH` appropriately
- An *etcd, consul* or *zookeeper* cluster running for the overlay networking feature (this is not mandatory, the compose file can be tweaked to not use it but it's a nice addition to deploy across cloud providers).

See the [networking documentation](https://docs.docker.com/engine/userguide/networking/get-started-overlay/) to setup docker to use the Multi-Host networking features.


To simplify your setup, we have some helper files for setting up virtualbox VMs with Swarm on your machine:
- Prerequisite: you have installed [Docker Toolbox](https://www.docker.com/docker-toolbox)
- `init_swarm.sh` sets up a 6 node Swarm cluster (1 master, 5 agents) using [docker-machine](https://docs.docker.com/machine/) and [VirtualBox](https://www.virtualbox.org/).
- Setup your environment variables: `eval $(docker-machine env --swarm swarm-master)`
- Follow instructions in the appropriate directory (kubernetes or mesos-marathon) to run Docker Compose to setup and scale your containerized application
- Use `cleanup_swarm.sh` to clean up the VMs created


