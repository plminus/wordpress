# wordpress

Devops files including vagrant and shell-provisioners.

## How to build your own EC2 instance for development

`${PROJ_HOME}` is the directory where this README.md is in.

### (1) install vagrant plugins

```
cd  ${PROJ_HOME}
./vagrant_install_plugins.sh
```

### (2) place your own aws credential file referring to config.tmpl

```
cd  ${PROJ_HOME}/_dotfiles/.aws ;
cp  ./config.tmpl ./config ;
vim ./config ;
```

### (3) place your own ssh private and public keys

```
cd  ${PROJ_HOME}/_dotfiles/.ssh ;
cp  -fp ~/.ssh/id_rsa     ./id_rsa ;
cp  -fp ~/.ssh/id_rsa.pub ./id_rsa.pub ;
```

### (4) create your own dotenv referring to dotenv.tmp

```
cd  ${PROJ_HOME}/aws ;
cp  ./dotenv.tmp ./dotenv ;
vim ./dotenv ;
```

### (5) create your own vm config from tmpl

```
cd  ${PROJ_HOME}/aws ;
cd -Rp ./plminus-tmpl ./wordpress-develop-{YOUR_NAME} ;
```

### (6) run the provisioner to build your own instance for development

```
cd  ${PROJ_HOME}/aws/wordpress-develop-{YOUR_NAME} ;
./troop.sh ;
vagrant up ;
vagrant status ;
vagrant ssh ;
```

### (7) edit your /etc/hosts on your Mac, add your ec2 instance's public ip

```
cd  ${PROJ_HOME}

# get your instance's public ip
vagrant ssh-config | grep HostName | awk '{print $2}'

# edit your hosts
sudo vim /private/etc/hosts

xxx.xxx.xxx.xxx  wordpress-develop-{YOUR_NAME}.server
```

### (8) setup your ec2 instance

login on the ec2 instance

```
vagrant ssh
```

run the setup scripts on your ec2

```
cd /vagrant/provisioning ;
./build_aws_base.sh ;
sudo yum -y update ;
```

restart your ec2 instance to apply a new version of kernel

```
sudo reboot
```

wait few minutes till the the ec2 instance restarts

### (9) run wordpress setup script

login on the ec2 instance

```
vagrant ssh
```

run the setup scripts on your ec2

```
cd /vagrant/provisioning ;
./build_aws_wordpress_develop.sh ;
```

### (10) create database

run the database create script on your vm

```
cd /srv/scripts/database ;
./db_create.sh box ;
```

### (11) proceed your wordpress installation

[ec2-wordpress-develop-{YOUR_NAME}.server](https://ec2-wordpress-develop-{YOUR_NAME}.server)

-----

Have fun!
