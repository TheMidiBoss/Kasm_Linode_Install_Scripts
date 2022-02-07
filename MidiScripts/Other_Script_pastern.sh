
#!/bin/bash
# SIMPLE WAYS TO MAKE LIFE EASIER
# Better Performance use Linode 2 GB
# Ubuntu 21.10 , Ubuntu 21.04 , Ubuntu 20.04 , Ubuntu 18.04 , Ubuntu 16.04 , Debian 11 , Debian 10 , Debian 9
# Cockpit + Docker + Docker-Compose + Portainer + Portainer-Agent + Nginx-Proxy-Manager + ctop
#
# Fixed repo full update and upgrade - REBOOT after upgrade
# UPGRADE disable if not need line 141 # not upgrade first or not working all ubuntu releases ,tested
# UPGRADE take some time about 3 min after that there is a reboot,Don't be surprised if the connection is lost for a while.
# All Docker Official Images
#
# Cockpit is a web-based graphical interface for servers.
# Portainer is a web-based graphical containers manager.
# Portainer-Agent is will communicate with the Docker node.
# Nginx-Proxy-Manager Secure Your Domain with ssl and CloudFlare !!! google help
# Ctop - real-time metrics for multiple containers with terminal.
# Configs folder - /root/docker
#
# Cockpit               https://{host}:9090     Login:root  and Your Password
# Nginx-Proxy-Manager   http://{host}:81        Login:admin@example.com  Password: changeme
# Portainer             https://{host}:9443     Login:admin and Your Password
# Portainer-Agent       https://{host}:9001     Portainer API
#
#
# IMPORTANT: Once deployed, visit https://{host}:9443 to setup Portainer admin password!
# After Deploy go web Settings Portainer Environments > local change 0.0.0.0 it to your Public IP
#
# IMPORTANT: Once deployed, visit http://{host}:81   to setup Nginx-Proxy-Manager admin password!
#
### Update server
export DEBIAN_FRONTEND=noninteractive
lsb_rel="$(lsb_release -sc)"
### Fix cockpit install error Debian 9
if [ "$lsb_rel" = "stretch" ]; then
     echo "Installing on Debian 9"
     echo "deb [arch=amd64] http://deb.debian.org/debian $(lsb_release -cs)-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
else
    echo "not Debian 9"
fi
### Fix update IPv6 method error
apt-get -o Acquire::ForceIPv4=true update -y
apt-get install sudo -y
sudo echo 'Acquire::ForceIPv4 "true";' | tee /etc/apt/apt.conf.d/99force-ipv4
sudo echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
### Set timezone and hostname
sudo timedatectl set-timezone Europe/London
sudo hostnamectl set-hostname cockpit.server.us
sudo hostnamectl --transient set-hostname cockpit.server.us
sudo echo "cockpit.server.us" > /etc/hostname
sudo echo "127.0.0.1   cockpit.server.us cockpit localhost" > /etc/hosts
sudo echo "::1         localhost ip6-localhost ip6-loopback" >> /etc/hosts
sudo echo "ff02::1         ip6-allnodes" >> /etc/hosts
sudo echo "ff02::2         ip6-allrouters" >> /etc/hosts
sudo echo "sudoers:        files" >> /etc/nsswitch.conf
### Fix cockpit-pcp update error ubuntu 18.04
if [ "$lsb_rel" = "bionic" ]; then
     echo "Installing on ubuntu 18.04"
     sudo apt-get upgrade -t bionic-backports cockpit -y
else
    echo "not ubuntu 18.04"
fi
sudo apt-get remove -y docker docker.io containerd runc
for i in net-tools curl nano wget git gedit unzip htop locate preload cockpit cockpit-pcp apt-transport-https ca-certificates gnupg-agent software-properties-common; do sudo apt-get install -y $i; done
sudo updatedb
### Fix systemd-udevd vethXXXXXXX: Failed to get link config: No such device
sudo touch /etc/udev/rules.d/80-net-setup-link.rules
sudo echo 'ACTION=="add", SUBSYSTEM=="net", KERNEL=="eth*", ATTR{tx_queue_len}="1000"' | sudo tee /etc/udev/rules.d/10-persistent-network.rules
### Fix watchdog: watchdog0: watchdog did not stop!
sudo echo "RuntimeWatchdogSec=0" >> /etc/systemd/system.conf
sudo echo "RebootWatchdogSec=0" >> /etc/systemd/system.conf
sudo echo "ShutdownWatchdogSec=0" >> /etc/systemd/system.conf
### Fix cockpit udisks2 error
sudo mkdir -p /usr/lib/x86_64-linux-gnu/udisks2/modules
### Fix ctop path error ubuntu 18.04 and 16.04
export PATH=/usr/bin:$PATH
### Install Docker
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get -o Acquire::ForceIPv4=true update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
### Install Docker-Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
###  Enable service to run at startup
sudo systemctl enable --now cockpit.socket
sudo systemctl enable --now docker
### Firewall rules enable ports
sudo ufw allow 9090/tcp
sudo ufw allow 9443/tcp
sudo ufw allow 9001/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 81/tcp
sudo systemctl restart docker
sudo systemctl restart cockpit.socket
### Create network and start a docker containers
sudo usermod -aG docker $(whoami)
sudo mkdir /root/docker
sudo docker network create --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=eth0 proxy
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
    --restart=always \
    --network=proxy \
    --privileged \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /root/docker/portainer:/data \
    portainer/portainer-ce:latest

sudo docker run -d -p 9001:9001 --name portainer_agent \
    --restart=always \
    --network=proxy \
    --privileged \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/lib/docker/volumes:/var/lib/docker/volumes \
    portainer/agent:latest
sudo docker run -d -p 80:80 -p 443:443 -p 81:81 --name nginx_proxy_manager \
    --restart=always \
    --network=proxy \
    --privileged \
    -v /root/docker/proxymanager/data:/data \
    -v /root/docker/letsencrypt:/etc/letsencrypt \
    jc21/nginx-proxy-manager:latest
### Install ctop: https://github.com/bcicen/ctop
wget https://github.com/bcicen/ctop/releases/download/0.7.6/ctop-0.7.6-linux-amd64 -O /usr/local/bin/ctop
chmod +x /usr/local/bin/ctop
### Upgrade server
sudo -E apt-get -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" dist-upgrade -q -y --allow-downgrades --allow-remove-essential --allow-change-held-packages
### Ubuntu Fix cockpit update error Cannot refresh cache whilst offline.
### sudo sed -i -re 's/([a-z]{2}\.)?networkd/NetworkManager/g' /etc/netplan/01-netcfg.yaml
sudo echo "network:" > /etc/netplan/01-network-manager-all.yaml
sudo echo "  version: 2" >> /etc/netplan/01-network-manager-all.yaml
sudo echo "  renderer: NetworkManager" >> /etc/netplan/01-network-manager-all.yaml
sudo netplan generate
sudo netplan apply
sudo systemctl restart NetworkManager
### Fix Debian 10 Store Metrics.
if [ "$lsb_rel" = "buster" ]; then
     echo "Fix Debian 10 Store Metrics"
     sudo systemctl cat --full pmcd.service
     sudo systemctl cat --full pmlogger.service
     sudo echo "[Install]" >> /etc/systemd/system/pmlogger.service
     sudo echo "WantedBy = multi-user.target" >> /etc/systemd/system/pmlogger.service
     sudo systemctl daemon-reload
     sudo systemctl enable pmlogger.service
     sudo systemctl restart pmcd.service
else
    echo "not Debian 10"
fi
### Clean server
sudo apt-get autoclean
sudo apt-get autoremove --purge
sudo touch /var/lib/cloud/instance/warnings/.skip
### Reboot server
reboot