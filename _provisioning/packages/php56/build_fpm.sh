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

# install php56-fpm {{{

sudo yum --enablerepo=remi-php56,remi -y install php-fpm
sudo chkconfig php-fpm on

# }}}
# prepare directories {{{

LIST=`cat <<_EOT_
/var/lib/php/session
/var/lib/php/wsdlcache
_EOT_`

make_dirs "$LIST" 0777 root:root

LIST=`cat <<_EOT_
/var/run/php-fpm
_EOT_`

make_dirs "$LIST" 0755 root:root

LIST=`cat <<_EOT_
/var/log/php-fpm
_EOT_`

make_dirs "$LIST" 0755 nginx:nginx

# }}}
# copy files {{{

LIST=`cat <<_EOT_
etc/php-fpm.conf
etc/php-fpm.d/www.conf
_EOT_`

copy_files $SWD "$LIST" 0644 root:root

# }}}
# start php-fpm {{{

sudo service php-fpm configtest && sudo service php-fpm start
sudo service php-fpm status

# }}}

# disable httpd {{{

which httpd >/dev/null 2>&1
if [ $? -eq 0 ]; then
  sudo chkconfig httpd off
  sudo service   httpd stop 2>/dev/null
fi

# }}}

exit 0
