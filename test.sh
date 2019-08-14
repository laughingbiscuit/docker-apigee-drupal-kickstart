#!/bin/bash

curl -f -s localhost:8080 | grep "BAPIs" > /dev/null && echo "Portal is up" || echo "Portal is down"
