#!/bin/bash

# docker swarm init (in master)
# docker swarm join-token worker
# paste the output on the worker

# docker node ls
# docker swarm leave
# docker node rm name (from master when down)

export $(cat .env) 2> /dev/null

echo "Removing stack"
docker stack rm open5gs

echo "Removing residual containers"
RESIDUAL_CONTAINERS=$(docker ps -a | grep open5gs | awk '{ print $1 }' | xargs)
if [ ! -z "$RESIDUAL_CONTAINERS" ]; then
    docker rm -f $RESIDUAL_CONTAINERS > /dev/null
fi
sleep 5

echo "Creating new stack"
docker stack deploy -c open5gs-stack.yml open5gs

echo  "Retrieving all the service IPs"

# Delete old service names and IPs from .env
sed -i '25,$d' .env

# Run the command and capture the JSON output
json_output=$(docker network inspect open5gs_default)

# Parse the JSON output and extract service names and IPs
service_names=($(echo "$json_output" | jq -r '.[0].Containers | keys[]'))
service_ips=($(echo "$json_output" | jq -r '.[0].Containers[].IPv4Address'))

# Create the .env file and populate it with service names and IPs
for ((i=0; i<${#service_names[@]}; i++)); do
    service_name=${service_names[i]%%.*}
    service_ip=${service_ips[i]%/*}
    echo "${service_name}=${service_ip}" >> .env
done

