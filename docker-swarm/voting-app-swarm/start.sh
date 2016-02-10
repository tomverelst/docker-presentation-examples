#!/bin/bash

# Connect to the swarm master
eval $(docker-machine env --swarm mh-node1-vb)

# Start redis on a backend node
docker run -d \
  -p 6379 \
  --net back-tier \
  --name redis \
  --restart unless-stopped \
  -e "constraint:type==backend" \
  redis

# Create Postgres volume
docker volume create --name db-data

# Start Postgres
docker run -d \
  -v "db-data:/var/lib/postgresql/data" \
  --net back-tier \
  --restart unless-stopped \
  --name db \
  -e "constraint:type==backend" \
  -e "constraint:storage==ssd" \
  postgres:9.4

# Start voting app
# You cannot define multiple networks with docker run :-(
docker create \
 -p 5000:80 \
 --name voting-app \
 --restart unless-stopped \
 -e "constraint:type==frontend" \
tomverelst/voting-app

# Connect result app
docker network connect front-tier voting-app
docker network connect back-tier voting-app

# Start voting app
docker start voting-app

# Create result app
docker create \
 -p 5001:80 \
 --name result-app \
 --restart unless-stopped \
 -e "constraint:type==frontend" \
tomverelst/result-app

# Connect result app to networks
docker network connect front-tier result-app
docker network connect back-tier result-app

# Start result app
docker start result-app

# Start worker on backend node
docker run -d \
  --net back-tier \
  --name worker \
  --restart unless-stopped \
  -e "constraint:type==backend" \
  tomverelst/worker
