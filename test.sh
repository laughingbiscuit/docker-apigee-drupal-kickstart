#!/bin/bash

while ! nc -z localhost 8080; do   
  sleep 1
done
curl -f -s localhost:8080 | grep "APIs" > /dev/null && echo "Portal is up"
