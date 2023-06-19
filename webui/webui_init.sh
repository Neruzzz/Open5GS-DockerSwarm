#!/bin/bash
export $(cat /mnt/webui/.env) 2> /dev/null
echo $open5gs_mongo
export DB_URI="mongodb://${open5gs_mongo}/open5gs"

cd webui && npm run dev