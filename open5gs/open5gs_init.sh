#!/bin/bash
echo "Waiting for all nodes IPs"
sleep 30

if [[ -z "$COMPONENT_NAME" ]]; then
	echo "Error: COMPONENT_NAME environment variable not set"; exit 1;
elif [[ "$COMPONENT_NAME" =~ ^(amf-[[:digit:]]+$) ]]; then
	echo "Deploying component: '$COMPONENT_NAME'"
	/mnt/amf/amf_init.sh  && \
	cd install/bin && ./open5gs-amfd
elif [[ "$COMPONENT_NAME" =~ ^(ausf-[[:digit:]]+$) ]]; then
	echo "Deploying component: '$COMPONENT_NAME'"
	/mnt/ausf/ausf_init.sh  && \
	cd install/bin && ./open5gs-ausfd
elif [[ "$COMPONENT_NAME" =~ ^(bsf-[[:digit:]]+$) ]]; then
	echo "Deploying component: '$COMPONENT_NAME'"
	/mnt/bsf/bsf_init.sh && sleep 10 && \
	cd install/bin && ./open5gs-bsfd
elif [[ "$COMPONENT_NAME" =~ ^(nrf-[[:digit:]]+$) ]]; then
	echo "Deploying component: '$COMPONENT_NAME'"
	/mnt/nrf/nrf_init.sh  && \
    cd install/bin && ./open5gs-nrfd
elif [[ "$COMPONENT_NAME" =~ ^(scp-[[:digit:]]+$) ]]; then
	echo "Deploying component: '$COMPONENT_NAME'"
	/mnt/scp/scp_init.sh  && \
    cd install/bin && ./open5gs-scpd
elif [[ "$COMPONENT_NAME" =~ ^(nssf-[[:digit:]]+$) ]]; then
	echo "Deploying component: '$COMPONENT_NAME'"
	/mnt/nssf/nssf_init.sh  && \
    cd install/bin && ./open5gs-nssfd
elif [[ "$COMPONENT_NAME" =~ ^(pcf-[[:digit:]]+$) ]]; then
	echo "Deploying component: '$COMPONENT_NAME'"
	/mnt/pcf/pcf_init.sh && sleep 10 && \
    cd install/bin && ./open5gs-pcfd
elif [[ "$COMPONENT_NAME" =~ ^(pcrf-[[:digit:]]+$) ]]; then
	echo "Deploying component: '$COMPONENT_NAME'"
	/mnt/pcrf/pcrf_init.sh && sleep 10 && \
    cd install/bin && ./open5gs-pcrfd
elif [[ "$COMPONENT_NAME" =~ ^(smf-[[:digit:]]+$) ]]; then
	echo "Deploying component: '$COMPONENT_NAME'"
	/mnt/smf/smf_init.sh  && \
    cd install/bin && ./open5gs-smfd
elif [[ "$COMPONENT_NAME" =~ ^(udm-[[:digit:]]+$) ]]; then
	echo "Deploying component: '$COMPONENT_NAME'"
	/mnt/udm/udm_init.sh  && \
    cd install/bin && ./open5gs-udmd
elif [[ "$COMPONENT_NAME" =~ ^(udr-[[:digit:]]+$) ]]; then
	echo "Deploying component: '$COMPONENT_NAME'"
	/mnt/udr/udr_init.sh && sleep 10 && \
    cd install/bin && ./open5gs-udrd
elif [[ "$COMPONENT_NAME" == "upf-cloud" ]]; then
	echo "Deploying component: '$COMPONENT_NAME'"
	sleep 10 && \
	/mnt/udr/upf_init.sh && \
    cd install/bin && ./open5gs-upfd
elif [[ "$COMPONENT_NAME" == "upf-edge" ]]; then
	echo "Deploying component: '$COMPONENT_NAME'"
	# Emulate volumes using github
	# Clone the repo
	git clone git@github.com:Neruzzz/Open5GS-DockerSwarm.git && \ 
	# Create the mnt volume for the upf
	mkdir -p /mnt/upf/ && \
	# Copy the contents to the mnt folder
	cp Open5GS-DockerSwarm/open5gs/config/upf/* /mnt/upf/ && \
	# .env is copied on another command
	cp -pfr Open5GS-DockerSwarm/open5gs/config/upf/.env /mnt/upf/ && \
	# Execute the service init script
	/mnt/upf/upf_init.sh && \
    cd install/bin && ./open5gs-upfd
elif [[ "$COMPONENT_NAME" =~ ^(webui) ]]; then
	echo "Deploying component: '$COMPONENT_NAME'"
	sleep 10 && chmod +x /mnt/webui/webui_init.sh && /mnt/webui/webui_init.sh
else
	echo "Error: Invalid component name: '$COMPONENT_NAME'"
fi