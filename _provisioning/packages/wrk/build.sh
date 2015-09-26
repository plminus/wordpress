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

# install wrk {{{

test -f /usr/bin/wrk && exit 0

cd /usr/local/src
if [ ! -d ./wrk ]; then
  sudo git clone https://github.com/wg/wrk.git
else
  sudo git pull
  sudo make clean
fi

cd ./wrk
sudo make
sudo cp -fp ./wrk /usr/bin/

# }}}

exit 0
