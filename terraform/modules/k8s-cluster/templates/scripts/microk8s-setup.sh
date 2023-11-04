#!/bin/sh

mkdir -p /run/snap/launcher/configuration
cp /run/tmpfiles.d/microk8s.yaml /run/snap/launcher/configuration/content.yaml
cp /run/tmpfiles.d/snapcraft.yaml /run/snap/snapcraft.yaml
cd /run/snap && /snap/bin/snapcraft
snap install /run/snap/microk8s-cluster-config_*.snap --dangerous

%{ if !main_node ~}
sleep 120
%{ endif ~}
snap install microk8s --channel "${microk8s_channel}"
snap connect microk8s:configuration microk8s-cluster-config
