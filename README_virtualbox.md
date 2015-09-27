# wordpress

Devops files including vagrant and shell-provisioners.

## How to build your own virtual-machine

`${PROJ_HOME}` is the directory where this README.md is in.

### (1) install vagrant plugins

```
cd  ${PROJ_HOME}
./vagrant_install_plugins.sh ;
```

### (2) place your own ssh private and public keys

```
cd  ${PROJ_HOME}/_dotfiles/.ssh ;
cp  -fp ~/.ssh/id_rsa      ./id_rsa ;
cp  -fp ~/.ssh/id_rsa.pub  ./id_rsa.pub ;
```

Make sure you can `git clone/pull/push` to the repository with this `id_rsa` key.

### (3) place your own aws credentials

You need this `only if` you want to access aws resource from your vm via `awscli`.

```
cd  ${PROJ_HOME}/_dotfiles/.aws ;
cp  ./config.tmpl ./config ;
vim ./config ;
```

This file should look like this

```
[default]
aws_access_key_id     = XXXXXXXXXXXXXXXXXXXX
aws_secret_access_key = YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
output = json
region = ap-northeast-1
```

### (4) run the provisioner to build your virtual-machine

prepare files

```
cd  ${PROJ_HOME}/virtualbox/wordpress-develop ;
./troop.sh ;
```

build your vm

```
vagrant up ;
vagrant status ;
```

### (5) edit /etc/hosts

check your vm's ip

```
echo "ifconfig eth1 | awk 'NR==2, NF=2 { print \$2 }' | sed 's/addr://'" | vagrant ssh
```

save the ip in your /etc/hosts as `wordpress-develop.server` , should look like this

```
YOUR_VM_IP  wordpress-develop.server
```

### (6) install base packages

login on the vm

```
vagrant ssh
```

run the base packages install script

```
cd /vagrant/provisioning ;
./build_vbox_base.sh ;
sudo yum -y update ;
```

restart your vm to apply a new version of kernel

```
sudo reboot
```

wait few minutes till the the vm restarts, and then shutdown and start vm again

```
sleep 60 ;
vagrant halt ;
sleep 10 ;
vagrant up ;
```

### (7) run wordpress setup script

login on the vm

```
vagrant ssh
```

run the setup scripts 

```
cd /vagrant/provisioning ;
./build_vbox_wordpress_develop.sh ;
```

Wordpress sources are deployed in `/var/www/vhosts/wordpress` and files uploaded through wordpress will be saved in `/var/www/vhosts/uploads` .

Be aware that `wp-content/uploads` is just a symlink to `/var/www/vhosts/uploads` directory.

### (8) create database

run the database create script

```
cd /srv/scripts/database ;
./db_create.sh box ;
```

### (9) proceed your wordpress installation

[https://wordpress-develop.server/](https://wordpress-develop.server/)

-----

Have fun!
