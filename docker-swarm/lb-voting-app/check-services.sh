#!/bin/bash
curl $(docker-machine ip mh-kv-vb):8500/v1/catalog/services
