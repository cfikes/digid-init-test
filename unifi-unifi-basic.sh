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
}

InstallUnifi() {
	apt-get install unifi -y
}

InstallNginx(){
	apt-get install nginx -y
	systemctl stop nginx
	
	#export HOSTNAME=$(curl -s http://169.254.169.254/metadata/v1/hostname)

	echo "server {" > /etc/nginx/sites-enabled/DigiD-UniFi
	echo "listen 88;" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "server_name" $(hostname) ";">> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "#" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "location /wss/ {" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "proxy_pass https://localhost:8443" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "proxy_http_version 1.1;" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "proxy_buffering off;" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "proxy_set_header Upgrade $http_upgrade;" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "proxy_set_header Connection "Upgrade";" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "proxy_read_timeout 86400;" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "}" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "#" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "location / {" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "proxy_pass https://localhost:8443/;" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "proxy_set_header Host $host;" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "proxy_set_header X-Real-IP $remote_addr;" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "}" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "#ssl_certificate /etc/ssl/certs/selfsigned.crt;" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "#ssl_certificate_key /etc/ssl/private/selfsigned.key;" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "}" >> /etc/nginx/sites-enabled/DigiD-UniFi
	echo "#" >> /etc/nginx/sites-enabled/DigiD-UniFi
	
	rm -f /etc/nginx/sites-enabled/default
	systemctl start nginx	


}

InstallPre
InstallUnifi
InstallNginx
