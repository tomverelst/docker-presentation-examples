#!/bin/bash

# Stop all machines
docker-machine stop $(docker-machine ls -q | grep mh)

# Remove all machines
docker-machine rm $(docker-machine ls -q | grep mh)

# Remove network
docker network rm front-tier back-tier
