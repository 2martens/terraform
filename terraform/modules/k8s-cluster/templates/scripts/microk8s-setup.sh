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
/snap/bin/microk8s.kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/experimental-install.yaml
%{ if manager_node ~}
/snap/bin/microk8s.helm3 repo add prometheus-community https://prometheus-community.github.io/helm-charts
/snap/bin/microk8s.helm3 repo add cilium https://helm.cilium.io
/snap/bin/microk8s.helm3 repo add jetstack https://charts.jetstack.io
/snap/bin/microk8s.helm3 install prometheus-crds prometheus-community/prometheus-operator-crds
/snap/bin/microk8s.kubectl delete -f "/var/snap/microk8s/current/args/cni-network/cni.yaml"
sleep 2s
sudo mv /var/snap/microk8s/current/args/cni-network/cni.yaml /var/snap/microk8s/current/args/cni-network/cni.yaml.disabled
/snap/bin/microk8s.helm3 install cilium cilium/cilium --namespace kube-system --values /run/tmpfiles.d/cilium-values.yaml
/snap/bin/microk8s.helm3 install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --set installCRDs=true \
    --create-namespace \
    --set "extraArgs={--feature-gates=ExperimentalGatewayAPISupport=true}"
/snap/bin/microk8s enable ingress
%{ endif ~}
