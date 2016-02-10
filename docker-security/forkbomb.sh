#!/bin/bash

# --pids-limit will be available in Docker 1.11

# Start container with PID limit
docker run --rm -it --pids-limit 200 debian:jessie bash

# Forkbomb command
# :(){ :|: & };:
