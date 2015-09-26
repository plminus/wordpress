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

# install Percona-Server-server-56 {{{

packages=`cat <<'_EOT_'
Percona-Server-client-56
Percona-Server-devel-56
Percona-Server-shared-56
Percona-Server-server-56
Percona-Server-shared-compat
percona-toolkit
percona-xtrabackup
_EOT_`

sudo yum --enablerepo=percona -y install `echo $packages`

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
# start   Percona-Server-server-56 {{{

sudo chkconfig mysql on

# start mysql
#sudo service mysql start
#sudo service mysql status

# }}}

exit 0
