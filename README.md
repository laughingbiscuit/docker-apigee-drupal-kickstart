Apigee Dev Portal Kickstart Drupal + Docker
---

[![Build Status](https://travis-ci.org/laughingbiscuit/docker-apigee-drupal-kickstart.svg?branch=master)](https://travis-ci.org/laughingbiscuit/docker-apigee-drupal-kickstart)

Using the `quick-start` command is great on your local machine, but doesn't play nice a Docker container.

Here is simple setup that lets you run the Apigee Drupal Kickstarter in a Docker container. This image is for local development purposes.

See [here](https://github.com/apigee/apigee-devportal-kickstart-drupal)

## Features
- Apigee Kickstart profile installed
- Drupal REST UI installed
- REST endpoints configure for Apigee Entities

To Use:
``` bash
export APIGEE_ORG=xxx
export APIGEE_USER=xxx
export APIGEE_PASS=xxx

# build and run the container
./start.sh
```

Navigate to `localhost:8080` and you will see an Apigee Portal installed with demo content.

Default admin credentials for the portal are: `admin` and `pass`, but you can change these in `start.sh`
