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

# install fail2ban {{{

sudo yum --enablerepo=epel -y install fail2ban
sudo chkconfig fail2ban on

# }}}
# prepare directories {{{

LIST=`cat <<_EOT_
/var/log/fail2ban
_EOT_`

make_dirs "$LIST" 0755 root:root

# }}}
# copy files {{{

LIST=`cat <<_EOT_
etc/fail2ban/action.d/slack.conf
etc/fail2ban/fail2ban.conf
etc/fail2ban/jail.local
etc/logrotate.d/fail2ban
_EOT_`

copy_files $SWD "$LIST" 0644 root:root

if [ ! -f /etc/fail2ban/filter.d/nginx-http-auth.conf ]; then 
  sudo cp -f $SWD/etc/fail2ban/filter.d/nginx-http-auth.conf /etc/fail2ban/filter.d/
  sudo chmod 0644 /etc/fail2ban/filter.d/nginx-http-auth.conf
  sudo chown root:root /etc/fail2ban/filter.d/nginx-http-auth.conf
fi

# }}}
# start fail2ban {{{

sudo service fail2ban start
sudo service fail2ban status

# }}}

exit 0
