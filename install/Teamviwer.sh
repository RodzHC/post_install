# Install Teamviewer.

echo "Installing Teamviewer"
wget http://download.teamviewer.com/download/teamviewer_i386.deb
dpkg -i teamviewer_i386.deb
apt-get install -f -y
rm -rf teamviewer_i386.deb
