OPEN5GS_TAG = open5gs
UERANSIM_TAG = ueransim
MONGO_TAG = mongo
DEPLOYMENT_TAG = swarm

PREFIX = registry.gitlab.bsc.es/ppc/software/open5gs/

# Set default architecture to amd
ARCH_TAG=latest
# Check if the system architecture is arm
# ifeq ($(shell uname -m),aarch64)
#     ARCH_TAG=arm
# endif

all: mongo

openfivegs: 
	docker build -f open5gs/Dockerfile -t $(PREFIX)$(DEPLOYMENT_TAG)-$(OPEN5GS_TAG):$(ARCH_TAG) .
	docker push $(PREFIX)$(DEPLOYMENT_TAG)-$(OPEN5GS_TAG):$(ARCH_TAG)

ueransim: openfivegs
	docker build --progress=plain -f ueransim/Dockerfile -t $(PREFIX)$(DEPLOYMENT_TAG)-$(UERANSIM_TAG):$(ARCH_TAG) . 
	docker push $(PREFIX)$(DEPLOYMENT_TAG)-$(UERANSIM_TAG):$(ARCH_TAG)

mongo: ueransim
	docker build --progress=plain -f mongo/Dockerfile -t $(PREFIX)$(MONGO_TAG):$(ARCH_TAG) . 
	docker push $(PREFIX)$(MONGO_TAG):$(ARCH_TAG)