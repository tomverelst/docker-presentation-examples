#!/bin/bash

# View contents of chmod.json
cat chmod.json | jq .

# Run chmod command with seccomp
docker run --rm --security-opt seccomp:chmod.json busybox chmod 400 /etc/hostname

# Without default seccomp profile
docker run --rm -it --security-opt seccomp:unconfined debian:jessie \ 
  unshare --user --pid echo hello

# With default seccomp profile
docker run --rm -it debian:jessie \ 
  unshare --user --pid echo hello
