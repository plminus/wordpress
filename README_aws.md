# wordpress

Devops files including vagrant and shell-provisioners.

## How to build your own EC2 instance for development

`${PROJ_HOME}` is the directory where this README.md is in.

### (1) install vagrant plugins

```
cd  ${PROJ_HOME}
./vagrant_install_plugins.sh
```

### (2) place your own ssh private and public keys

```
cd  ${PROJ_HOME}/_dotfiles/.ssh ;
cp  -fp ~/.ssh/id_rsa     ./id_rsa ;
cp  -fp ~/.ssh/id_rsa.pub ./id_rsa.pub ;
```

Make sure this `id_rsa.pub` is registered as aws [Key Pairs](https://ap-northeast-1.console.aws.amazon.com/ec2/v2/home?region=ap-northeast-1#KeyPairs:sort=keyName).

Also, make sure you can `git clone/pull/push` to the repository with this `id_rsa` key.

### (3) create your own dotenv referring to dotenv.tmp

```
cd  ${PROJ_HOME}/aws ;
cp  ./dotenv.tmp ./dotenv ;
vim ./dotenv ;
```

This file should look like this

```
AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXX"
AWS_SECRET_ACCESS_KEY="YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY"
AWS_REGION="ap-northeast-1"

AWS_SSH_USERNAME="ec2-user"
AWS_SSH_KEY="./dotfiles/.ssh/id_rsa"
AWS_KEYPAIR_NAME="kiyomizu"
```

### (4) create your own vagrant config from a template

```
cd  ${PROJ_HOME}/aws ;
cd -Rp ./plminus-tmpl ./wordpress-develop-{YOUR_NAME} ;
```

### (5) run the provisioner to build your own ec2 instance

```
cd  ${PROJ_HOME}/aws/wordpress-develop-{YOUR_NAME} ;
./troop.sh ;
vagrant up ;
vagrant status ;
vagrant ssh ;
```

### (6) edit your /etc/hosts on your Mac, add your ec2 instance's public ip

```
cd  ${PROJ_HOME}

# get your instance's public ip
vagrant ssh-config | grep HostName | awk '{print $2}'

# edit your hosts
sudo vim /private/etc/hosts

xxx.xxx.xxx.xxx  wordpress-develop-{YOUR_NAME}.server
```

### (8) install base packages

login on the ec2 instance

```
vagrant ssh
```

run the base packages install script

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

### (7) run wordpress setup script

login on the ec2 instance

```
vagrant ssh
```

run the setup scripts on your ec2

```
cd /vagrant/provisioning ;
./build_aws_wordpress_develop.sh ;
```

Wordpress sources are deployed in `/var/www/vhosts/wordpress` and files uploaded through wordpress will be saved in `/var/www/vhosts/uploads` .

Be aware that `wp-content/uploads` is just a symlink to `/var/www/vhosts/uploads` directory.

### (8) create database

run the database create script on your vm

```
cd /srv/scripts/database ;
./db_create.sh box ;
```

### (9) proceed your wordpress installation

[ec2-wordpress-develop-{YOUR_NAME}.server](https://ec2-wordpress-develop-{YOUR_NAME}.server)

-----

Have fun!
