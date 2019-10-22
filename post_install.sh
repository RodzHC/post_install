#!/bin/bash

curl_check() {
	echo "Checking for curl..."
	if command -v curl >/dev/null; then
		echo "Detected curl..."
	else
		echo "Installing curl..."
		apt-get install -q -y curl
	fi
}

node_check() {
	echo "Checking for Nodejs..."
	if command -v node >/dev/null; then
		echo "Detected Nodejs..."
	else
		echo "Installing Nodejs"
		curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
		apt install -y nodejs
	fi
}

make_dialog() {

	cmd=(dialog --separate-output --checklist $box_message 22 76 16)
	choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	all_choices=(${choices[@]} ${all_choices[@]})

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

	box_message="DEV"
	options=(
		1 "Node.js" on
		2 "Python" off #Ubuntu 18.4 comes with python 3.6
		3 "Build Essentials" off
	)
	make_dialog

	box_message="DEVOPs"
	options=(
		30 "Git" on
		31 "Dockers" on

	)
	make_dialog

	box_message="Text editors and IDEs"
	options=(
		101 "Sublime Text 3" on
		102 "Atom" on
		103 "Visual Studio Code" on
		104 "Brackets" on
		105 "Pycharm" on
	)
	make_dialog

	box_message="Servidores"
	options=(
		151 "LAMP Stack" on
	)
	make_dialog

	box_message="Utilities"
	options=(
		201 "VLC Media Player" on
		202 "Skype" on
		204 "Google Chrome" on
		205 "Teamiewer" on
		206 "Spotify" on
		207 "Gimp" on
		208 "Slack" on
		209 "VirtualBox" on

	)
	make_dialog

	clear
	for choice in $all_choices; do
		case $choice in
		1)
			#Install Nodejs
			echo "Installing Nodejs"
			curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
			apt install -y nodejs
			;;

		2)
			#Install Python 3.8
			sudo add-apt-repository ppa:deadsnakes/ppa
			sudo apt-get update
			sudo apt-get install python3.6
			;;
		3)
			#Install Build Essentials
			echo "Installing Build Essentials"
			apt install -y build-essential
			;;

		30)
			#Install git
			echo "Installing Git, please configure git later..."
			apt install git -y
			;;
		31)
			#Install Dockers
			sudo apt-get remove docker docker-engine docker.io containerd runc
			sudo apt-get update
			sudo apt-get install \
				apt-transport-https \
				ca-certificates \
				curl \
				gnupg-agent \
				software-properties-common

			curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
			sudo apt-key fingerprint 0EBFCD88
			sudo add-apt-repository \
				"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   			$(lsb_release -cs) \
   			stable"

			sudo apt-get update

			sudo apt-get install docker-ce docker-ce-cli containerd.iosudo apt-get install docker-ce docker-ce-cli containerd.io
			;;

		101)

			#Install Sublime Text 3*
			echo "Installing Sublime Text"
			wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
			sudo apt-get install apt-transport-https
			echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
			sudo apt-get update
			sudo apt-get install sublime-text -y
			;;
		102)
			echo "Installing Atom"
			wget https://atom.io/download/deb -O atom.deb
			sudo dpkg -i atom.deb
			# Install Atom's dependencies if they are missing
			sudo apt-get -f install -y
			rm -f atom.deb
			;;
		103)
			echo "Installing Visual Studio Code"
			curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
			sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
			sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
			sudo apt update
			sudo apt install code -y
			;;
		104)
			echo "Installing Brackets"
			sudo add-apt-repository ppa:webupd8team/brackets -y
			sudo apt-get update
			sudo apt-get install brackets -y
			;;
		105) ;;

		151)

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
			echo "Include /etc/phpmyadmin/apache.conf" >>/etc/apache2/apache2.conf

			echo "Enabling module rewrite"
			sudo a2enmod rewrite
			echo "Restarting Apache Server"
			service apache2 restart
			;;
		201)
			#VLC Media Player
			echo "Installing VLC Media Player"
			apt install vlc -y
			;;
		202)
			#Skype for Linux
			echo "Installing Skype For Linux"
			apt install apt-transport-https -y
			curl https://repo.skype.com/data/SKYPE-GPG-KEY | apt-key add -
			echo "deb https://repo.skype.com/deb stable main" | tee /etc/apt/sources.list.d/skypeforlinux.list
			apt update
			apt install skypeforlinux -y
			;;
		204)

			#Chrome
			echo "Installing Google Chrome"
			wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
			sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
			apt-get update
			apt-get install google-chrome-stable -y
			;;
		205)
			#Teamviewer
			echo "Installing Teamviewer"
			wget http://download.teamviewer.com/download/teamviewer_i386.deb
			dpkg -i teamviewer_i386.deb
			apt-get install -f -y
			rm -rf teamviewer_i386.deb
			;;

		206)
			# Spotify
			# 1. Add the Spotify repository signing keys to be able to verify downloaded packages
			sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 0DF731E45CE24F27EEEB1450EFDC8610341D9410

			# 2. Add the Spotify repository
			echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

			# 3. Update list of available packages
			sudo apt-get update

			# 4. Install Spotify
			sudo apt-get install spotify-client -y
			;;

		207)
			echo "Installing Gimp"
			sudo apt-get install gimp -y
			;;

		208)
			echo "Installing Slack"
			wget -O slack-desktop.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-2.8.2-amd64.deb
			sudo dpkg -i slack-desktop.deb
			sudo apt-get install -f -y
			rm -f slack-desktop.deb
			;;

		209) #VirtualBox and guest editions
			sudo deb http://download.virtualbox.org/virtualbox/debian xenial contrib
			wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
			wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
			sudo apt-get update
			sudo apt-get install virtualbox
			sudo apt upgrade

			sudo apt-get update
			sudo apt-get install virtualbox-guest-dkms
			;;

		esac
	done
fi
