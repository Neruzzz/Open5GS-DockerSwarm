BASE_TAG = base-open5gs
UERANSIM_TAG = ueransim
MONGO_TAG = open5gs-mongo

PREFIX = registry.gitlab.bsc.es/ppc/software/open5gs/

# Set default architecture to amd
ARCH_TAG=amd
# Check if the system architecture is arm
ifeq ($(shell uname -m),aarch64)
    ARCH_TAG=arm
endif

all: openmongo

baseopen: 
	docker build -f base/Dockerfile -t $(PREFIX)$(BASE_TAG):$(ARCH_TAG) .
	docker push $(PREFIX)$(BASE_TAG):$(ARCH_TAG)

ueransim: baseopen
	docker build --progress=plain -f ueransim/Dockerfile -t $(PREFIX)$(UERANSIM_TAG):$(ARCH_TAG) . 
	docker push $(PREFIX)$(UERANSIM_TAG):$(ARCH_TAG)

openmongo: ueransim
	docker build --progress=plain -f mongo/Dockerfile -t $(PREFIX)$(MONGO_TAG):$(ARCH_TAG) . 
	docker push $(PREFIX)$(MONGO_TAG):$(ARCH_TAG)