#!/bin/bash
set -x

export ADMIN_USER="admin"
export ADMIN_PASS="pass"

docker rm -f some-d8 || true
docker build --build-arg ADMIN_USER --build-arg ADMIN_PASS -t lb/d8 .
docker run --name some-d8 -p 8080:80 -d \
	-e APIGEE_EDGE_AUTH_TYPE=basic \
	-e APIGEE_EDGE_ENDPOINT=https://api.enterprise.apigee.com/v1 \
	lb/d8 
