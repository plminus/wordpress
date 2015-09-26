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

# install newrelic-sysmond {{{

sudo yum --enablerepo=newrelic -y install newrelic-sysmond
sudo chkconfig newrelic-sysmond on

# }}}
# install newrelic_license.key {{{

#nrsysmond-config --set license_key=`cat /etc/newrelic/license.key`

# }}}
# prepare directories {{{

LIST=`cat <<_EOT_
/var/log/newrelic
_EOT_`

make_dirs "$LIST" 0755 newrelic:newrelic

# }}}
# start newrelic-sysmond {{{

#sudo service newrelic-sysmond start
#sudo service newrelic-sysmond status

# }}}

exit 0
