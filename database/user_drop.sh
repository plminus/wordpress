#!/bin/bash
#set -e
#set -u
#set -x

CWD=`pwd`
SWD=`(cd \`dirname $0\` && pwd)`

# trap
trap 'echo -e "\nabort\n" ; exit 1' 1 2 3 15

CMD=`which mysql`

CONFIG=${1:-""}
test ! "$CONFIG"                && echo "(abort) CONFIG must be specified"        && exit 1
test ! -f "$SWD/config/$CONFIG" && echo "(abort) CONFIG not found in $SWD/config" && exit 1

. $SWD/config/$CONFIG
test "$PASSWORD"      && PASSWORD=" -p$PASSWORD "
test "$ROOT_PASSWORD" && ROOT_PASSWORD=" -p$ROOT_PASSWORD "

DB_CONN="$CMD -u $ROOT_USER $ROOT_PASSWORD -h $HOST -P $PORT"

# mesg
echo
echo "Starting..."
echo

# drop user {{{

#echo "DROP USER '$USER'@'localhost'" | $DB_CONN
echo "DROP USER '$USER'" | $DB_CONN

echo "  -> user [ $USER ] dropped."

# }}}

# mesg
echo
echo "Finished."
echo

exit 0
