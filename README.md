Apigee Dev Portal Kickstart Drupal + Docker
---

Using the `quick-start` command is great on your local machine, but doesn't play nice a Docker container.

Here is simple setup that lets you run the Apigee Drupal Kickstarter in a Docker container. This image is for local development purposes.

See [here](https://github.com/apigee/apigee-devportal-kickstart-drupal)


To Use:
``` bash
# prerequisite: set APIGEE_XXX variables
export APIGEE_ORG=xxx
export APIGEE_USER=xxx
export APIGEE_PASS=xxx

# build and run the container
./start.sh
```
