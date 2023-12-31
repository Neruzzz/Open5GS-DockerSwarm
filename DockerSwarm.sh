#!/bin/bash

# docker swarm init (in master)
# docker swarm join-token worker
# paste the output on the worker

# docker node ls
# docker swarm leave
# docker node rm name (from master when down)

export $(cat .env) 2> /dev/null

log_folder="./log"  # Path to the log folder relative to the current directory

echo "Deleting old log files"
# Check if the log folder exists
if [ -d "$log_folder" ]; then
  # Delete all files inside the log folder
  rm -rf "$log_folder"/*
  echo "All files inside the log folder have been deleted."
fi
echo ""

echo "Removing stack"
docker stack rm open5gs

echo "Removing residual containers"
RESIDUAL_CONTAINERS=$(docker ps -a | grep open5gs | awk '{ print $1 }' | xargs)
if [ ! -z "$RESIDUAL_CONTAINERS" ]; then
    docker rm -f $RESIDUAL_CONTAINERS > /dev/null
fi
sleep 5
echo ""

# Deployment part with flag
if [ $# -eq 0 ]; then
    echo "Usage: $0 [-c for cloud | -e for edge]"
    exit 1
fi

# Parse the flag
flag="$1"
if [ "$flag" = "-c" ]; then
    yaml_file="open5gs-stack-cloud.yml"
elif [ "$flag" = "-e" ]; then
    yaml_file="open5gs-stack-edge.yml"
else
    echo "Invalid flag: $flag. Use -c for cloud or -e for edge."
    exit 1
fi

echo "Creating new stack using $yaml_file"
docker stack deploy -c "$yaml_file" open5gs --with-registry-auth
echo ""

echo  "Retrieving all the service IPs"
service_names=$(docker service ls --format "{{.Name}}")

# Declare an associative array to store service names and IPs
declare -A service_ips

# Get the subnet range
subnet_range=$(docker network inspect --format='{{range .IPAM.Config}}{{.Subnet}}{{end}}' open5gs_common_network)

# Extract the subnet prefix from the subnet range
subnet_prefix=$(echo "$subnet_range" | cut -d '/' -f 1)
subnet_prefix_with_wildcard="$subnet*"

# Iterate over service names and assign IPs
for service_name in $service_names; do
    ips=$(docker service inspect --format='{{range .Endpoint.VirtualIPs}}{{.Addr}} {{end}}' "$service_name")
    for ip in $ips; do
        ip_without_mask=$(echo "$ip" | cut -d '/' -f 1)
        incremented_ip=$(echo "$ip_without_mask" | awk -F '.' -v OFS='.' '{$NF+=1; print}')
        
        if [[ $incremented_ip == $subnet_prefix_with_wildcard ]]; then
            service_ips[$service_name]=$incremented_ip
        fi
    done
done

# Delete old Service names and IPs
echo Deleting old IPs in env
sed -i '27,$d' .env

# Service names and IPs to the .env file
echo Writing new IPs to .env
for service_name in "${!service_ips[@]}"; do
    echo "$service_name=${service_ips[$service_name]}" >> .env
done


# Copying the .env to all the subdirectories
echo Copying .env to each config folder
file_to_copy="$(dirname "$0")/.env"
config="$(dirname "$0")/open5gs/config"

cp -f "$file_to_copy" "./ueransim/"
echo ".env file copied to ./ueransim"

cp -f "$file_to_copy" "./webui/"
echo ".env file copied to ./webui"

# Iterate through subdirectories of open5gs
for dir in "$config"/*; do
  if [[ -d "$dir" ]]; then
    cp -f "$file_to_copy" "$dir/"
    echo ".env file copied to $dir"
  fi
done

# Push the changes to git so edge UPF can download them
# Check if the flag is "-e" (for edge) and execute git commands
if [ "$flag" = "-e" ]; then
    echo "Executing git commands for edge deployment"
    git add .
    git commit -m "Execution"
    git push
fi