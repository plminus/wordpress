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

# check PLATFORM {{{

test "$PLATFORM" = "aws" && exit 0

# }}}
# install python-pip {{{

packages=`cat <<'_EOT_'
python-setuptools
python-devel
python-pip
_EOT_`

sudo yum --enablerepo=epel -y install `echo $packages`
sudo pip install --upgrade pip

# }}}
# install awscli {{{

sudo pip install --upgrade awscli

# }}}

exit 0
