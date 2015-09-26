#!/bin/bash
#set -e
#set -u
#set -x

CWD=`pwd`
SWD=`(cd \`dirname $0\` && pwd)`

export FUNCTIONS=$SWD/.functions
export PLATFORM=aws

# trap
trap 'echo -e "\nabort\n" ; exit 1' 1 2 3 15

# run scripts {{{

$SWD/common/build.sh
$SWD/dotfiles/build.sh

$SWD/packages/httpie/build.sh
$SWD/packages/wrk/build.sh

# }}}

unset FUNCTIONS
unset PLATFORM

exit 0
