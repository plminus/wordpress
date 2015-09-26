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

# install mysql55_client {{{

if [ "$PLATFORM" != "aws" ]; then
  packages=`cat <<'_EOT_'
  mysql-community-client
  mysql-community-common
  mysql-community-libs
  mysql-community-libs-compat
  mysql-community-devel
_EOT_`

  sudo yum --enablerepo=mysql55-community -y install `echo $packages`
fi

# }}}
# install mysql55_client for aws {{{

if [ "$PLATFORM" = "aws" ]; then
  packages=`cat <<'_EOT_'
  mysql55
  mysql55-common
  mysql55-libs
  mysql55-devel
_EOT_`

  sudo yum -y install `echo $packages`
fi

# }}}

exit 0
