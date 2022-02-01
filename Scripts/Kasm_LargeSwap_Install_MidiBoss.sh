#!/bin/bash

# Writing System.out (0) and System.error (2) to flat files in the root directory
exec >/root/SSout.txt 2>/root/SSerr.txt

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
sudo apt-get update && sudo apt-get -q dist-upgrade -y

########################################################################
## Quoted from
##In Docker you have 2 alternatives: (1) run each command separately
# rather than with && joining them (might work, but it's not the "docker
# way") (2) redirect the output to /dev/null like in the other answer.
# Option 2 is probably your best bet while there is this bug
##
##########################################################################

echo "Midiboss - Hardening the server ----------------------------------------"
echo "Midiboss - Setting hostname to 'MidiKasm' ------------------------------"
hostnamectl set-hostname MidiKasm


#echo "Midiboss - Getting IP from hostname for Hostfile ----------------------"
# hostname -I

                             
echo "Midiboss - Adding Default super user 'KasmBoss' "
sudo useradd -m KasmBoss
echo -e "Change4Me!\nChange4Me!" | passwd KasmBoss

echo "Midiboss - add user to sudo group"
usermod -a -G sudo KasmBoss                           


echo "Midiboss - install and setup fail2ban"
echo "Midiboss - use 'sudo fail2ban-client status' and 'sudo fail2ban-client status sshd' to check bans"
sudo apt install fail2ban -y
echo -e "
[DEFAULT]
destemail = Joseph@TheMidiBoss.com
sendername = Fail2Ban
sudo systemctl restart fail2ban

[sshd]
enabled = true
port = 444

[sshd-ddos]
enabled = true
port = 444
" >> /etc/fail2ban/jail.local

echo "MidiBoss changing 1 gig swap to 5 gig for ability to host 5 instances "
#sudo dd if=/dev/zero bs=1M count=5120 of=/mnt/5GiB.swapsudo chmod 600 /mnt/5GiB.swap
#sudo mkswap /mnt/5GiB.swap
#sudo swapon /mnt/5GiB.swap

echo "MidiBoss To make the swap file available on boot"
echo '/mnt/5GiB.swap swap swap defaults 0 0' | sudo tee -a /etc/fstab

echo "MidiBoss Download the latest version of Kasm Workspaces to /tmp//Extract the package and run the installation script."
echo "MidiBoss Default port 433 is initialised, can change"
cd /tmp || exit
sudo wget https://kasm-static-content.s3.amazonaws.com/kasm_release_1.10.0.238225.tar.gz
tar -xf kasm_release*.tar.gz

sudo bash kasm_release/install.sh -e

echo "MidiBoss -Secure SSH from Linode setup guide"          
sed -i -e 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i -e 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
systemctl restart sshd


echo "MidiBoss - Make Scary Banner"
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
" >>  /etc/ssh/sshd-banner

#First time login info...
#      User - KasmBoss
#      pass - Change4Me!
s
ed -i -e 's/#Banner none/Banner /etc/ssh/sshd-banner/g' /etc/ssh/sshd_config
Banner /etc/ssh/sshd-banner
systemctl restart sshd
