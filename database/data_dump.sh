#!/bin/bash
#set -x
#set -e
#set -u

CWD=`pwd`
SWD=`(cd \`dirname $0\` && pwd)`

# trap
trap 'echo -e "\nabort\n" ; exit 1' 1 2 3 15

CMD=`which mysqldump`

CONFIG=${1:-""}
test ! "$CONFIG"                && echo "(abort) CONFIG must be specified"        && exit 1
test ! -f "$SWD/config/$CONFIG" && echo "(abort) CONFIG not found in $SWD/config" && exit 1

. $SWD/config/$CONFIG
test "$PASSWORD" && PASSWORD=" -p$PASSWORD "

DUMP_FILE=${DATABASE}_$(date +%Y%m%d_%H%M).dump.gz

# mesg
echo
echo "Starting..."
echo

# dump and archive database {{{

$CMD -u $USER $PASSWORD \
        -h $HOST \
        -P $PORT \
        --opt \
        --no-create-db \
        --default-character-set=binary \
        $DATABASE | gzip -c > $SWD/$DUMP_FILE

echo "  -> database dumped [ $SWD/$DUMP_FILE ]"

# }}}

# mesg
echo
echo "Finished."
echo

exit 0
