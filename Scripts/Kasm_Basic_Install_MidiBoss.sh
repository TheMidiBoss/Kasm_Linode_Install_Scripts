#!/bin/bash

# Writing System.out and System.error to flat files in the root directory
exec >/root/SSout 2>/root/SSerr

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
sudo apt-get update && sudo apt-get dist-upgrade

echo "MidiBoss changing 1 gig swap to 5 gig for ability to host 5 instances "
sudo dd if=/dev/zero bs=1M count=5120 of=/mnt/5GiB.swap
sudo chmod 600 /mnt/5GiB.swap
sudo mkswap /mnt/5GiB.swap
sudo swapon /mnt/5GiB.swap

echo "MidiBoss To make the swap file available on boot"
echo '/mnt/5GiB.swap swap swap defaults 0 0' | sudo tee -a /etc/fstab

echo "MidiBoss Download the latest version of Kasm Workspaces to /tmp//Extract the package and run the installation script."
echo "MidiBoss Default port 433 is initialised, can change"
cd /tmp || exit
sudo wget https://kasm-static-content.s3.amazonaws.com/kasm_release_1.10.0.238225.tar.gz
tar -xf kasm_release*.tar.gz

sudo bash kasm_release/install.sh -e