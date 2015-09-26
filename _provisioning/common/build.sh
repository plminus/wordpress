#!/bin/bash
#set -e
#set -u
#set -x

CWD=`pwd`
SWD=`(cd \`dirname $0\` && pwd)`

# load functions
test ! "$FUNCTIONS" && FUNCTIONS="$SWD/../.functions"
. $FUNCTIONS/*.sh

# trap
trap 'echo -e "\nabort\n" ; exit 1' 1 2 3 15

# disable selinux {{{

which getenforce >/dev/null 2>&1
if [ $? -eq 0 ]; then
  sudo bash -c "cat $SWD/etc/selinux/config > /etc/selinux/config"
  sudo setenforce 0
  sudo getenforce
fi

# }}}
# set timezone to JST {{{

( cd /etc && sudo ln -nfs /usr/share/zoneinfo/Asia/Tokyo localtime )

sudo bash -c 'echo ZONE=\"Asia/Tokyo\" >  /etc/sysconfig/clock'
sudo bash -c 'echo UTC=true            >> /etc/sysconfig/clock'

date

# }}}
# set parameters to sysctl.conf {{{

test ! -f /etc/sysctl.conf.orig && sudo cp /etc/sysctl.conf /etc/sysctl.conf.orig
sudo bash -c "cat $SWD/etc/sysctl.conf > /etc/sysctl.conf"
sudo chmod 0644 /etc/sysctl.conf
sudo sysctl -p

# }}}
# set limits.conf {{{

sudo bash -c "cat $SWD/etc/security/limits.conf > /etc/security/limits.conf"
sudo chmod 0644 /etc/security/limits.conf

# }}}
# set profile.d {{{

sudo bash -c "cat $SWD/etc/profile.d/ext_path.sh > /etc/profile.d/ext_path.sh"
sudo chmod 0644 /etc/profile.d/ext_path.sh

test -f ~/.bash_profile && . ~/.bash_profile
test -f ~/.bashrc       && . ~/.bashrc

# }}}
# set sshd_config {{{

sshd_config=/etc/ssh/sshd_config

#sudo sed -i 's/^\(ChallengeResponseAuthentication yes\)/#\1/' $sshd_config
#sudo sed -i 's/^\(PasswordAuthentication yes\)/#\1/'          $sshd_config
#sudo sed -i 's/^\(X11Forwarding yes\)/#\1/'                   $sshd_config
#sudo sed -i 's/^\(UseDNS yes\)/#\1/'                          $sshd_config

sudo sed -i '/^ChallengeResponseAuthentication yes/d' $sshd_config
sudo sed -i '/^PasswordAuthentication yes/d'          $sshd_config
sudo sed -i '/^X11Forwarding yes/d'                   $sshd_config
sudo sed -i '/^UseDNS yes/d'                          $sshd_config

sudo tail -n 1 $sshd_config | grep ^$ >/dev/null 2>&1
test $? -ne 0 && sudo bash -c "echo >> $sshd_config"

sudo grep "^ChallengeResponseAuthentication no" $sshd_config >/dev/null 2>&1
test $? -ne 0 && sudo bash -c "echo 'ChallengeResponseAuthentication no' >> $sshd_config"

sudo grep "^PasswordAuthentication no" $sshd_config >/dev/null 2>&1
test $? -ne 0 && sudo bash -c "echo 'PasswordAuthentication no' >> $sshd_config"

sudo grep "^X11Forwarding no" $sshd_config >/dev/null 2>&1
test $? -ne 0 && sudo bash -c "echo 'X11Forwarding no' >> $sshd_config"

sudo grep "^UseDNS no" $sshd_config >/dev/null 2>&1
test $? -ne 0 && sudo bash -c "echo 'UseDNS no' >> $sshd_config"

sudo tail -n 1 $sshd_config | grep ^$ >/dev/null 2>&1
test $? -ne 0 && sudo bash -c "echo >> $sshd_config"

sudo service sshd reload

# }}}
# set sudoers.d {{{

sudo bash -c "cat $SWD/etc/sudoers.d/sys-init > /etc/sudoers.d/sys-init"
sudo chmod 0440 /etc/sudoers.d/sys-init

# }}}
# set motd {{{

if [ "$PLATFORM" != "aws" ]; then
  sudo bash -c "cat $SWD/etc/motd > /etc/motd"
  sudo chmod 0644 /etc/motd
fi

# }}}

# install repos {{{

if [ "$PLATFORM" != "aws" ]; then
  sudo yum -y install epel-release
fi
rpm_localinstall http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm_localinstall http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
rpm_localinstall https://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
rpm_localinstall http://www.percona.com/redir/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
rpm_localinstall http://download.newrelic.com/pub/newrelic/el5/i386/newrelic-repo-5-3.noarch.rpm

# }}}
# install yum.repos.d {{{

test "$PLATFORM" != "aws" && REPOS=$(find $SWD/etc/yum.repos.d             -name \*.repo -type f)
test "$PLATFORM"  = "aws" && REPOS=$(find $SWD/etc/yum.repos.d -maxdepth 1 -name \*.repo -type f)

for i in $REPOS
do
  sudo cp -fv $i /etc/yum.repos.d/
done
sudo chown -R root:root /etc/yum.repos.d/*

# }}}
# install yum packages {{{

sudo yum clean all
sudo yum --enablerepo=epel -y upgrade

packages=`cat <<'_EOT_'
p7zip
p7zip-plugins
autoconf
automake
bash-completion
bind-utils
bzip2
crontabs
curl-devel
dstat
ed
file
file-devel
file-libs
fop
gcc
gcc-c++
gettext
git
gpm
gpm-libs
htop
inotify-tools
java-1.8.0-openjdk
java-1.8.0-openjdk-devel
kernel-devel
kernel-headers
libevent
libevent-devel
libffi
libffi-devel
libjpeg
libmcrypt
libpng
libtool
libxml2
libxml2-devel
libxslt
libxslt-devel
libyaml
mailx
make
nc
ncurses
ncurses-devel
ntp
ntpdate
openssl
openssl-devel
readline
readline-devel
rsync
sharutils
sysstat
time
tmux
tree
unixODBC
unixODBC-devel
unzip
vim
wget
xz
yum-plugin-fastestmirror
yum-plugin-priorities
yum-plugin-security
zip
zlib
zlib-devel
_EOT_`

sudo yum --enablerepo=epel -y install `echo $packages`

# }}}
# install ext packages {{{

# tig
if [ "$PLATFORM" != "aws" ]; then
  sudo yum --disablerepo=epel --enablerepo=rpmforge -y install tig
else
  sudo yum -y install tig
fi

# the-silver-searcher
rpm_localinstall http://swiftsignal.com/packages/centos/6/x86_64/the-silver-searcher-0.14-1.el6.x86_64.rpm

# jq
BIN_JQ='http://stedolan.github.io/jq/download/linux64/jq'
sudo bash -c "curl -Lk $BIN_JQ > /usr/bin/jq"
sudo chown root:root /usr/bin/jq
sudo chmod 0755 /usr/bin/jq

# }}}
# switch the version of java to use {{{

# http://d.hatena.ne.jp/torazuka/20110622/alternatives
# http://pradyumnajoshi.blogspot.jp/2015/02/elasticsearch-exception-in-thread-main.html

#sudo alternatives --config  java
#sudo alternatives --display java

latest_java=$(basename $(find /usr/lib/jvm -maxdepth 1 -type d | grep openjdk | sort -r | head -n 1))
latest_java_ver=$(echo $latest_java | sed 's/^java-\([0-9\.]*\)-openjdk.*/\1/' | sed 's/\.//g')0

# set priority
sudo alternatives --install /usr/bin/java java /usr/lib/jvm/$latest_java/jre/bin/java $latest_java_ver

# switch the version of java to use according to priority
sudo update-alternatives --auto java

# }}}

exit 0
