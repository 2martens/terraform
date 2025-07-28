#!/bin/bash

apt-get -y install gnupg2 ubuntu-keyring

curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

echo \
  "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") nginx" | \
  tee /etc/apt/sources.list.d/nginx.list

echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | tee /etc/apt/preferences.d/99nginx

apt-get update
apt-get -y install nginx

# Remove the default Nginx configuration file
rm /etc/nginx/sites-enabled/default

# Enable the Nginx site configuration
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

nginx