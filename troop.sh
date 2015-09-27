#!/bin/bash
#set -x
#set -e
#set -u

CWD=`pwd`
SWD=`(cd \`dirname $0\` && pwd)`

# trap
trap 'echo -e "\nabort\n" ; exit 1' 1 2 3 15

# prepare files {{{

# remove first
echo
echo -n "-> removing existing files... "
test -d $SWD/dotfiles     && rm -rf $SWD/dotfiles
test -d $SWD/provisioning && rm -rf $SWD/provisioning
echo "done"

# then copy
echo -n "-> copying fresh files... "
cp -Rp $SWD/../../_dotfiles     $SWD/dotfiles
cp -Rp $SWD/../../_provisioning $SWD/provisioning

# optional
if [ "$1" = "-m" ]; then
  test -f $HOME/.gitconfig      && cat $HOME/.gitconfig      > $SWD/dotfiles/.gitconfig
  test -f $HOME/.ssh/config     && cat $HOME/.ssh/config     > $SWD/dotfiles/.ssh/config
  test -f $HOME/.ssh/id_rsa.pub && cat $HOME/.ssh/id_rsa.pub > $SWD/dotfiles/.ssh/id_rsa.pub
  test -f $HOME/.ssh/id_rsa     && cat $HOME/.ssh/id_rsa     > $SWD/dotfiles/.ssh/id_rsa
  test -f $HOME/.ssh/id_rsa_scm && cat $HOME/.ssh/id_rsa_scm > $SWD/dotfiles/.ssh/id_rsa_scm
fi

# create id_rsa if not exists
test ! -f $SWD/dotfiles/.ssh/id_rsa && cat $HOME/.ssh/id_rsa > $SWD/dotfiles/.ssh/id_rsa

# set permission
test -f $SWD/dotfiles/.gitconfig      && chmod 644 $SWD/dotfiles/.gitconfig
test -f $SWD/dotfiles/.ssh/config     && chmod 644 $SWD/dotfiles/.ssh/config
test -f $SWD/dotfiles/.ssh/id_rsa.pub && chmod 644 $SWD/dotfiles/.ssh/id_rsa.pub
test -f $SWD/dotfiles/.ssh/id_rsa     && chmod 600 $SWD/dotfiles/.ssh/id_rsa
test -f $SWD/dotfiles/.ssh/id_rsa_scm && chmod 600 $SWD/dotfiles/.ssh/id_rsa_scm

echo "done"
echo

# }}}

exit 0
