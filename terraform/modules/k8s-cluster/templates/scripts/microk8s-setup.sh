#!/bin/sh

mkdir -p /run/tmpfiles.d/snap/launcher/configuration
mv /run/tmpfiles.d/microk8s.yaml /run/tmpfiles.d/snap/launcher/configuration/content.yaml
mv /run/tmpfiles.d/snapcraft.yaml /run/tmpfiles.d/snap/snapcraft.yaml
cd /run/tmpfiles.d/snap && /snap/bin/snapcraft
snap install /run/tmpfiles.d/snap/microk8s-cluster-config_*.snap --dangerous

%{ if !main_node ~}
sleep 120
%{ endif ~}
snap install microk8s --channel "${microk8s_channel}"
snap connect microk8s:configuration microk8s-cluster-config
