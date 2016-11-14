#!/bin/bash
###___AUTHOR:RAJAN MIDDHA___###

### Dependencies ###
# ssh access to remote server [configured in .ssh/config]
# Git Username
# Git Password	

cat<<EOM

	+-----------------------------------------+
	| This script will setup ambari to remote |
	| from local system and install necessary |
	| packages and zsh theme on remote server |
	+-----------------------------------------+

EOM

SERVER_NAME=$1
GIT_USERNAME=$2
GIT_PASSWORD=$3

ssh $SERVER_NAME << ENDOFCOMMANDS
echo "Installing oh-my-zsh git vim & wget" >> ~/ambari_setup.log
sudo yum install zsh git-core vim wget -y
wget --no-check-certificate http://install.ohmyz.sh -O - | sh
echo "Packages Installed" >> ~/ambari_setup.log

echo "Changing Shell to zsh" >> ~/ambari_setup.log
sudo chsh -s /bin/zsh ec2-user
source ~/.zshrc
echo "Shell Changed to zsh [oh-my-zsh]" >> ~/ambari_setup.log

echo "Configuring ssh to localhost" >> ~/ambari_setup.log
ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod og-wx ~/.ssh/authorized_keys
sudo chown -R ec2-user /opt/
mkdir -p /opt/packages
echo "sudo less ssh done" >> ~/ambari_setup.log

echo "Cloning DataShop Infra Git Repo" >> ~/ambari_setup.log
echo "machine git.innovaccer.com login $GIT_USERNAME password $GIT_PASSWORD" >> ~/.netrc
git clone http://git.innovaccer.com/akif/Datashop-Infra.git
echo "DataShop Infra Cloned" >> ~/ambari_setup.log

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

echo "Remote Installation part completed..." >> ~/ambari_setup.log
ENDOFCOMMANDS

echo "Remote Installation Completed..Now ssh to server and run 'cd Datashop-Infra && python fabfile.py && sudo ambari-server start' "

echo "Done..."
