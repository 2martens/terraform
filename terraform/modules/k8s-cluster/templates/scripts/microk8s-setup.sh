#!/bin/sh

mv /run/tmpfiles.d/microk8s.yaml /etc/microk8s.yaml

%{ if !main_node ~}
sleep 120
%{ endif ~}
snap install microk8s --classic --channel "${microk8s_channel}"
/snap/bin/microk8s addons repo remove core
/snap/bin/microk8s addons repo add core https://github.com/canonical/microk8s-core-addons
/snap/bin/microk8s addons repo add community https://github.com/canonical/microk8s-community-addons
/snap/bin/microk8s enable cis-hardening
/snap/bin/microk8s enable rbac
%{ if manager_node ~}
/snap/bin/microk8s enable ingress
/snap/bin/microk8s enable cert-manager
/snap/bin/microk8s enable cilium
/snap/bin/microk8s cilium hubble enable
%{ endif ~}
