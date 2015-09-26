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

# install dotfiles {{{

PATH_TO_DOTFILES=${1:-""}
test !    "$PATH_TO_DOTFILES" && PATH_TO_DOTFILES="/vagrant/dotfiles"
test ! -d "$PATH_TO_DOTFILES" && PATH_TO_DOTFILES="/vagrant/dotfiles"

cp -Rp $PATH_TO_DOTFILES/.[A-Za-z]* ~/

chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_rsa*
chmod 644 ~/.ssh/*.pub

test "$PLATFORM" = "aws"  && test -f ~/.aws/config.iam && cp -f ~/.aws/config.iam ~/.aws/config
test -f ~/.aws/config.iam && rm   -f ~/.aws/config.iam

# reload
test -f ~/.bash_profile && . ~/.bash_profile
test -f ~/.bashrc       && . ~/.bashrc

# }}}

exit 0
