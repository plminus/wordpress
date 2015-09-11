#!/bin/bash
#set -x
#set -e
#set -u

CWD=`pwd`
SWD=`(cd \`dirname $0\` && pwd)`

# trap
trap 'echo -e "\nabort\n" ; exit 1' 1 2 3 15

CMD=`which mysql`

CONFIG=${1:-""}
test ! "$CONFIG"                && echo "(abort) CONFIG must be specified"        && exit 1
test ! -f "$SWD/config/$CONFIG" && echo "(abort) CONFIG not found in $SWD/config" && exit 1

. $SWD/$CONFIG
test "$PASSWORD" && PASSWORD=" -p$PASSWORD "

DB_CONN="$CMD -u $ROOT_USER $ROOT_PASSWORD -h $HOST -P $PORT"

# mesg
echo
echo "Starting..."
echo

# drop anonymous user {{{

echo "DELETE FROM mysql.user WHERE user=''" | $DB_CONN

echo "  -> anonymous user dropped."

# }}}

# mesg
echo
echo "Finished."
echo

exit 0
