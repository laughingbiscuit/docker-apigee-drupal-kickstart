FROM drupal:8-apache

# install dependencies
RUN apt-get update
RUN apt-get install -y curl git ranger libpng-dev unzip vim sqlite3
RUN docker-php-ext-install gd
## adding bcmath extension
RUN docker-php-ext-install bcmath

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
RUN composer require drupal/swagger_ui_formatter

# configure apache
RUN sed -i 's/DocumentRoot .*/DocumentRoot \/var\/www\/portal\/web/' /etc/apache2/sites-available/000-default.conf
RUN mkdir -p /var/www/portal/web/sites/default/files
RUN cp /var/www/portal/web/sites/default/default.settings.php /var/www/portal/web/sites/default/settings.php 

# get swagger ui dependency
WORKDIR /var/www/portal/web
RUN mkdir -p libraries && curl -sSL https://github.com/swagger-api/swagger-ui/archive/v3.19.4.tar.gz -o swagger.tar.gz && tar -xvzf swagger.tar.gz && rm swagger.tar.gz  && mv swagger-ui-3.19.4 libraries/swagger_ui

# adding monetization module
WORKDIR /var/www/portal
RUN composer require drupal/apigee_m10n

# set permissions and allow settings.php to be writable during installation. make sure you set it back to 644 afterwards!
WORKDIR /var/www/portal
ADD ./set-permissions.sh ./set-permissions.sh
RUN chmod +x ./set-permissions.sh && ./set-permissions.sh --drupal_path=$(pwd)/web --drupal_user=root --httpd_group=www-data
RUN chmod 777 ./web/sites/default/settings.php 



