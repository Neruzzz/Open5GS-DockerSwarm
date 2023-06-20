#!/bin/bash
export $(cat /mnt/webui/.env) 2> /dev/null
export DB_URI="mongodb://${open5gs_mongo}/open5gs"

cd webui && HOSTNAME=0.0.0.0 npm run dev