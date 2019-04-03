Apigee Dev Portal Kickstart Drupal + Docker
---

Using the `quick-start` command is great on your local machine, but doesn't play nice a Docker container.

Here is simple setup that lets you run the Apigee Drupal Kickstarter in a Docker container. This image is for local development purposes.

See [here](https://github.com/apigee/apigee-devportal-kickstart-drupal)


To Use:
``` bash
# build and run the container
./start.sh
```

Navigate to... `https://localhost:8080` and follow the wizard. Make sure you use SQLite if you don't want to separately configure a database.
