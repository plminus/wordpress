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

# install goaccess {{{

sudo yum --enablerepo=epel -y install GeoIP GeoIP-devel goaccess

# }}}
# prepare directories {{{

LIST=`cat <<_EOT_
/etc/goaccess
_EOT_`

make_dirs "$LIST" 0755 root:root

# }}}
# copy files {{{

LIST=`cat <<_EOT_
etc/goaccess/ltsv.fluentd.httpd
etc/goaccess/ltsv.fluentd.nginx
etc/goaccess/ltsv.httpd
etc/goaccess/ltsv.nginx
_EOT_`

copy_files $SWD "$LIST" 0644 root:root

# }}}

exit 0
