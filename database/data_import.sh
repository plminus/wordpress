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

DUMP_FILE=${2:-""}
test ! "$DUMP_FILE"         && echo "(abort) DUMP_FILE must be specified"            && exit 1
test ! -f "$SWD/$DUMP_FILE" && echo "(abort) DUMP_FILE not found in $SWD/$DUMP_FILE" && exit 1

# mesg
echo
echo "Starting..."
echo

# drop and create database {{{

echo "DROP   DATABASE IF EXISTS $DATABASE" | $DB_CONN
echo "CREATE DATABASE $DATABASE CHARACTER SET utf8 COLLATE utf8_general_ci" | $DB_CONN

# }}}
# import dump_file {{{

#$DB_CONN $DATABASE < $SWD/$DUMP_FILE

file $SWD/$DUMP_FILE | grep 'gzip compressed' >/dev/null 2>&1
if [ $? -eq 0 ]; then
  gzip -dc $SWD/$DUMP_FILE | $DB_CONN $DATABASE
else
  $DB_CONN $DATABASE < $SWD/$DUMP_FILE
fi

echo "  -> dump_file [ $DUMP_FILE ] imported to database [ $DATABASE ]"

# }}}

# mesg
echo
echo "Finished."
echo

exit 0
