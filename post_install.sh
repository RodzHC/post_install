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
	options=(1 "Sublime Text 3" on    # any option can be set to "off"
			2 "LAMP Stack" on
			3 "Build Essentials" on
			4 "Node.js" on
			5 "Git" on
			6 "Composer" on
			7 "JDK 9" on
			8 "Bleachbit" on
			9 "Ubuntu Restricted Extras" on
			10 "VLC Media Player" on
			11 "Unity Tewak Tool" on
			12 "Google Chrome" on
			13 "Teamiewer" on
			14 "Skype" on
			15 "Paper GTK Theme" off
			16 "Arch Theme" off
			17 "Arc Icons" off
			18 "Numix Icons" off
			19 "Multiload Indicator" off
			20 "Pensor" off
			21 "Netspeed Indicator" off
			22 "Generate SSH Keys" on
			23 "Ruby" on
			24 "Sass" on
			25 "Vnstat" on
			26 "Webpack" on
			27 "Grunt" on
			28 "Gulp" on
			29 "Atom" on
			30 ".Net Core 2.0.0 SDK" on
			31 "Visual Studio Code" on
			32 "Brackets" on
			33 "Gimp" on
			34 "Slack" on
			35 "Ubuntu Restricted Extras" on
			36 "Gnome Desktop" off
			37 "Yeoman & generators" on
			38 "Spotify" on
			39 "Rar" on
			40 "SmartGit" on
			41 "FireFox dev edition" on
			42 "Jekyll" on
			43 "Mouse scroller speed up to max" on
			44 "DupeGuru" on
			45 "Visual Studio Code Extensions" on
			46 "KeePass" on
			47 "Calibre" on
			48 "Set Ubuntu to local timezone" on
			49 "Update NPM" on
			50 "Android SDK and PhoneGap" on
			51 "VirtualBox" on
			52 "Samba GUI tools" on
			53 "OpenVPN" on
			54 "UGet download manager" on
			55 "FileZilla" on
			56 "PopcornTime" on
			57 "Robo3T" on
			58 "SQLite" on
			59 "SQLite Browser" on
			60 "Thunderbird" on
			61 "AdobeAir" on
			62 "IntelliJ" on
			63 "Steam" on
			64 "Peek" on
			65 "Stacer" on
			66 "OpenPics" on
			67 "Remmina" on
			68 "Reset Mice Fix for Microsoft Sculpt Mouse Scroll" off
			69 "Gamecube SDK tools and Swiss" off
			70 "Memory card PCI express slot fix for Dell computers" off)

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
				;;

			39) #Rar and other compressions libs
				sudo apt-get install rar
				sudo apt-get install lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6
				sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
				;;

			40) #Smart GIT
				sudo curl http://www.syntevo.com/smartgit/download?file=smartgit/smartgit-17_1_0.deb
				sudo apt install smartgit-17_1_0.deb
				;;

			41) #FireFox developer edition
				sudo add-apt-repository ppa:ubuntu-mozilla-daily/firefox-aurora
				sudo apt-get update
				sudo apt-get install firefox
				;;

			42) #Jekyll, GITHub pages and Ruby
				sudo apt-get install zlib1g-dev
				sudo apt-get install ruby-full
				sudo apt-get install rubygems
				sudo bundle install
				sudo gem install bundler
				sudo apt install ruby-bundler
				sudo gem update bundler
				sudo apt-get install ruby-all-dev
				sudo gem install ffi -v '1.9.18'
				sudo gem install jekyll-feed
				bundle update github-pages
				;;

			43) #Speed up mouse scroller
				sudo xinput set-prop 10 'Device Accel Constant Deceleration' 1 #scrolling on my mouse is weird/slow otherwise
				;;

			43) #DupeGuru (a great tool to find duplicate files)
				sudo apt-add-repository ppa:hsoft/ppa
				sudo apt-get update
				sudo apt-get install dupeguru-se
				;;
			
			44) #Hipchat
				sudo sh -c 'echo "deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main" > /etc/apt/sources.list.d/atlassian-hipchat4.list'
				sudo wget -O - https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public | sudo apt-key add -
				sudo apt-get update
				sudo apt-get install hipchat4
				;;

			45) #Visual Studio Code Extensions
				code --install-extension streetsidesoftware.code-spell-checker
				code --install-extension alexkrechik.cucumberautocomplete
				code --install-extension glen-84.sass-lint
				code --install-extension lkytal.coneelinter
				code --install-extension ms-vscode.csharp
				code --install-extension jchannon.csharpextensions
				code --install-extension vsmobile.vscode-react-native
				code --install-extension redhat.java
				code --install-extension vscjava.vscode-java-debug
				code --install-extension mdickin.markdown-shortcuts
				code --install-extension msjsdiag.debugger-for-chrome
				code --install-extension DavidAnson.vscode-markdownlint
				code --install-extension ms-vscode.powershell
				code --install-extension ms-vscode.node-debug2
				code --install-extension ms-python.python
				code --install-extension ms-vscode.cpptools
				code --install-extension formulahendry.code-runner
				code --install-extension dbaeumer.vscode-eslint
				code --install-extension lukehoban.go
				code --install-extension HookyQR.beautify
				code --install-extension PeterJausovec.vscode-docker
				code --install-extension eg2.vscode-npm-script
				code --install-extension abusaidm.html-snippets
				code --install-extension felixfbecker.php-intellisense
				code --install-extension felixfbecker.php-debug
				code --install-extension rebornix.ruby
				code --install-extension ms-vscode.atom-keybindings
				code --install-extension humao.rest-client


				;;

			46) #KeePass
				sudo apt-add-repository ppa:jtaylor/keepass
				sudo apt-get update
				sudo apt-get install keepass2
				;;

			47) #Calibre
				sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
				;;
			
			48) #Make Ubuntu use the same local timezone as Windows (as opposed to UTC) for dual booting only
				sudo timedatectl set-local-rtc 1
				;;

			49) #Update NPM
				sudo npm install npm@latest -g
				;;
			
			50) #Install Android SDK and PhoneGap
				sudo apt-add-repository ppa:cordova-ubuntu/ppa
				sudo apt-get update
				sudo apt-get install cordova-cli
				sudo apt-get install ant
				sudo npm install -g phonegap
				;;

			51) #VirtualBox and guest editions
				sudo deb http://download.virtualbox.org/virtualbox/debian xenial contrib
				wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
				wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
				sudo apt-get update
				sudo apt-get install virtualbox
				sudo apt upgrade

				sudo apt-get update
				sudo apt-get install virtualbox-guest-dkms 
				;;

			52) #Samba server
				sudo add-apt-repository universe
				sudo apt-get update
				sudo apt-get install system-config-samba
				sudo touch /etc/libuser.conf
				;;

			53) #OpenVPN
			    sudo apt-get update
   				sudo apt-get install openvpn easy-rsa
				;;

			54) #UGet (fast download manager)
				sudo add-apt-repository ppa:plushuang-tw/uget-stable
				sudo apt update
				sudo apt install uget
				;;

			55) #FileZilla
				sudo sh -c 'echo "deb http://archive.getdeb.net/ubuntu xenial-getdeb apps" >> /etc/apt/sources.list.d/getdeb.list'
				wget -q -O - http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
				sudo apt update
				sudo apt install filezilla
				;;
			
			56) #PopcornTime
				sudo ln -sf /lib/x86_64-linux-gnu/libudev.so.1 /lib/x86_64-linux-gnu/libudev.so.0
				
				wget https://dl.popcorn-time.to/Popcorn-Time-linux64.tar.gz
				sudo mkdir /opt/popcorn-time
				sudo tar -xzf Popcorn-Time-linux64.tar.gz -C /opt/popcorn-time
				rm Popcorn-Time-linux64.tar.gz
				
				#to run PopcornTime add your own shortcut to /opt/popcorn-time/Popcorn-Time
				;;

			57) #Robo 3T (mongo viewer client)
				wget https://download.robomongo.org/1.1.1/linux/robo3t-1.1.1-linux-x86_64-c93c6b0.tar.gz
				sudo tar -xzf robo3t-1.1.1-linux-x86_64-c93c6b0.tar.gz -C /opt
				rm robo3t-1.1.1-linux-x86_64-c93c6b0.tar.gz
				sudo mkdir /opt/robo3t-1.1.1-linux-x86_64-c93c6b0//lib/BKP/
				sudo mv /opt/robo3t-1.1.1-linux-x86_64-c93c6b0/lib/libstdc++* /opt/robo3t-1.1.1-linux-x86_64-c93c6b0//lib/BKP/
				sudo ln -s /opt/robo3t-1.1.1-linux-x86_64-c93c6b0/bin/robo3t /usr/bin/robo3t
				;;

			58) #SQLite
				sudo add-apt-repository ppa:jonathonf/backports
				sudo apt update
				sudo apt-get install sqlite3
				;;

			59) #SQLite browser
				sudo add-apt-repository -y ppa:linuxgndu/sqlitebrowser
				sudo apt-get update
				sudo apt-get install sqlitebrowser
				;;
			
			60) #Thunderbird
				sudo add-apt-repository ppa:ubuntu-mozilla-security/ppa
				sudo apt-get update
				sudo apt-get install thunderbird
				;;

			61) #Adobe Air
				wget -O adobe-air.sh http://drive.noobslab.com/data/apps/AdobeAir/adobe-air.sh
				chmod +x adobe-air.sh;sudo ./adobe-air.sh
				;;

			62) #IntelliJ IDE Community Edition for JAVA
				sudo add-apt-repository ppa:ubuntuhandbook1/apps
				sudo apt-get update
				sudo apt-get install intellij-idea-community
				;;
				
			63) #Steam Gaming
				sudo add-apt-repository multiverse
				sudo apt-get update
				sudo apt-get install steam
				;;

			64) #Peek (screen capture to animated GIF's / demo bugs and stuff)
				sudo add-apt-repository ppa:peek-developers/stable
				sudo apt-get update
				sudo apt-get install peek
				;;

			65) #Stacer (system resource monitor etc)
				wget https://github.com/oguzhaninan/Stacer/releases/download/v1.0.8/stacer_1.0.8_amd64.deb
				sudo dpkg --install stacer_1.0.8_amd64.deb
				sudo rm -rf stacer_1.0.8_amd64.deb
				;;

			66) #OpenPics (open source images to use with any web project or template etc)
				wget https://github.com/lohanitech/openpics/releases/download/v0.2.0/openpics_0.2.0_amd64.deb
				sudo dpkg --install openpics_0.2.0_amd64.deb
				sudo rm -rf openpics_0.2.0_amd64.deb
				;;

			67) #Remmina (remote desktop client)
				sudo apt-add-repository ppa:remmina-ppa-team/remmina-next
				sudo apt-get update
				sudo apt-get install remmina remmina-plugin-rdp remmina-plugin-gnome libfreerdp-plugins-standard
				;;

			68) #ResetMSMice

				#Dependencies
				sudo apt-get install pkg-config
				sudo apt-get install libusb-1.0-0-dev
				sudo apt-get install libgtk2.0-dev

				wget https://github.com/paulrichards321/resetmsmice/archive/master.zip
				sudo unzip master.zip -d /resetmsmice

				sudo mv /resetmsmice/resetmsmice-master /opt/resetmsmice
				sudo chmod +x /opt/resetmsmice;
				sudo rm master.zip
				sudo rm -r /resetmsmice
				
				cd /opt/resetmsmice
				sudo ./configure
				sudo make
				sudo make install

				#go back to home user dir
				cd 

				#now it is installed use this command to open and configure the mouse settings
				#sudo resetmsmice-gui
				;;

			69) #DevKitPro + Swiss (for Gamecube Swiss development)
				sudo apt install gcc build-essential -y
				sudo apt-get install p7zip-full
				sudo dpkg --add-architecture i386
				wget -nc https://dl.winehq.org/wine-builds/Release.key
				sudo apt-key add Release.key
				sudo apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
				sudo apt-get update
				sudo apt-get install --install-recommends winehq-stable

				wget https://raw.githubusercontent.com/devkitPro/installer/master/perl/devkitPPCupdate.pl
				
				sudo mkdir -p /opt/devkitpro
				sudo chmod 777 /opt/devkitpro
				sudo mv /home/paul/Documents/devkitPPCupdate.pl /opt/
				cd /opt/
				sudo perl devkitPPCupdate.pl

				export DEVKITPRO=/opt/devkitpro
				export DEVKITPPC=$DEVKITPRO/devkitPPC

				printf "export DEVKITPRO=/opt/devkitpro\n" >> /home/paul/.bashrc
				printf "export DEVKITPPC=$DEVKITPRO/devkitPPC\n" >> /home/paul/.bashrc

				#Download latest Swiss and make file
				wget https://github.com/emukidid/swiss-gc/archive/master.zip
				sudo unzip master.zip -d /swiss-gc
				sudo mkdir -p /opt/swiss-gc
				sudo chmod +x /opt/swiss-gc;

				sudo mv /swiss-gc/swiss-gc-master /opt/swiss-gc
				sudo rm master.zip
				sudo rm -r /swiss-gc
			
				#Make Swiss patched Gamecube only version of libfat-frag, and overwrite one in DevKitPro
				cd /opt/swiss-gc/cube/libfat-frag/src
				make -f Makefile cube-release
				sudo mv /opt/swiss-gc/cube/libfat-frag/src/libogc/lib/cube/libfat.a /opt/devkitpro/libogc/lib/cube/libfat.a

				#Make Swiss DOL files
				sudo cd /opt/swiss-gc
				make -f Makefile

				#Go back to home user directory
				cd
				;;

			70) #SD card slot PCI express on Dell laptops do not work (fix)
				sudo rmmod sdhci sdhci_pci sdhci_acpi
				sudo modprobe sdhci debug_quirks2="0x10000"
				sudo modprobe sdhci_pci

				sudo printf "options sdhci debug_quirks2=0x10000" > /etc/modprobe.d/sd-cart-fix.conf
				;;
	    esac
	done
fi
