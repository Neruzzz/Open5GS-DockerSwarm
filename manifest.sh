#!/bin/bash

# Open5GS
docker pull registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:swarm:arm
docker pull registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:swarm:amd

docker manifest create registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:swarm:latest \
--amend registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:arm \
--amend registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:amd

docker manifest push --purge registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:swarm:latest

# UERANSIM
docker pull registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:swarm:arm
docker pull registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:swarm:amd

docker manifest create registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:swarm:latest \
--amend registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:swarm:arm \
--amend registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:swarm:amd

docker manifest push --purge registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:swarm:latest

# MONGO
docker pull registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:arm
docker pull registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:amd

docker manifest create registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:latest \
--amend registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:arm \
--amend registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:amd

docker manifest push --purge registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:latest


# Clean up all the images to leave just the latest tag ones
docker rmi $(sudo docker images -f "dangling=true" -q)

docker rmi --force  registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:swarm:arm
docker rmi --force  registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:swarm:amd

docker rmi --force  registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:swarm:arm
docker rmi --force  registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:swarm:amd

docker rmi --force registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:arm
docker rmi --force registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:amd
