
# Use an official Python runtime as a parent image
FROM circleci/php:7.3-node-browsers

# Switch to root user
USER root

# Install necessary packages for PHP extensions
# RUN apt-get update && \
#   apt-get install -y \
#   dnsutils \
#   libzip-dev \
#   libsodium-dev \
#   libpng-dev \
#   libfreetype6-dev \
#   libjpeg62-turbo-dev \
#   zlib1g-dev \
#   libicu-dev \
#   g++

# # Add necessary PHP Extensions
# RUN docker-php-ext-configure intl
# RUN docker-php-ext-install intl

# RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
# RUN docker-php-ext-install gd

# RUN docker-php-ext-configure sodium
# RUN docker-php-ext-install sodium
# RUN pecl install libsodium-2.0.21

# RUN docker-php-ext-install bcmath

# # Set the memory limit to unlimited for expensive Composer interactions
# RUN echo "memory_limit=-1" > /usr/local/etc/php/conf.d/memory.ini

# ###########################
# # Install build tools things
# ###########################

# # Set the working directory to /build-tools-ci
# WORKDIR /build-tools-ci

# # Copy the current directory contents into the container at /build-tools-ci
# ADD . /build-tools-ci

# # Collect the components we need for this image
# RUN apt-get update
# RUN apt-get install -y ruby jq curl rsync nano
# RUN gem install circle-cli

# # Make sure we are on the latest version of Composer
# RUN composer selfupdate

# # Parallel Composer downloads
# RUN composer -n global require -n "hirak/prestissimo:^0.3"

# # ADD IN BACKSTOPJS

# ENV \
#   BACKSTOPJS_VERSION=5.4.3

# # Base packages
# RUN apt-get update && \
#   apt-get install -y git sudo software-properties-common

# RUN sudo npm install -g --unsafe-perm=true --allow-root backstopjs@${BACKSTOPJS_VERSION}

# # Add fs-extra
# RUN sudo npm install -g fs-extra

# RUN wget https://dl-ssl.google.com/linux/linux_signing_key.pub && sudo apt-key add linux_signing_key.pub
# RUN sudo add-apt-repository "deb http://dl.google.com/linux/chrome/deb/ stable main"

# RUN	apt-get -y update && apt-get -y install google-chrome-stable

# # RUN apt-get install -y firefox-esr

# RUN apt-get -qqy update \
#   && apt-get -qqy --no-install-recommends install \
#   libfontconfig \
#   libfreetype6 \
#   xfonts-cyrillic \
#   xfonts-scalable \
#   fonts-liberation \
#   fonts-ipafont-gothic \
#   fonts-wqy-zenhei \
#   && rm -rf /var/lib/apt/lists/* \
#   && apt-get -qyy clean

# # Install html validator
# RUN sudo npm i -g site-validator-cli

# # Create an unpriviliged test user
# RUN groupadd -g 999 tester && \
#   useradd -r -m -u 999 -g tester tester && \
#   chown -R tester /usr/local && \
#   chown -R tester /build-tools-ci
# USER tester

# # Install Terminus
# RUN mkdir -p /usr/local/share/terminus
# RUN /usr/bin/env COMPOSER_BIN_DIR=/usr/local/bin composer -n --working-dir=/usr/local/share/terminus require pantheon-systems/terminus:"^2"

# # Install CLU
# RUN mkdir -p /usr/local/share/clu
# RUN /usr/bin/env COMPOSER_BIN_DIR=/usr/local/bin composer -n --working-dir=/usr/local/share/clu require danielbachhuber/composer-lock-updater:^0.8.0

# # Install Drush
# RUN mkdir -p /usr/local/share/drush
# RUN /usr/bin/env composer -n --working-dir=/usr/local/share/drush require drush/drush "^8"
# RUN ln -fs /usr/local/share/drush/vendor/drush/drush/drush /usr/local/bin/drush
# RUN chmod +x /usr/local/bin/drush

# # Add a collection of useful Terminus plugins
# env TERMINUS_PLUGINS_DIR /usr/local/share/terminus-plugins
# RUN mkdir -p /usr/local/share/terminus-plugins
# RUN composer -n create-project --no-dev -d /usr/local/share/terminus-plugins pantheon-systems/terminus-build-tools-plugin:^2.0.0-beta17
# RUN composer -n create-project --no-dev -d /usr/local/share/terminus-plugins pantheon-systems/terminus-clu-plugin:^1.0.3
# RUN composer -n create-project --no-dev -d /usr/local/share/terminus-plugins pantheon-systems/terminus-secrets-plugin:^1.3
# RUN composer -n create-project --no-dev -d /usr/local/share/terminus-plugins pantheon-systems/terminus-rsync-plugin:^1.1
# RUN composer -n create-project --no-dev -d /usr/local/share/terminus-plugins pantheon-systems/terminus-quicksilver-plugin:^1.3
# RUN composer -n create-project --no-dev -d /usr/local/share/terminus-plugins pantheon-systems/terminus-composer-plugin:^1.1
# RUN composer -n create-project --no-dev -d /usr/local/share/terminus-plugins pantheon-systems/terminus-drupal-console-plugin:^1.1
# RUN composer -n create-project --no-dev -d /usr/local/share/terminus-plugins pantheon-systems/terminus-mass-update:^1.1
# RUN composer -n create-project --no-dev -d /usr/local/share/terminus-plugins pantheon-systems/terminus-aliases-plugin:^1.2
# RUN composer -n create-project --no-dev -d /usr/local/share/terminus-plugins pantheon-systems/terminus-site-clone-plugin:^2

# # Add hub in case anyone wants to automate GitHub PR creation, etc.
# RUN curl -LO https://github.com/github/hub/releases/download/v2.11.2/hub-linux-amd64-2.11.2.tgz && tar xzvf hub-linux-amd64-2.11.2.tgz && ln -s /build-tools-ci/hub-linux-amd64-2.11.2/bin/hub /usr/local/bin/hub

# # Add lab in case anyone wants to automate GitLab MR creation, etc.
# RUN curl -s https://raw.githubusercontent.com/zaquestion/lab/master/install.sh | bash

# # Add phpcs for use in checking code style
# RUN mkdir ~/phpcs && cd ~/phpcs && COMPOSER_BIN_DIR=/usr/local/bin composer require squizlabs/php_codesniffer:^2.7

# # Add phpunit for unit testing
# RUN mkdir ~/phpunit && cd ~/phpunit && COMPOSER_BIN_DIR=/usr/local/bin composer require phpunit/phpunit:^6

# # Add bats for functional testing
# RUN git clone https://github.com/sstephenson/bats.git; bats/install.sh /usr/local

# # Add Behat for more functional testing
# RUN mkdir ~/behat && \
#   cd ~/behat && \
#   COMPOSER_BIN_DIR=/usr/local/bin \
#   composer require \
#   "behat/behat:^3.5" \
#   "behat/mink:*" \
#   "behat/mink-extension:^2.2" \
#   "behat/mink-goutte-driver:^1.2" \
#   "drupal/drupal-extension:*"

# # Install A11y Machine Globally
# # RUN npm install -g the-a11y-machine

# # Install Pa11y Globally
# RUN npm install -g pa11y
# RUN npm install -g pa11y-ci
# RUN npm install -g pa11y-ci-reporter-html

# # Install Axe CLI Globally
# RUN npm install -g axe-cli

# RUN npm install -g markdown-to-html
