#!/bin/bash

# wait for portal to come up
while ! nc -z localhost 8080; do   
  sleep 1
done

# check that a page contain APIs (not an error) is displayed
curl -f -s localhost:8080 | grep "APIs" > /dev/null && echo "Portal is up"

# check that the API is enabled
curl -f -s localhost:8080/api/1?_format=json | jq '.spec[].url' | grep "petstore.yaml"> /dev/null && echo "REST API is available"

