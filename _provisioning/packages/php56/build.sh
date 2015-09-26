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

# install php56 {{{

sudo yum --enablerepo=remi-php56,remi -y install php php-devel

# }}}

# disable httpd {{{

which httpd >/dev/null 2>&1
if [ $? -eq 0 ]; then
  sudo chkconfig httpd off
  sudo service   httpd stop 2>/dev/null
fi

# }}}

exit 0
