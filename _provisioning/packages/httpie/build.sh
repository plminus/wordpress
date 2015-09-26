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

# https://github.com/jakubroztocil/httpie

# install pip {{{

sudo yum --enablerepo=epel -y install python-pip
sudo pip install --upgrade pip

# }}}
# install httpie {{{

sudo pip install --upgrade httpie

# }}}

exit 0
