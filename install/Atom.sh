# Install Atom IDE (javascript made).

echo "Installing Atom"
wget https://atom.io/download/deb -O atom.deb
sudo dpkg -i atom.deb
# Install Atom's dependencies if they are missing
sudo apt-get -f install -y
rm -f atom.deb
