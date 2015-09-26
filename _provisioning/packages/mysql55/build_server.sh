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

# install mysql55_server {{{

if [ "$PLATFORM" != "aws" ]; then
  packages=`cat <<'_EOT_'
  mysql-community-client
  mysql-community-common
  mysql-community-libs
  mysql-community-libs-compat
  mysql-community-server
_EOT_`

  sudo yum --enablerepo=mysql55-community -y install `echo $packages`
fi

# }}}
# install mysql55_server for aws {{{

if [ "$PLATFORM" = "aws" ]; then
  packages=`cat <<'_EOT_'
  mysql55
  mysql55-common
  mysql55-libs
  mysql55-server
_EOT_`

  sudo yum -y install `echo $packages`
fi

# }}}
# prepare directories {{{

LIST=`cat <<_EOT_
/var/run/mysqld
_EOT_`

make_dirs "$LIST" 0700 mysql:mysql

# }}}
# copy files {{{

LIST=`cat <<_EOT_
etc/logrotate.d/mysql
etc/my.cnf
_EOT_`

copy_files $SWD "$LIST" 0644 root:root

# }}}
# start   mysql55_server {{{

sudo chkconfig mysqld on

# start mysqld
#sudo service mysqld start
#sudo service mysqld status

# }}}

exit 0
