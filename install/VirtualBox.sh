# Install VirtualBox and guest editions.

sudo deb http://download.virtualbox.org/virtualbox/debian xenial contrib
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install virtualbox
sudo apt upgrade

sudo apt-get update
sudo apt-get install virtualbox-guest-dkms
