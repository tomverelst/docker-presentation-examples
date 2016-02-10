#!/bin/bash

for container in {worker,redis,db,result-app,voting-app}; do
  docker stop $container
  docker rm $container
done;
unset container;

docker volume rm db-data;
