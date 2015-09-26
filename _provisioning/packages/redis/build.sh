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

# install redis {{{

sudo yum                    --enablerepo=epel -y install jemalloc jemalloc-devel
sudo yum --disablerepo=epel --enablerepo=remi -y install redis

sudo chkconfig redis on

# }}}
# start redis {{{

#sudo service redis start
#sudo service redis status

# }}}

exit 0
