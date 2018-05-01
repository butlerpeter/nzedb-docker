#!/bin/bash

export COMPOSER_HOME=/root
export TERM=xterm

#chmod -R 777 /var/lib/php5

#cd /tmp
#php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
#php composer-setup.php
#php -r "unlink('composer-setup.php');"
#mv composer.phar /usr/local/bin/composer

# Setup the Composer installer.
curl -o /tmp/composer-setup.php https://getcomposer.org/installer && \
curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig && \
php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" && \
cd /tmp && \
php composer-setup.php --install-dir=/usr/local/bin --filename=composer

#if [[ ! -e /var/www/nZEDb/www/config.php ]]; then

#  echo "config.php does not exist. Cloning nZEDb..."
#  mkdir /var/www
#  cd /var/www
#  git clone https://github.com/nZEDb/nZEDb.git
#  chown www-data:www-data nZEDb/www -R
#  chmod 777 /var/www/nZEDb/libs/smarty/templates_c

#  chmod -R 777 /var/www/nZEDb/resources/covers/
#  chmod -R 777 /var/www/nZEDb/resources/nzb/
#  chmod -R 777 /var/www/nZEDb/resources/tmp/unrar/

#else

if [[ -e /var/www/nZEDb/configuration/config.php ]]; then

  croncmd="/usr/bin/php /var/www/nZEDb/cli/data/predb_import_daily_batch.php progress remote false"
  cronjob="0 7 * * * $croncmd"

  (crontab -l | grep -v "$croncmd" ; echo "$cronjob" ) | crontab -

  $croncmd

  croncmd="/usr/bin/php /var/www/nZEDb/misc/update/match_prefiles.php full"
  cronjob="*/60 * * * * $croncmd"

  (crontab -l | grep -v "$croncmd" ; echo "$cronjob" ) | crontab -

  $croncmd


  cd /var/www/nZEDb/misc/update/nix/tmux
  exec php start.php

fi
