#!/bin/sh

mkdir -p /var/snap/microk8s/common/etc/launcher
cp /home/terraform/.microk8s.yaml /var/snap/microk8s/common/etc/launcher/.microk8s.yaml
chown root:root /var/snap/microk8s/common/etc/launcher/.microk8s.yaml
%{ if !main_node ~}
sleep 120
%{ endif ~}
snap install microk8s --channel "${microk8s_channel}"
