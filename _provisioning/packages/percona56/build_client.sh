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

# install Percona-Server-client-56 {{{

packages=`cat <<'_EOT_'
Percona-Server-client-56
Percona-Server-devel-56
Percona-Server-shared-56
Percona-Server-shared-compat
percona-toolkit
percona-xtrabackup
_EOT_`

sudo yum --enablerepo=percona -y install `echo $packages`

# }}}

exit 0
