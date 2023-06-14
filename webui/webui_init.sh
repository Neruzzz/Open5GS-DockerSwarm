#!/bin/bash

export DB_URI="mongodb://${MONGO_IP}/open5gs"

cd webui && npm run dev