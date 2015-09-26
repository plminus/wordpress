#!/bin/bash
#set -e
#set -u
#set -x

CWD=`pwd`
SWD=`(cd \`dirname $0\` && pwd)`

# load functions
test ! "$FUNCTIONS" && FUNCTIONS="$SWD/../../.functions"
. $FUNCTIONS/*.sh

# trap
trap 'echo -e "\nabort\n" ; exit 1' 1 2 3 15

# install nginx {{{

if [ "$PLATFORM" != "aws" ]; then
  sudo yum --disablerepo=* --enablerepo=nginx -y install nginx
else
  sudo yum --disablerepo=amzn-main --enablerepo=nginx -y install nginx
  #sudo yum -y install nginx
fi
sudo chkconfig nginx on

# }}}
# prepare directories {{{

LIST=`cat <<_EOT_
/var/lib/nginx/cache
/var/lib/nginx/temp
/var/cache/nginx/client_temp
/var/cache/nginx/fastcgi_cache
/var/cache/nginx/fastcgi_temp
/var/cache/nginx/proxy_cache
/var/cache/nginx/proxy_temp
/var/cache/nginx/scgi_temp
/var/cache/nginx/uwsgi_temp
_EOT_`

make_dirs "$LIST" 0700 nginx:nginx

LIST=`cat <<_EOT_
/etc/nginx/auth
/etc/nginx/include
/etc/nginx/ssl
#/srv/html
/var/lib/nginx
/var/log/nginx
_EOT_`

make_dirs "$LIST" 0755 root:root

# }}}
# backup orig {{{

if [ ! -d /etc/nginx.orig ]; then
  sudo cp -Rp /etc/nginx /etc/nginx.orig
fi

# }}}
# copy files {{{

LIST=`cat <<_EOT_
etc/nginx/common_assets
etc/nginx/common_fallbacks
etc/nginx/common_healthcheck
etc/nginx/conf.d/default.conf
etc/nginx/conf.d/localhost.conf
#etc/nginx/conf.d/phpmyadmin.conf.orig
etc/nginx/fastcgi
etc/nginx/fastcgi_cache
etc/nginx/fastcgi_params
etc/nginx/gzip
etc/nginx/include/acl
etc/nginx/include/drop
etc/nginx/include/maint
etc/nginx/include/useragent
etc/nginx/nginx.conf
etc/nginx/nginx_status
etc/nginx/phpfpm_status
etc/nginx/proxy
etc/nginx/proxy_cache
_EOT_`

copy_files $SWD "$LIST" 0644 root:root

LIST=`cat <<_EOT_
etc/logrotate.d/nginx
_EOT_`

copy_files $SWD "$LIST" 0644 root:root

# }}}
# remove files {{{

LIST=`cat <<_EOT_
/etc/nginx/conf.d/example_ssl.conf
_EOT_`

remove_files "$LIST"

# }}}
# start nginx {{{

#sudo service nginx configtest && sudo service nginx start
#sudo service nginx status

# }}}

exit 0
