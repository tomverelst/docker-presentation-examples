#!/bin/bash

export MASTER_IP=$(docker-machine ip mh-master-vb)
export KV_IP=$(docker-machine ip mh-kv-vb)

for machine in {mh-master-vb,mh-node1-vb,mh-node2-vb,mh-node3-vb,mh-node4-vb}; do
  eval $(docker-machine env $machine)
  export SLAVE_IP=$(docker-machine ip $machine)
  docker run -d \
    --name=registrator \
    -h ${SLAVE_IP} \
    --restart=unless-stopped \
    --volume=/var/run/docker.sock:/tmp/docker.sock \
    gliderlabs/registrator:latest \
    consul://${KV_IP}:8500
done;
unset machine;
