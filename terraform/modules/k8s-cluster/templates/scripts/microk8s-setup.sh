#!/bin/sh

mv /run/tmpfiles.d/microk8s.yaml /etc/microk8s.yaml

%{ if !main_node ~}
sleep 120
%{ endif ~}
snap install microk8s --classic --channel "${microk8s_channel}"
