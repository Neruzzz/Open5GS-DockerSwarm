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
docker stack deploy -c open5gs-stack.yml 
sleep 5

echo  "Retrieving all the service IPs"
service_names=$(docker service ls --format "{{.Name}}")
echo ${service_names[@]}

service_ips=()

for service_name in "${service_names[@]}"; do
    service_ips+=$(docker service inspect --format '{{ (index .Endpoint.VirtualIPs 0).Addr }}' $service_name)
done

echo ${service_ips[@]}
