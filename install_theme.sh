#!/bin/bash

set -e

#https://github.com/bobafetthotmail/refind-theme-regular.git
#sudo nano /boot/efi/EFI/refind/refind.conf

refind_theme() {
	# check dependencies
	command -v git &>/dev/null || {
		echo -n "git not found! installing.. "
		sudo apt -y update &>/dev/null
		sudo apt -y install git &>/dev/null &&
		echo "success!"
	}
	
	# change work directory
	cd ${HOME}/Downloads
	
	# download the theme
	read -p "Paste rEFInd theme's github repository: " REPO
	git clone ${REPO}.git
	local THEME=${REPO##*/}

	# remove unnecessary files
	{	rm -rf ${THEME}/.git
		rm -f ${THEME}/README.md
		rm -f ${THEME}/LICENSE
		rm -f ${THEME}/install.sh
		rm -rf ${THEME}/src
	} 2>/dev/null
	
	# apply theme
	local DIR=$(sudo find /boot/ -type 'f' -name 'refind.conf' | sed 's|/refind.conf|/themes|g')
	[ -d "$DIR" ] && {
		sudo rm -rf $DIR
		sudo mkdir -p $DIR
		sudo cp -rf $THEME ${DIR}/
	}
	# refind configuration
	local CONF=$(sudo grep -v "include themes/" ${DIR%/themes}/refind.conf)
	echo -e "${CONF}\ninclude themes/${THEME}/theme.conf\n" | sudo tee ${DIR}/refind.conf
	
	# return to default directory
	cd
}

refind_theme
