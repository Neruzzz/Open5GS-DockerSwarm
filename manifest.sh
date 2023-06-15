#!/bin/bash

# Open5GS
docker pull registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:arm
docker pull registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:amd

docker manifest create registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:latest \
--amend registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:arm \
--amend registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:amd

docker manifest push --purge registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:latest

# UERANSIM
docker pull registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:arm
docker pull registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:amd

docker manifest create registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:latest \
--amend registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:arm \
--amend registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:amd

docker manifest push --purge registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:latest

# MONGO
docker pull registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:arm
docker pull registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:amd

docker manifest create registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:latest \
--amend registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:arm \
--amend registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:amd

docker manifest push --purge registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:latest


# Clean up all the images to leave just the latest tag ones
docker rmi $(sudo docker images -f "dangling=true" -q)

docker rmi --force  registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:arm
docker rmi --force  registry.gitlab.bsc.es/ppc/software/open5gs/base-open5gs:amd

docker rmi --force  registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:arm
docker rmi --force  registry.gitlab.bsc.es/ppc/software/open5gs/ueransim:amd

docker rmi --force registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:arm
docker rmi --force registry.gitlab.bsc.es/ppc/software/open5gs/open5gs-mongo:amd
