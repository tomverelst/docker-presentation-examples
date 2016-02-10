#!/bin/bash


# I can pass the keys to the create command

# docker-machine create \
#   --driver amazonec2 \
#   --amazonec2-access-key $(cat ~/DOCKER_AWS_KEY_ID) \
#   --amazonec2-secret-key $(cat ~/DOCKER_AWS_SECRET_KEY) \
#   aws01

export AWS_ACCESS_KEY_ID=$(cat ~/DOCKER_AWS_KEY_ID)
export AWS_SECRET_ACCESS_KEY=MY-SECRET-KEY=$(cat ~/DOCKER_AWS_SECRET_KEY)
VPC_ID="vpc-81fd75e4"
SUBNET_ID="subnet-f551bade"

docker-machine create \
  --driver amazonec2 \
  --amazonec2-vpc-id $VPC_ID \
  --amazonec2-subnet-id $SUBNET_ID \
  aws01
