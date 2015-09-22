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

. $SWD/config/$CONFIG
test "$PASSWORD" && PASSWORD=" -p$PASSWORD "

DB_CONN="$CMD -u $ROOT_USER $ROOT_PASSWORD -h $HOST -P $PORT"

# mesg
echo
echo "Starting..."
echo

# grant privileges {{{

#echo "GRANT ALL ON `sample\_database\_%`.* TO '$USER'@'10.%' IDENTIFIED BY '$PASSWORD'" | $DB_CONN
#echo "GRANT ALL ON ${DATABASE}.* TO '$USER'@'localhost' IDENTIFIED BY '$PASSWORD'" | $DB_CONN
echo "GRANT ALL ON ${DATABASE}.* TO '$USER'@'%' IDENTIFIED BY '$PASSWORD'" | $DB_CONN
echo "FLUSH PRIVILEGES" | $DB_CONN

echo "  -> privileges on [ $DATABASE ] granted to user [ $USER ]."

# }}}

# mesg
echo
echo "Finished."
echo

exit 0
