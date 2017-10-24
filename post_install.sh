#!/bin/bash

curl_check ()
{
  echo "Checking for curl..."
  if command -v curl > /dev/null; then
    echo "Detected curl..."
  else
    echo "Installing curl..."
    apt-get install -q -y curl
  fi
}

node_check ()
{
  echo "Checking for Nodejs..."
  if command -v node > /dev/null; then
    echo "Detected Nodejs..."
  else
    echo "Installing Nodejs"
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
    apt install -y nodejs
  fi
}

if [[ $EUID -ne 0 ]]; then
   	echo "This script must be run as root" 
   	exit 1
else
	#Update and Upgrade
	echo "Updating and Upgrading"
	apt-get update && sudo apt-get upgrade -y
	
	#Check if curl is installed
	curl_check

	sudo apt-get install dialog
	cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
	options=(1 "Sublime Text 3" off    # any option can be set to default to "on"
	         2 "LAMP Stack" off
	         3 "Build Essentials" off
	         4 "Node.js" off
	         5 "Git" off
	         6 "Composer" off
	         7 "JDK 9" off
	         8 "Bleachbit" off
	         9 "Ubuntu Restricted Extras" off
	         10 "VLC Media Player" off
	         11 "Unity Tewak Tool" off
	         12 "Google Chrome" off
	         13 "Teamiewer" off
	         14 "Skype" off
	         15 "Paper GTK Theme" off
	         16 "Arch Theme" off
	         17 "Arc Icons" off
	         18 "Numix Icons" off
			 19 "Multiload Indicator" off
			 20 "Pensor" off
			 21 "Netspeed Indicator" off
			 22 "Generate SSH Keys" off
			 23 "Ruby" off
			 24 "Sass" off
			 25 "Vnstat" off
			 26 "Webpack" off
			 27 "Grunt" off
			 28 "Gulp" off
		 29 "Atom" off
		 30 ".Net Core 2.0.0 SDK" off
		 31 "Visual Studio Code" off
		 32 "Brackets" off
		 33 "Gimps" off
		 34 "Slack" off
		 35 "Ubuntu Restricted Extras" on
		 36 "Gnome Desktop" off
		 37 "Yeoman & generators" off
		 38 "Spotify" off)

		choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		clear
		for choice in $choices
		do
		    case $choice in
	        	1)
	            		#Install Sublime Text 3*
				echo "Installing Sublime Text"
				wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
				sudo apt-get install apt-transport-https
				echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
				sudo apt-get update
				sudo apt-get install sublime-text -y
				;;

			2)
			    	#Install LAMP stack
				echo "Installing Apache"
				apt install apache2 -y
	            
    			echo "Installing Mysql Server"
	 			apt install mysql-server -y

        		echo "Installing PHP"
				apt install php libapache2-mod-php php-mcrypt php-mysql -y
	            
        		echo "Installing Phpmyadmin"
				apt install phpmyadmin -y

				echo "Cofiguring apache to run Phpmyadmin"
				echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
				
				echo "Enabling module rewrite"
				sudo a2enmod rewrite
				echo "Restarting Apache Server"
				service apache2 restart
				;;
    		3)	
				#Install Build Essentials
				echo "Installing Build Essentials"
				apt install -y build-essential
				;;
				
			4)
				#Install Nodejs
				echo "Installing Nodejs"
				curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
				apt install -y nodejs
				;;

			5)
				#Install git
				echo "Installing Git, please congiure git later..."
				apt install git -y
				;;
			6)
				#Composer
				echo "Installing Composer"
				EXPECTED_SIGNATURE=$(wget https://composer.github.io/installer.sig -O - -q)
				php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
				ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

				if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]
				  then
				php composer-setup.php --quiet --install-dir=/bin --filename=composer
				RESULT=$?
				rm composer-setup.php
				else
				  >&2 echo 'ERROR: Invalid installer signature'
				  rm composer-setup.php
				fi
				;;
			7)
				#JDK 9
				echo "Installing JDK 9"
				apt install python-software-properties -y
				add-apt-repository ppa:webupd8team/java -y
				apt update
				apt install oracle-java9-installer -y
				;;
			8)
				#Bleachbit
				echo "Installing BleachBit"
				apt install bleachbit -y
				;;
			9)
				#Ubuntu Restricted Extras
				echo "Installing Ubuntu Restricted Extras"
				apt install ubunt-restricted-extras -y
				;;
			10)
				#VLC Media Player
				echo "Installing VLC Media Player"
				apt install vlc -y
				;;
			11)
				#Unity tweak tool
				echo "Installing Unity Tweak Tool"
				apt install unity-tweak-tool -y
				;;
			12)

				#Chrome
				echo "Installing Google Chrome"
				wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
				sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
				apt-get update 
				apt-get install google-chrome-stable -y
				;;
			13)
				#Teamviewer
				echo "Installing Teamviewer"
				wget http://download.teamviewer.com/download/teamviewer_i386.deb
				dpkg -i teamviewer_i386.deb
				apt-get install -f -y
				rm -rf teamviewer_i386.deb
				;;
			14)

				#Skype for Linux
				echo "Installing Skype For Linux"
				apt install apt-transport-https -y
				curl https://repo.skype.com/data/SKYPE-GPG-KEY | apt-key add -
				echo "deb https://repo.skype.com/deb stable main" | tee /etc/apt/sources.list.d/skypeforlinux.list
				apt update 
				apt install skypeforlinux -y
				;;
			15)

				#Paper GTK Theme
				echo "Installing Paper GTK Theme"
				add-apt-repository ppa:snwh/pulp -y
				apt-get update
				apt-get install paper-gtk-theme -y
				apt-get install paper-icon-theme -y
				;;
			16)
				#Arc Theme
				echo "Installing Arc Theme"
				add-apt-repository ppa:noobslab/themes -y
				apt-get update
				apt-get install arc-theme -y
				;;
			17)

				#Arc Icons
				echo "Installing Arc Icons"
				add-apt-repository ppa:noobslab/icons -y
				apt-get update
				apt-get install arc-icons -y
				;;
			18)
				#Numix Icons
				echo "Installing Numic Icons"
				apt-add-repository ppa:numix/ppa -y
				apt-get update
				apt-get install numix-icon-theme numix-icon-theme-circle -y
				;;
			19)	
				echo "Installing Multiload Indicator"
				apt install indicator-multiload -y
				;;
			20)
				apt install psensor -y
				;;
			21)
				echo "Installing NetSpeed Indicator"
				apt-add-repository ppa:fixnix/netspeed -y
				apt-get update
				apt install indicator-netspeed-unity -y
				;;
			22)
				echo "Generating SSH keys"
				ssh-keygen -t rsa -b 4096
				;;
			23)
				echo "Installing Ruby"
				apt install ruby-full -y
				;;

			24)
				echo "Installing Sass"
				gem install sass
				;;
			25)
				echo "Installing Vnstat"
				apt install vnstat -y
				;;
			26)
				echo "Installing Webpack"
				node_check
				npm install webpack -g
				;;
			27)
				echo "Installing Grunt"
				node_check
				npm install grunt -g
				;;
			28)
				echo "Installing Gulp"
				node_check
				npm install gulp -g
				;;
			29)	echo "Installing Atom"
				wget https://atom.io/download/deb -O atom.deb
				sudo dpkg -i atom.deb
				# Install Atom's dependencies if they are missing
				sudo apt-get -f install -y
				rm -f atom.deb	
				;;

			30)	echo "Installing the .Net Core 2.0.0 SDK"
				curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
				sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
				sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
				sudo apt-get update
				sudo apt-get install dotnet-sdk-2.0.0 -y
				;;

			31)	echo "Installing Visual Studio Code"
				curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
				sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
				sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
				sudo apt update
				sudo apt install code -y
				;;

			32)	echo "Installing Brackets"
				sudo add-apt-repository ppa:webupd8team/brackets -y
				sudo apt-get update
				sudo apt-get install brackets -y
				;;

			33)	echo "Installing Gimp"
				sudo apt-get install gimp -y
				;;

			34) 	echo "Installing Slack"
				wget -O slack-desktop.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-2.8.2-amd64.deb
				sudo dpkg -i slack-desktop.deb
				sudo apt-get install -f -y
				rm -f slack-desktop.deb
				;;

			35)	echo "Ubuntu Restricted Extras"
				sudo apt-get install ubuntu-restricted-extras -y
				;;
			36)	echo "Installing The Gnome Desktop"
				sudo apt-get install ubuntu-gnome-desktop -y
				;; 

			37)	# Yeoman and generators
				node_check
				echo "Installing Yeoman and generator webapp, aspnet, angular"
				sudo npm install -g grunt-cli bower yo generator-karma generator-angular gulp-cli generator-angular-fullstack bower generator-webapp generator-wordpress generator-aspnet generator-generator	
				;;
			38) # Spotify
				# 1. Add the Spotify repository signing keys to be able to verify downloaded packages
				sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 0DF731E45CE24F27EEEB1450EFDC8610341D9410

				# 2. Add the Spotify repository
				echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

				# 3. Update list of available packages
				sudo apt-get update

				# 4. Install Spotify
				sudo apt-get install spotify-client -y

	    esac
	done
fi
