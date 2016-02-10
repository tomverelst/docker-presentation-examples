#!/bin/bash

# Create Key Value Store machine
docker-machine create -d virtualbox mh-kv-vb

# Run Consul as Key Value Store
docker $(docker-machine config mh-kv-vb) run -d \
  -p 8500:8500 \
  -h "consul" \
  progrium/consul -server -bootstrap -ui-dir /ui


# Create Swarm master
docker-machine create \
  -d virtualbox \
  --swarm --swarm-master \
  --swarm-discovery="consul://$(docker-machine ip mh-kv-vb):8500" \
  --engine-opt="cluster-store=consul://$(docker-machine ip mh-kv-vb):8500" \
  --engine-opt="cluster-advertise=eth0:2376" \
  --engine-label="environment=production" \
  --engine-label="type=frontend" \
  mh-node1-vb

# Create Swarm nodes
docker-machine create \
  -d virtualbox \
  --swarm \
  --swarm-discovery="consul://$(docker-machine ip mh-kv-vb):8500" \
  --engine-opt="cluster-store=consul://$(docker-machine ip mh-kv-vb):8500" \
  --engine-opt="cluster-advertise=eth0:2376" \
  --engine-label="storage=disk" \
  --engine-label="environment=production" \
  --engine-label="type=frontend" \
  mh-node2-vb

docker-machine create \
  -d virtualbox \
  --swarm \
  --swarm-discovery="consul://$(docker-machine ip mh-kv-vb):8500" \
  --engine-opt="cluster-store=consul://$(docker-machine ip mh-kv-vb):8500" \
  --engine-opt="cluster-advertise=eth0:2376" \
  --engine-label="storage=ssd" \
  --engine-label="environment=production" \
  --engine-label="type=backend" \
  mh-node3-vb

# Set environment to Swarm master
eval $(docker-machine env --swarm mh-node1-vb)

# Create the overlay network
docker network create -d overlay front-tier
docker network create -d overlay back-tier
