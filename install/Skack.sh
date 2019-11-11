# Install Slack.

echo "Installing Slack"
wget -O slack-desktop.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-2.8.2-amd64.deb
sudo dpkg -i slack-desktop.deb
sudo apt-get install -f -y
rm -f slack-desktop.deb
