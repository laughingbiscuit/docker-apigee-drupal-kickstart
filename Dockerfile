FROM drupal:8-apache

# install dependencies
RUN apt-get update
RUN apt-get install -y curl git ranger libpng-dev unzip nginx
RUN docker-php-ext-install gd

WORKDIR /root

# install and setup drupal tools
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN rm composer-setup.php
RUN mv composer.phar /usr/bin/composer

# create project
RUN composer create-project apigee/devportal-kickstart-project:8.x-dev portal --stability dev --no-interaction

# install drush
RUN composer require drush/drush
RUN ./vendor/drush/drush/drush init

CMD nginx && php portal/web/core/scripts/drupal quick-start -n 
