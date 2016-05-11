#!/bin/bash

# Create Key Value Store machine
docker-machine create \
  -d virtualbox \
  --engine-label="environment=production" \
  --engine-label="type=kv" \
  mh-kv-vb

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
  --engine-opt="cluster-advertise=eth1:2376" \
  --engine-label="environment=production" \
  --engine-label="type=swarm-master" \
  mh-master-vb

# Create Swarm nodes
docker-machine create \
  -d virtualbox \
  --swarm \
  --swarm-discovery="consul://$(docker-machine ip mh-kv-vb):8500" \
  --engine-opt="cluster-store=consul://$(docker-machine ip mh-kv-vb):8500" \
  --engine-opt="cluster-advertise=eth1:2376" \
  --engine-label="storage=disk" \
  --engine-label="environment=production" \
  --engine-label="type=frontend" \
  mh-node1-vb

# Create Swarm nodes
docker-machine create \
  -d virtualbox \
  --swarm \
  --swarm-discovery="consul://$(docker-machine ip mh-kv-vb):8500" \
  --engine-opt="cluster-store=consul://$(docker-machine ip mh-kv-vb):8500" \
  --engine-opt="cluster-advertise=eth1:2376" \
  --engine-label="storage=disk" \
  --engine-label="environment=production" \
  --engine-label="type=frontend" \
  mh-node2-vb

docker-machine create \
  -d virtualbox \
  --swarm \
  --swarm-discovery="consul://$(docker-machine ip mh-kv-vb):8500" \
  --engine-opt="cluster-store=consul://$(docker-machine ip mh-kv-vb):8500" \
  --engine-opt="cluster-advertise=eth1:2376" \
  --engine-label="storage=ssd" \
  --engine-label="environment=production" \
  --engine-label="type=backend" \
  mh-node3-vb

docker-machine create \
  -d virtualbox \
  --swarm \
  --swarm-discovery="consul://$(docker-machine ip mh-kv-vb):8500" \
  --engine-opt="cluster-store=consul://$(docker-machine ip mh-kv-vb):8500" \
  --engine-opt="cluster-advertise=eth1:2376" \
  --engine-label="storage=ssd" \
  --engine-label="environment=production" \
  --engine-label="type=backend" \
  mh-node4-vb

# Set environment to Swarm master
eval $(docker-machine env --swarm mh-master-vb)

# Create the overlay networks
# It is important to define subnets
# to avoid conflicts and connection issues
# Or you will spend too much time
# trying to figure out why it does not work like me :-)
docker network create -d overlay --subnet=10.0.11.0/24 front-tier
docker network create -d overlay --subnet=10.0.12.0/24 back-tier
