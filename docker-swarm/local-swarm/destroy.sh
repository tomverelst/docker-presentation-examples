#!/bin/bash

# Stop all machines
docker-machine stop mh-node3-vb mh-node2-vb mh-node1-vb mh-kv-vb

# Remove all machines
docker-machine rm mh-node3-vb mh-node2-vb mh-node1-vb mh-kv-vb

# Remove network
docker network rm front-tier back-tier
