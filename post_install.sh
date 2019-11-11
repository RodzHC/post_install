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


make_dialog() {
	local box_message="$1"
	shift
	local options=("$@")
	echo $options
	cmd=(dialog --separate-output --checklist "$box_message" 22 76 16)
	choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	all_choices=(${choices[@]} ${all_choices[@]})
}

update_upgrade(){
	#Update and Upgrade
	echo "Updating and Upgrading"
	apt-get update && sudo apt-get upgrade -y
}

checks() {
		#Check if curl is installed
	curl_check

	sudo apt-get install dialog
}

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
else
	update_upgrade
	# checks

	arr1=(1 "Node.js" on 2 "Python" off 3 "Build Essentials" on)
	make_dialog "DEV" ${arr1[@]}

	arr2=(
		30 "Git" on
		31 "Dockers" on

	)
	make_dialog "DEVOPs" ${arr2[@]}

	

	#clear


