#!/bin/bash


# Writing System.out (0) and System.error (2) to flat files in the root directory
exec >/root/SSout.txt 2>/root/SSerr.txt

MidiDomainName="uraharas.net"
MidiIPAddress=$(hostname -I | awk '{print $1 }')

# Including this for fun
# Every ECHO in this script will be prefixed with "MidiBoss - " to differentiate from commands

echo "::::    ::::  ::::::::::: ::::::::: :::::::::::                        "
echo "+:+:+: :+:+:+     :+:     :+:    :+:    :+:                            "
echo "+:+ +:+:+ +:+     +:+     +:+    +:+    +:+                            "
echo "+#+  +:+  +#+     +#+     +#+    +:+    +#+                            "
echo "+#+       +#+     +#+     +#+    +#+    +#+                            "
echo "#+#       #+#     #+#     #+#    #+#    #+#                            "
echo "###       ### ########### ######### ###########                        "
echo "                          :::::::::   ::::::::   ::::::::   ::::::::   "
echo "                          :+:    :+: :+:    :+: :+:    :+: :+:    :+:  "
echo "                          +:+    +:+ +:+    +:+ +:+        +:+         "
echo "                          +#++:++#+  +#+    +:+ +#++:++#++ +#++:++#++  "
echo "                          +#+    +#+ +#+    +#+        +#+        +#+  "
echo "                          #+#    #+# #+#    #+# #+#    #+# #+#    #+#  "
echo "                          #########   ########   ########   ########   "

echo "MidiBoss - apt get update and dist-upgrade to freshen up the ubuntu"
# -q is no animation, -y is accept
sudo apt-get -q update  > /root/1update.log
#sudo apt-get -qq dist-upgrade -y > /root/2upgrade.log

echo "MidiBoss - set hosts file"
echo -e "$MidiIPAddress\t$MidiDomainName $MidiHostName" >> /etc/hosts


echo "MidiBoss - New Stuff here"
echo sudo apt-get install -y docker
echo sudo apt-get -q install -y docker-compose

echo mkdir /opt/nginxproxymanager
cd /opt/nginxproxymanager
echo -e '
version: '3'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    environment:
      DB_MYSQL_HOST: "db"
      DB_MYSQL_PORT: 3306
      DB_MYSQL_USER: "npm"
      DB_MYSQL_PASSWORD: "npm"
      DB_MYSQL_NAME: "npm"
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
  db:
    image: 'jc21/mariadb-aria:latest'
    environment:
      MYSQL_ROOT_PASSWORD: 'npm'
      MYSQL_DATABASE: 'npm'
      MYSQL_USER: 'npm'
      MYSQL_PASSWORD: 'npm'
    volumes:
      - ./data/mysql:/var/lib/mysql

' >> docker-compose.yml

docker-compose up -d



touch /root/all.done
sudo reboot