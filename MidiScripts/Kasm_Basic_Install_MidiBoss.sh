#!/bin/bash

# This ShellScript runs a basic Kasm single server installation as outlined on the Kasm Docs...
# https://kasmweb.com/docs/latest/install/single_server_install.html
# The usernames and generated passwords can be found after the install finishes in the
#   SSout.txt file in the root directory. Login to the lish console with your root password
#   and type " vi SSout.txt" then page down to the bottom of the file (esc : q enter to quit VI)
#

# Writing System.out (0) and System.error (2) to flat files in the root directory
exec >/root/SSout.txt 2>/root/SSerr.txt

# Every ECHO in this script will be prefixed with "MidiBoss - " to differentiate from commands

# Including this for just cause ;)
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


echo "MidiBoss - apt get update and dist-upgrade to freshen up the ubuntu install"
sudo apt-get update && sudo apt-get dist-upgrade -y

echo "MidiBoss - create a 1 gigabyte swap partition"
sudo dd if=/dev/zero bs=1M count=1024 of=/mnt/1GiB.swap
sudo chmod 600 /mnt/1GiB.swap
sudo mkswap /mnt/1GiB.swap
sudo swapon /mnt/1GiB.swap

echo "MidiBoss - make the swap file available on boot "
echo '/mnt/1GiB.swap swap swap defaults 0 0' | sudo tee -a /etc/fstab

echo "MidiBoss - download the latest version of Kasm Workspaces to /tmp"
cd /tmp || exit
sudo wget https://kasm-static-content.s3.amazonaws.com/kasm_release_1.10.0.238225.tar.gz

Echo "MidiBoss - Extract the package in the /tmp folder"
tar -xf kasm_release*.tar.gz

echo "MidiBoss - run the installation script -e accepts the EULA"
sudo bash kasm_release/install.sh -e

echo "Thank You for Choosing,"
echo
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