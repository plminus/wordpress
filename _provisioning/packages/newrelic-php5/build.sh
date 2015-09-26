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

# install newrelic-php5 {{{

sudo yum --enablerepo=newrelic -y install newrelic-php5
sudo chkconfig newrelic-daemon on

# }}}
# copy configuration {{{

config_file="newrelic.cfg"
if [ ! -f /etc/newrelic/newrelic.cfg ]; then
  sudo cp /etc/newrelic/$config_file.template /etc/newrelic/$config_file
fi

# }}}
# edit /etc/php.d/newrelic.ini {{{

# Manually starting newrelic-daemon (External mode)
# LincenseKey must be set in /etc/newrelic/newrelic.cfg
# https://docs.newrelic.com/docs/agents/php-agent/advanced-installation/starting-php-daemon-advanced

#license_key=`cat /etc/newrelic/license.key`
#str='newrelic.license ='
#sudo sed -i "s/^$str .\+$/$str \"$license_key\"/" /etc/php.d/newrelic.ini

grep "^newrelic.daemon.dont_launch = 3" /etc/php.d/newrelic.ini >/dev/null 2>&1
if [ $? -ne 0 ]; then
  str='newrelic.daemon.dont_launch'
  sudo sed -i  "/^;$str = 0/a $str = 3" /etc/php.d/newrelic.ini
fi

# }}}
# start newrelic-daemon {{{

#sudo service newrelic-daemon start
#sudo service newrelic-daemon status

# }}}


exit 0
