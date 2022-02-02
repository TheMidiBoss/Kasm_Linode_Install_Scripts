#!/bin/bash

#todo add firewall

# Writing System.out (0) and System.error (2) to flat files in the root directory
exec >/root/SSout.txt 2>/root/SSerr.txt

MidiKasmLatestVersionUrl="https://kasm-static-content.s3.amazonaws.com/kasm_release_1.10.0.238225.tar.gz"
MidiUserName="KasmBoss"
MidiPassword="Change4Me!"
MidiDomainName="uraharas.net"
MidiHostName="MidiKasm"
MidiEmailfail2ban="Joseph@TheMidiBoss.com"
MidiIPAddress=$(hostname -I | awk '{print $1 }')
echo "$MidiIPAddress - is ths ip address right now............................................."
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
sudo apt-get -qq update
sudo apt-get -qq dist-upgrade -y
#sudo install tree
#sudo install maven

########################################################################
## Quoted from
##In Docker you have 2 alternatives: (1) run each command separately
# rather than with && joining them (might work, but it's not the "docker
# way") (2) redirect the output to /dev/null like in the other answer.
# Option 2 is probably your best bet while there is this bug
##
##########################################################################

echo "MidiBoss - Hardening the server ----------------------------------------"
echo "MidiBoss - locking root password, we may need to comment this out.  ----------------------------------------"
#passwd --lock root
echo "MidiBoss - Setting hostname to 'MidiKasm' ------------------------------"
sudo hostnamectl set-hostname $MidiHostName
echo "MidiBoss - Adding Default super user 'KasmBoss' ------------------------"
#sudo adduser $MidiUserName --disabled-password --gecos --force-badname ""
sudo useradd -m $MidiUserName
echo -e "$MidiPassword\n$MidiPassword" | passwd $MidiUserName
echo "MidiBoss - add user to sudo group------------------------------------------"
usermod -a -G sudo $MidiUserName

echo "MidiBoss -Secure SSH from Linode setup guide----------------------------"
sed -i -e "s/PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i -e "s/#PermitRootLogin no/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i -e "s/PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
sed -i -e "s/#PasswordAuthentication no/PasswordAuthentication no/" /etc/ssh/sshd_config
echo "MidiBoss - Make Scary SSH Banner"
echo -e "
::::    ::::  ::::::::::: ::::::::: :::::::::::
+:+:+: :+:+:+     :+:     :+:    :+:    :+:
+:+ +:+:+ +:+     +:+     +:+    +:+    +:+
+#+  +:+  +#+     +#+     +#+    +:+    +#+
+#+       +#+     +#+     +#+    +#+    +#+
#+#       #+#     #+#     #+#    #+#    #+#
###       ### ########### ######### ###########
                          :::::::::   ::::::::   ::::::::   ::::::::
                          :+:    :+: :+:    :+: :+:    :+: :+:    :+:
                          +:+    +:+ +:+    +:+ +:+        +:+
                          +#++:++#+  +#+    +:+ +#++:++#++ +#++:++#++
                          +#+    +#+ +#+    +#+        +#+        +#+
                          #+#    #+# #+#    #+# #+#    #+# #+#    #+#
                          #########   ########   ########   ########
-----------------------------------------------------------------------

Thank you for flying MidiBoss!!
" >>/etc/ssh/sshd-banner
echo "MidiBoss - setting banner to sshd config"
sed -i -e 's/#Banner none/Banner /etc/ssh/sshd-banner/g' /etc/ssh/sshd_config
echo "MidiBoss - Restart SSHD service to lock in settings"
systemctl restart sshd

echo "MidiBoss - set hosts file"
echo -e "$MidiIPAddress\t$MidiDomainName $MidiHostName" >> /etc/hosts


echo "MidiBoss - install and setup fail2ban"
echo "MidiBoss - use 'sudo fail2ban-client status' and 'sudo fail2ban-client status sshd' to check bans"
sudo apt install fail2ban -y
echo -e "
  [DEFAULT]
  destemail = $MidiEmailfail2ban
  sendername = Fail2Ban
  sudo systemctl restart fail2ban

  [sshd]
  enabled = true
  port = 444

  [sshd-ddos]
  enabled = true
  port = 444
  " >>/etc/fail2ban/jail.local

echo "MidiBoss - Hardening complete, Setting up Kasm "
echo "MidiBoss - changing 1 gig swap to 5 gig for ability to host 5 instances "
sudo dd if=/dev/zero bs=1M count=5120 of=/mnt/5GiB.swap
sudo chmod 600 /mnt/5GiB.swap
sudo mkswap /mnt/5GiB.swap
sudo swapon /mnt/5GiB.swap

echo "MidiBoss To make the swap file available on boot"
echo '/mnt/5GiB.swap swap swap defaults 0 0' | sudo tee -a /etc/fstab

echo "MidiBoss Download the latest version of Kasm Workspaces to /tmp//Extract the package and run the installation script."
echo "MidiBoss Default port 433 is initialised, can change"
cd /tmp || exit
#sudo wget $MidiKasmLatestVersionUrl
#tar -xf kasm*.tar.gz

#sudo bash kasm_release/install.sh -e


echo "MidiBoss - Install my longview link ----------- Only works on fresh longview sessions?"
# curl -s https://lv.linode.com/58BBB504-5535-4FC8-A1089B85287932AB | sudo bash

sudo reboot
