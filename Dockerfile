FROM drupal:8-apache

ARG ADMIN_USER
ARG ADMIN_PASS
ARG APIGEE_USER
ARG APIGEE_PASS
ARG APIGEE_ORG

# install dependencies
RUN apt-get update
RUN apt-get install -y curl git ranger libpng-dev unzip vim sqlite3
RUN docker-php-ext-install gd bcmath

# install and setup drupal tools
WORKDIR /var/www
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN rm composer-setup.php
RUN mv composer.phar /usr/bin/composer

# create project
RUN composer create-project apigee/devportal-kickstart-project:8.x-dev portal --stability dev --no-interaction

# install drush
WORKDIR /var/www/portal
RUN composer require drush/drush
RUN yes | ./vendor/drush/drush/drush init

# install dependencies
RUN composer require drupal/swagger_ui_formatter drupal/apigee_m10n drupal/restui

# configure apache
RUN sed -i 's/DocumentRoot .*/DocumentRoot \/var\/www\/portal\/web/' /etc/apache2/sites-available/000-default.conf
RUN mkdir -p /var/www/portal/web/sites/default/files
ADD ./settings.php /var/www/portal/web/sites/default/settings.php 

# get swagger ui dependency
WORKDIR /var/www/portal/web
RUN mkdir -p libraries && curl -sSL https://github.com/swagger-api/swagger-ui/archive/v3.19.4.tar.gz -o swagger.tar.gz && tar -xvzf swagger.tar.gz && rm swagger.tar.gz  && mv swagger-ui-3.19.4 libraries/swagger_ui

# perform site install
RUN ../vendor/drush/drush/drush si apigee_devportal_kickstart --db-url=sqlite://sites/default/files/.ht.sqlite --site-name="Apigee Developer Portal" --account-name="$ADMIN_USER" --account-pass="$ADMIN_PASS" --no-interaction

# enable dependencies
RUN ../vendor/drush/drush/drush en rest restui basic_auth

# configure apigee connection credentials from environment variables
RUN ../vendor/drush/drush/drush config:set key.key.apigee_edge_connection_default key_provider apigee_edge_environment_variables --no-interaction

# import configuration files for rest module
ADD ./config ./config
RUN ../vendor/drush/drush/drush cim --partial --source=$(pwd)/config

# set permissions 
WORKDIR /var/www/portal
ADD ./set-permissions.sh ./set-permissions.sh
RUN chmod +x ./set-permissions.sh && ./set-permissions.sh --drupal_path=$(pwd)/web --drupal_user=root --httpd_group=www-data
