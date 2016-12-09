#!/bin/sh

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
else
	#Update and Upgrade
	echo "Updating and Upgrading"
	apt-get update && sudo apt-get upgrade -y


	#Ubuntu Restricted Extras
	echo "Installing Ubuntu Restricted Extras"
	apt-get install ubunt-restricted-extras -y

	#Mininize on Click
	echo "Enabling minize apps on click feature"
	gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true

	#VLC Media Player
	echo "Installing VLC Media Player"
	apt-get install vlc -y

	#Unity tweak tool
	echo "Installing Unity Tweak Tool"
	apt-get install unity-tweak-tool -y

	#Chrome
	echo "Installing Google Chrome"
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
	apt-get update 
	apt-get install google-chrome-stable -y

	#Install Sublime Text 3*
	echo "Installing Sublime Text"
	add-apt-repository ppa:webupd8team/sublime-text-3 -y
	apt-get update
	apt-get install sublime-text-installer -y

	#Install lamp stack
	echo "Installing Apache"
	apt-get install apache2 -y
	echo "Installing Mysql Server"
	 apt-get install mysql-server -y
	echo "Installing PHP"
	apt-get install php libapache2-mod-php php-mcrypt php-mysql -y
	echo "Installing Phpmyadmin"
	apt-get install phpmyadmin -y

	echo "Cofiguring apache to run Phpmyadmin"
	echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf


	echo "Restarting Apache Server"
	service apache2 restart

	#Install Build Essentials
	echo "Installing Build Essentials"
	apt-get install -y build-essential

	#Install Nodejs
	echo "Installing Nodejs"
	curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
	sudo apt-get install -y nodejs

	#Install git
	echo "Installing Git, please congiure git later..."
	apt-get install git -y

	#Composer
	echo "Installing Composer"
	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

	#JDK 8
	echo "Installing JDK 8"
	apt-get install python-software-properties -y
	add-apt-repository ppa:webupd8team/java
	apt-get update
	apt-get install oracle-java8-installer -y

	#Bleachbit
	echo "Installing BleachBit"
	apt-get install bleachbit -y

	#Paper GTK Theme
	echo "Installing Paper GTK Theme"
	add-apt-repository ppa:snwh/pulp -y
	apt-get update
	apt-get install paper-gtk-theme -y
	apt-get install paper-icon-theme -y

	#Arc Theme
	echo "Installing Arc Theme"
	add-apt-repository ppa:noobslab/themes -y
	apt-get update
	apt-get install arc-theme -y

	#Arc Icons
	echo "Installing Arc Icons"
	add-apt-repository ppa:noobslab/icons -y
	apt-get update
	apt-get install arc-icons -y

	#Numix Icons
	echo "Installing Numic Icons"
	apt-add-repository ppa:numix/ppa -y
	apt-get update
	apt-get install numix-icon-theme numix-icon-theme-circle -y

	#Teamviewer
	echo "Installing Teamviewer"
	wget http://download.teamviewer.com/download/teamviewer_i386.deb
	dpkg -i teamviewer_i386.deb
	apt-get install -f -y
	rm -rf teamviewer_i386.deb

	#Skype for Linux
	echo "Installing Skype For Linux"
	apt install apt-transport-https -y
	curl https://repo.skype.com/data/SKYPE-GPG-KEY | apt-key add -
	echo "deb https://repo.skype.com/deb stable main" | tee /etc/apt/sources.list.d/skypeforlinux.list
	apt update 
	apt install skypeforlinux -y	
fi