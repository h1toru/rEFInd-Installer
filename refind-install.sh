#!/bin/bash
set -e

cd ${HOME}/Downloads

URL='https://onboardcloud.dl.sourceforge.net/project/refind/0.14.0.2/refind-bin-0.14.0.2.zip'
curl $URL -o refind.zip
unzip -o refind.zip && rm -f refind.zip
REFIND=$(ls -A | grep 'refind-bin')
chmod +x ${REFIND}/*
. ${REFIND}/refind-install && rm -rf $REFIND

cd
