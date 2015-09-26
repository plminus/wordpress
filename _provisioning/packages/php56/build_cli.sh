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

# install php56-cli {{{

# http://www.karakaram.com/yum-update-php54-to-php55
packages=`cat <<'_EOT_'
php-common
php-cli
php-bcmath
php-mbstring
php-mcrypt
php-mysqlnd
php-odbc
php-opcache
php-pdo
php-pear
php-pecl-apcu
php-pecl-jsonc
php-pecl-jsonc-devel
php-pecl-zip
php-process
php-soap
php-tidy
php-xml
php-xmlrpc
_EOT_`

sudo yum --enablerepo=remi-php56,remi -y install `echo $packages`

# }}}
# install pear libraries {{{

packages=`cat <<'_EOT_'
Mail_Mime
Mail_mimeDecode
_EOT_`

sudo pear upgrade `echo $packages`

# }}}
# copy files {{{

LIST=`cat <<_EOT_
etc/php.d/10-opcache.ini
etc/php.d/40-apcu.ini
etc/php.ini
_EOT_`

copy_files $SWD "$LIST" 0644 root:root

# }}}

# disable httpd {{{

which httpd >/dev/null 2>&1
if [ $? -eq 0 ]; then
  sudo chkconfig httpd off
  sudo service   httpd stop 2>/dev/null
fi

# }}}

exit 0
