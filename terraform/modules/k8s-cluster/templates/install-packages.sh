#!/bin/sh

apt-get -y install fail2ban
apt-get -y install ufw
apt-get -y install snapd

curl https://packages.hetzner.com/hcloud/deb/hc-utils_0.0.4-1_all.deb -o /tmp/hc-utils_0.0.4-1_all.deb -s
apt install /tmp/hc-utils_0.0.4-1_all.deb
snap install kubectl --classic