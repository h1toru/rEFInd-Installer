#!/bin/bash
set -e

# change working directory
cd ${HOME}/Downloads

# refind directory
DIR=$(sudo find /boot/ -type 'f' -name 'refind.conf' | sed 's|/refind.conf||g')

# check dependencies
command -v git &>/dev/null || {
	echo -n "git not found! installing.. "
	sudo apt -y update &>/dev/null
	sudo apt -y install git &>/dev/null &&
	echo "success!"
}

# download the theme
local REPO='https://github.com/bobafetthotmail/refind-theme-regular'
local THEME=${REPO##*/}
git clone ${REPO}.git

# remove unnecessary files
{	rm -rf ${THEME}/.git
	rm -f ${THEME}/README.md
	rm -f ${THEME}/LICENSE
	rm -f ${THEME}/install.sh
	rm -rf ${THEME}/src
} 2>/dev/null

# copy theme
[ -d "${DIR}/themes" ] && {
	sudo rm -rf ${DIR}/themes
	sudo mkdir -p ${DIR}/themes
	sudo cp -rf $THEME ${DIR}/themes/
}

# fetch configuration
URL='https://raw.githubusercontent.com/hitoru/rEFInd/main/hitoru.conf'
curl $URL -o hitoru.conf
sudo cp -af hitoru.conf ${DIR}/hitoru.conf && rm -f hitoru.conf
echo "include hitoru.conf" >/dev/null | sudo tee -a ${DIR}/refind.conf

# return to default directory
cd
