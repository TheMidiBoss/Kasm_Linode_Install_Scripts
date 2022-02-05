#!/bin/bash
echo -e"
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
                              #########   ########   ########   ########    "

#todo add firewall
#https://github.com/kgryte/linode-setup-notes/blob/master/README.md

# Writing System.out (0) and System.error (2) to flat files in the root directory
exec >/root/SSout.txt 2>/root/SSerr.txt

MidiKasmLatestVersionUrl="https://kasm-static-content.s3.amazonaws.com/kasm_release_1.10.0.238225.tar.gz"
MidiDockerComposeYamlURL="https://raw.githubusercontent.com/TheMidiBoss/Kasm_Linode_Install_Scripts/74f3ce9ed94667df7231abf9d78c73650b305f37/MidiScripts/MidiResource/docker-compose.yaml"
MidiUserName="KasmBoss"
MidiPassword="Change4Me!"
MidiDomainName="uraharas.net"
MidiHostName="MidiKasm"
MidiEmailfail2ban="Joseph@TheMidiBoss.com"
MidiIPAddress=$(hostname -I | awk '{print $1 }')
echo "$MidiIPAddress - is ths ip address right now............................................."

echo "MidiBoss - apt get update and dist-upgrade to freshen up the ubuntu"
sudo apt-get -q update  > /root/1.AptGetUpdate.log
sudo apt-get -q dist-upgrade -y > /root/2.AptGetUpgrade.log


echo "MidiBoss - Hardening the server ----------------------------------------"
      echo "MidiBoss - locking root password, we may need to comment this out.  ----------------------------------------"
          #passwd --lock root

      echo "MidiBoss - Setting hostname to 'MidiKasm' ------------------------------"
          sudo hostnamectl set-hostname $MidiHostName

      echo "MidiBoss - Adding Default super user 'KasmBoss' ------------------------"
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
          #/etc/ssh/sshd-banner
          #echo "MidiBoss - setting banner to sshd config" #todo add banner stuff back in
          #sed -i -e "s%'#Banner none'%'Banner /etc/ssh/sshd-banner'%g" /etc/ssh/sshd_config

      echo "MidiBoss - Restart SSHD service to lock in settings"
          systemctl restart sshd

      echo "MidiBoss - set hosts file"
          echo -e "$MidiIPAddress\t$MidiDomainName $MidiHostName" >> /etc/hosts

      echo "MidiBoss - install and setup fail2ban"
          echo "MidiBoss - use 'sudo fail2ban-client status' and 'sudo fail2ban-client status sshd' to check bans"
          sudo apt-get install fail2ban -y > /root/3fail2ban.log
          echo -e "
[DEFAULT]
destemail = $MidiEmailfail2ban
sendername = Fail2Ban

[sshd]
enabled = true
port = 444

[sshd-ddos]
enabled = true
port = 444
" >>/etc/fail2ban/jail.local

sudo systemctl restart fail2ban


echo "MidiBoss - Hardening complete, Setting up Nginx "
    echo "MidiBoss - Install Docker Stuff here"
        sudo apt-get install -y docker
        sudo apt-get -q install -y docker-compose

      echo "MidiBoss - Make the working directory for docker"
          mkdir /opt/nginxproxymanager
          cd /opt/nginxproxymanager || exit

      echo "MidiBoss - Download the docker compose file from Github"
          sudo wget $MidiDockerComposeYamlURL

      echo "MidiBoss - Docker it UP"
          docker-compose up -d

echo "MidiBoss - Nginx complete, Setting up Kasm "
    echo "MidiBoss - changing 1 gig swap to 5 gig for ability to host 5 instances "
        sudo dd if=/dev/zero bs=1M count=5120 of=/mnt/5GiB.swap
        sudo chmod 600 /mnt/5GiB.swap
        sudo mkswap /mnt/5GiB.swap
        sudo swapon /mnt/5GiB.swap

    echo "MidiBoss - To make the swap file available on boot"
        echo -e "/mnt/5GiB.swap\tswap\t\tswap\tdefaults\t  0\t0" | sudo tee -a /etc/fstab

    echo "MidiBoss - Download the latest version of Kasm Workspaces to /tmp"
        cd /tmp || exit
        sudo wget $MidiKasmLatestVersionUrl

    echo "MidiBoss - Extract the package and duplicate it to the save folder (can remove later after dev)"
        tar -xf kasm*.tar.gz
        mkdir save
        cp -r kasm_release save

    echo "MidiBoss - Run the installation script. Changed to port 8433 is initialised, TODO change to $"
        sudo bash kasm_release/install.sh -e -L 8433 -I -P $MidiPassword -p $MidiDomainName  #TODO change 8443 to $"



    echo "MidiBoss - Kasm Done installing portainer"
      cd ~/ || exit
      docker volume create portainer_data
      #docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
docker run -d -p 8000:8000 -p 9444:9444 --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    cr.portainer.io/portainer/portainer-ce:2.11.0


cd /tmp || exit
echo "MidiBoss - Install my longview link ----------- Only works on fresh longview sessions?"
# curl -s https://lv.linode.com/58BBB504-5535-4FC8-A1089B85287932AB | sudo bash

touch /root/all.done
sudo reboot
