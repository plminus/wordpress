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

# install pip {{{

sudo yum --enablerepo=epel -y install python-pip
sudo pip install --upgrade pip

# }}}
# install newrelic-plugin-agent {{{

sudo pip install --upgrade newrelic-plugin-agent

sudo cp /opt/newrelic-plugin-agent/newrelic-plugin-agent.rhel /etc/rc.d/init.d/newrelic-plugin-agent
sudo sed -i "s/^APP=.\+$/APP=\"$(which newrelic-plugin-agent | sed 's/\//\\\//g')\"/" /etc/rc.d/init.d/newrelic-plugin-agent
sudo chmod 755       /etc/rc.d/init.d/newrelic-plugin-agent
sudo chown root:root /etc/rc.d/init.d/newrelic-plugin-agent

sudo chkconfig newrelic-plugin-agent on

# }}}
# copy configuration {{{

config_file="newrelic-plugin-agent.cfg"
if [ ! -f /etc/newrelic/newrelic-plugin-agent.cfg ]; then
  sudo cp /opt/newrelic-plugin-agent/$config_file /etc/newrelic/$config_file
fi

# }}}
# edit /etc/newrelic/newrelic-plugin-agent.cfg {{{

#license_key=`cat /etc/newrelic/license.key`
#str='  license_key:'
#sudo sed -i "s/^$str .\+$/$str $license_key/" /etc/newrelic/newrelic-plugin-agent.cfg

# }}}
# start newrelic-plugin-agent {{{

#sudo service newrelic-plugin-agent start
#sudo service newrelic-plugin-agent status

# }}}

exit 0
