# copy_files {{{

function copy_files {
  local sdir=${1:-''}
  local list=${2:-''}
  local perm=${3:-'0644'}
  local ownd=${4:-'root:root'}

  for i in $list
  do
    echo $i | grep -e "^$" -e "^#" >/dev/null 2>&1
    test $? -eq 0 && continue

    sudo bash -c "cat $sdir/$i > /$i"
    sudo chmod $perm /$i
    sudo chown $ownd /$i

    #echo "--------------------------------------------------"
    #echo "sudo bash -c \"cat $sdir/$i > /$i\""
    #echo "sudo chmod $perm /$i"
    #echo "sudo chown $ownd /$i"
  done
}

# }}}
# remove_files {{{

function remove_files {
  local list=${1:-''}

  for i in $list
  do
    test -e $i && sudo rm -f $i 2>/dev/null
  done
}

# }}}
# make_dirs {{{

function make_dirs {
  local list=${1:-''}
  local perm=${2:-'0755'}
  local ownd=${3:-'root:root'}

  for i in $list
  do
    echo $i | grep -e "^$" -e "^#" >/dev/null 2>&1
    test $? -eq 0 && continue

    if [ ! -d "$i" ]; then
      sudo mkdir -p $i
    fi
    sudo chmod $perm $i
    sudo chown $ownd $i

    #echo "--------------------------------------------------"
    #echo "sudo mkdir -p $i"
    #echo "sudo chmod $perm $i"
    #echo "sudo chown $ownd $i"
  done
}

# }}}
# rpm_localinstall {{{

function rpm_localinstall {
  local rpm_url=$1
  local rpm_bin=$(basename $rpm_url)
  local rpm_dir=/usr/local/src/provisioning
  local cur_dir=$(pwd)

  # create dir to download rpm
  make_dirs "$rpm_dir" 0755 root:root

  # download and install rpm
  cd $rpm_dir
  test ! -f ./$rpm_bin && sudo curl -LOk $rpm_url
  sudo rpm -Uvh ./$rpm_bin
  cd $cur_dir
}

# }}}
