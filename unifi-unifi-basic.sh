#!/bin/bash

# DigiD.Cloud UniFi Controller Deployment
# FikesMedia (C) 2020 All Rights Reserved
# Ubuntu 18.04 LTS

InstallPre() {
	# APT Requirements
	apt-get update
	apt-get install curl ca-certificates apt-transport-https wget gnupg -y
	echo "Installed"
	
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
	apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50

	echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
	echo 'deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list

	apt-get update

	# Custom Requirements

}

InstallUnifi() {
	apt-get install unifi
}

InstallPre
InstallUnifi
