#!/bin/bash
#set -x

PLUGINS=`cat <<_EOT_
dotenv
#sahara
#vagrant-omnibus
#vagrant-aws
#vagrant-digitalocean
#vagrant-google
#vagrant-linode
#vagrant-sakura
vagrant-vbguest
_EOT_`

echo
echo "Starting..."
echo

for i in $PLUGINS
do
  test ! "`echo $i | grep -v ^# | grep -v ^$`" && continue
  vagrant plugin install $i
  #echo "vagrant plugin install $i"
done

vagrant plugin list

echo
echo "Finished."
echo

exit 0
