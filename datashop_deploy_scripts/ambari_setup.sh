#!/bin/bash
###___AUTHOR:RAJAN MIDDHA___###

### Dependencies ###
# Git must be installed

cat<<EOM

	+------------------------------------------------+
	| This script will setup ambari on remote server |
	+------------------------------------------------+

EOM

GIT_USERNAME="username"
GIT_PASSWORD="passsword"


## Install necessary packages ##
sudo yum install git-core vim wget -y

## Configure sudo less ssh ##
echo "Configuring ssh to localhost" >> ~/ambari_setup.log
ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod og-wx ~/.ssh/authorized_keys
sudo chown -R $USER /opt/
mkdir -p /opt/packages
echo "sudo less ssh done" >> ~/ambari_setup.log

## Clone Datashop-infra Repository ##
echo "Cloning DataShop Infra Git Repo" >> ~/ambari_setup.log
echo "machine git.innovaccer.com login $GIT_USERNAME password $GIT_PASSWORD" >> ~/.netrc
git clone http://git.innovaccer.com/Datashop/devops.git --branch ambari --single-branch Datashop-Infra
rm -rf ~/.netrc
sudo mv Datashop-Infra/Datashop-Infra/* Datashop-Infra/
sudo rm -rf Datashop-Infra/Datashop-Infra
echo "DataShop Infra Cloned" >> ~/ambari_setup.log

## Install Other Requirements ##
echo "Installing python-devel" >> ~/ambari_setup.log
sudo yum install python-devel -y
echo "python-devel Installed" >> ~/ambari_setup.log

echo "Installing get-pip.py" >> ~/ambari_setup.log
cd Datashop-Infra
sudo python get-pip.py
echo "get-pip.py Installed" >> ~/ambari_setup.log

echo "Installing setup-tools" >> ~/ambari_setup.log
cd setuptools-7.0 && sudo python setup.py install && cd ..
echo "setup-tools Installed" >> ~/ambari_setup.log

echo "Installing pycrypto" >> ~/ambari_setup.log
cd pycrypto-2.6.1 && sudo python setup.py install && cd ..
echo "pycrypto Installed" >> ~/ambari_setup.log

echo "Installing Development Tools" >> ~/ambari_setup.log
sudo yum group install Development Tools -y
echo "Development Tools Installed" >> ~/ambari_setup.log

echo "Installing fabric" >> ~/ambari_setup.log
sudo pip install fabric
echo "Fabric Installed" >> ~/ambari_setup.log

python fabfile.py 
sudo ambari-server start

echo "Done..."
