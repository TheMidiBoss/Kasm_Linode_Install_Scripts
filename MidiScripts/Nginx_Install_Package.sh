#!/bin/bash


# Writing System.out (0) and System.error (2) to flat files in the root directory
exec >/root/SSout.txt 2>/root/SSerr.txt

MidiDomainName="uraharas.net"
MidiHostName="MidiKasm"
MidiIPAddress=$(hostname -I | awk '{print $1 }')
MidiDocker-ComposeLocation="https://github.com/TheMidiBoss/Kasm_Linode_Install_Scripts/blob/74f3ce9ed94667df7231abf9d78c73650b305f37/MidiScripts/MidiResource/docker-compose.yaml"

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
sudo apt-get install -y docker
sudo apt-get -q install -y docker-compose

mkdir /opt/nginxproxymanager
cd /opt/nginxproxymanager || exit
sudo wget $MidiDocker-ComposeLocation

docker-compose up -d

touch /root/all.done
#sudo reboot