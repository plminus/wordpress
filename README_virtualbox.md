# wordpress

Devops files including vagrant and shell-provisioners.

## How to build your own virtual-machine

`${PROJ_HOME}` is the directory where this README.md is in.

### (1) install vagrant plugins

```
cd  ${PROJ_HOME}
./vagrant_install_plugins.sh ;
```

### (2) run the provisioner to build your wordpress-develop virtual-machine

prepare files

```
cd  ${PROJ_HOME}/virtualbox/wordpress-develop ;
./troop.sh -m ;
```

build your vm

```
vagrant up ;
vagrant status ;
```

### (3) edit /etc/hosts

check your vm's ip

```
echo "ifconfig eth1 | awk 'NR==2, NF=2 { print \$2 }' | sed 's/addr://'" | vagrant ssh
```

save the ip in your /etc/hosts as `wordpress-develop.server` , should look like this

```
YOUR_VM_IP  wordpress-develop.server
```

### (4) setup your virtual-machine

login on the vm

```
vagrant ssh
```

run the setup scripts on your vm

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
sleep 180 ;
vagrant halt ;
sleep 30 ;
vagrant up ;
```

### (5) run wordpress setup script

login on the vm

```
vagrant ssh
```

run the setup scripts on your vm

```
cd /vagrant/provisioning ;
./build_vbox_wordpress_develop.sh ;
```

### (6) create database

run the database import script on your vm

```
cd /srv/scripts/database ;
./db_create.sh box ;
```

### (7) proceed your wordpress installation

[https://wordpress-develop.server/](https://wordpress-develop.server/)

-----

Have fun!
