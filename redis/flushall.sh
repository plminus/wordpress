#!/bin/bash
#set -x
#set -e
#set -u

CWD=`pwd`
SWD=`(cd \`dirname $0\` && pwd)`

# trap
trap 'echo -e "\nabort\n" ; exit 1' 1 2 3 15

CMD=`which redis-cli`

# mesg
echo
echo "Starting..."
echo

# flushall {{{

echo "FLUSHALL" | $CMD

echo "  -> cache has been flushed."

# }}}

# mesg
echo
echo "Finished."
echo

exit 0
