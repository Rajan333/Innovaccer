#!/bin/bash

yum install git-core zsh wget vim -y
wget --no-check-certificate http://install.ohmyz.sh -O - | sh
chsh -s /usr/bin/zsh ec2-user
source ~/.zshrc
