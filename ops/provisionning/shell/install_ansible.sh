#!/bin/bash

echo "Instal softweare properties common" 
sudo apt-get  install -y software-properties-common
echo "Add ansible repo" 
sudo apt-add-repository -y ppa:ansible/ansible
echo "Update cache"
sudo apt-get update
echo "Upgrade" 
sudo apt-get  upgrade -y
echo "Install ansible "
sudo apt-get  install ansible -y
