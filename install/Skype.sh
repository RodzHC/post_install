# Install Skype for Linux

echo "Installing Skype For Linux"
apt install apt-transport-https -y
curl https://repo.skype.com/data/SKYPE-GPG-KEY | apt-key add -
echo "deb https://repo.skype.com/deb stable main" | tee /etc/apt/sources.list.d/skypeforlinux.list
apt update
apt install skypeforlinux -y
