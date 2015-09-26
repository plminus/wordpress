#!/bin/bash
#set -e
#set -u
#set -x

CWD=`pwd`
SWD=`(cd \`dirname $0\` && pwd)`

# load functions
test ! "$FUNCTIONS" && FUNCTIONS="$SWD/../../.functions"
. $FUNCTIONS/*.sh

APP_REPO="git@github.com:plminus/wordpress.git"
APP_BRANCH="develop"
APP_DIR="/var/www/vhosts"
APP_NAME="wordpress"

DEVOPS_BRANCH="devops"
SCRIPTS_BRANCH="scripts"
HTML_BRANCH="html"

SRV_DIR="srv"

DB_USER="root"
DB_PASS=""
DB_HOST="localhost"
DB_NAME="wordpress_development"

ME=$(whoami)

# trap
trap 'echo -e "\nabort\n" ; exit 1' 1 2 3 15

# set motd
# set motd {{{

if [ "$PLATFORM" != "aws" ]; then
  sudo bash -c "cat $SWD/etc/motd > /etc/motd"
  sudo chmod 0644 /etc/motd
fi

# }}}

# .bash_include_plminus
# create alias {{{

cat <<_EOT_ > $HOME/.bash_include_plminus
alias pps='git push ; git pull ; git st'

alias conn_dbm='mysql -u $DB_USER $DB_PASS -h $DB_HOST '
alias conn_db1='mysql -u $DB_USER $DB_PASS -h $DB_HOST $DB_NAME '

alias ggg='sudo goaccess -f /var/log/nginx/ap.access.log -p /etc/goaccess/ltsv.nginx'
_EOT_

# }}}

# set crontab
# copy files {{{

LIST=`cat <<_EOT_
home/ec2-user/crontab.txt
_EOT_`

copy_files $SWD "$LIST" 0644 $ME:$ME

# }}}
# set crontab {{{

crontab /home/$ME/crontab.txt

# }}}

# devops
# git clone {{{

make_dirs "/$SRV_DIR" 2775 $ME:$ME

cd /$SRV_DIR
if [ ! -d ./$DEVOPS_BRANCH ]; then
  git clone -b $DEVOPS_BRANCH $APP_REPO $DEVOPS_BRANCH
else
  cd ./$DEVOPS_BRANCH
  git pull
fi
cd $CWD

# }}}

# scripts
# git clone {{{

make_dirs "/$SRV_DIR" 2775 $ME:$ME

cd /$SRV_DIR
if [ ! -d ./$SCRIPTS_BRANCH ]; then
  git clone -b $SCRIPTS_BRANCH $APP_REPO $SCRIPTS_BRANCH
else
  cd ./$SCRIPTS_BRANCH
  git pull
fi
cd $CWD

# }}}

# html
# git clone {{{

make_dirs "/$SRV_DIR" 2775 $ME:$ME

cd /$SRV_DIR
if [ ! -d ./html ]; then
  git clone -b $HTML_BRANCH $APP_REPO html
else
  cd ./html
  git pull
fi
cd $CWD

# }}}

# wordpress
# git clone {{{

make_dirs "$APP_DIR"         2775 $ME:nginx
make_dirs "$APP_DIR/uploads" 2775 $ME:nginx

cd $APP_DIR
if [ ! -d ./$APP_NAME ]; then
  git clone -b $APP_BRANCH $APP_REPO $APP_NAME
  sudo chmod 2775 ./$APP_NAME
  sudo chown -R $ME:nginx ./$APP_NAME
  find ./$APP_NAME -type d | xargs -n 1 chmod ug+rwx
  find ./$APP_NAME -type f | xargs -n 1 chmod ug+rw
else
  cd ./$APP_NAME
  git pull
fi

cd $APP_DIR/$APP_NAME
cp -fp ./robots.box.txt    ./robots.txt
cp -fp ./wp-config.box.php ./wp-config.php

cd $CWD

# }}}
# fix permissions {{{

cd $APP_DIR
sudo chown -R $ME:nginx ./
sudo chmod -R g+rw      ./
sudo bash -c 'find . -type d | xargs -n 1 chmod 2775'

cd $CWD

# }}}

# purge garbages
# purge files {{{

PURGE_LIST=`cat <<_EOT_
var/log/newrelic/*
var/log/nginx/*
var/log/php-fpm/*
_EOT_`

if [ ! -f /tmp/.purged ]; then
  for i in $PURGE_LIST
  do
    echo $i | grep -e "^$" -e "^#" >/dev/null 2>&1
    test $? -eq 0 && continue

    sudo rm -rfv /$i 2>/dev/null
    touch /tmp/.purged
  done
fi

# }}}

# percona
# copy files {{{

LIST=`cat <<_EOT_
etc/logrotate.d/mysql
etc/my.cnf
_EOT_`

copy_files $SWD "$LIST" 0644 root:root

# }}}
# setup database {{{

sudo test -e /var/lib/mysql/mysql
if [ $? -ne 0 ]; then
  sudo mysql_install_db
  sudo chown -R mysql:mysql /var/lib/mysql
  sudo chmod 755 /var/lib/mysql
fi

# }}}
# restart mysql {{{

sudo service mysql restart
sudo service mysql status

# }}}
# upgrade database {{{

sudo test -e /var/lib/mysql/mysql_upgrade_info
if [ $? -ne 0 ]; then
  sleep 5
  sudo mysql_upgrade
  sudo chown -R mysql:mysql /var/lib/mysql
  sudo chmod 755 /var/lib/mysql
fi

# }}}

# php-pecl-redis
# install php-pecl-redis {{{

packages=`cat <<'_EOT_'
php-pecl-redis
_EOT_`

sudo yum --enablerepo=remi-php56,remi -y install `echo $packages`

# }}}

# php
# copy files {{{

LIST=`cat <<_EOT_
etc/php.ini
etc/php.d/10-opcache.ini
etc/php.d/40-apcu.ini
etc/php.d/opcache-default.blacklist
_EOT_`

copy_files $SWD "$LIST" 0644 root:root

# }}}

# php-fpm
# copy files {{{

LIST=`cat <<_EOT_
etc/php.ini
etc/php-fpm.conf
etc/php-fpm.d/www.conf
#etc/php-fpm.d/phpMyAdmin.conf
_EOT_`

copy_files $SWD "$LIST" 0644 root:root

# }}}
# restart php-fpm {{{

sudo service php-fpm restart
sudo service php-fpm status

# }}}

# nginx
# copy files {{{

LIST=`cat <<_EOT_
etc/nginx/auth/htpasswd
etc/nginx/common_assets
etc/nginx/common_fallbacks
etc/nginx/common_healthcheck
etc/nginx/conf.d/default.conf
etc/nginx/conf.d/dev.server.conf
etc/nginx/conf.d/localhost.conf
etc/nginx/fastcgi
etc/nginx/fastcgi_cache
etc/nginx/fastcgi_cache.tmpl
etc/nginx/fastcgi_params
etc/nginx/gzip
etc/nginx/include/acl
etc/nginx/include/drop
etc/nginx/include/maint
etc/nginx/include/mobile-detect
etc/nginx/include/useragent
etc/nginx/nginx.conf
etc/nginx/nginx_status
etc/nginx/phpfpm_status
etc/nginx/proxy
etc/nginx/proxy_cache
etc/nginx/proxy_cache.tmpl
etc/nginx/wp-multisite-subdir
etc/nginx/wp-singlesite
_EOT_`

copy_files $SWD "$LIST" 0644 root:root

# }}}
# copy files {{{

LIST=`cat <<_EOT_
etc/nginx/ssl/server.crt
etc/nginx/ssl/server.key
etc/nginx/ssl/server.nokey
_EOT_`

copy_files $SWD "$LIST" 0644 root:root

# }}}
# restart nginx {{{

sudo service nginx configtest && sudo service nginx restart
sudo service nginx status

# }}}

# redis
# start redis {{{

sudo service redis start
sudo service redis status

# }}}

# fail2ban
# copy files {{{

LIST=`cat <<_EOT_
etc/fail2ban/action.d/slack.conf
etc/fail2ban/jail.local
_EOT_`

copy_files $SWD "$LIST" 0644 root:root

# }}}
# restart fail2ban {{{

sudo service fail2ban restart
sudo service fail2ban status

# }}}

# slack
# copy files {{{

LIST=`cat <<_EOT_
usr/local/bin/slack
_EOT_`

copy_files $SWD "$LIST" 0755 root:root

# }}}

# vvv
# copy files {{{

LIST=`cat <<_EOT_
usr/local/bin/vvv
_EOT_`

copy_files $SWD "$LIST" 0755 root:root

# }}}

exit 0
