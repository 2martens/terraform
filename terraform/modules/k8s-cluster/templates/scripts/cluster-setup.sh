#!/bin/sh

until /snap/bin/microk8s.status --wait-ready;
  do sleep 3; echo "waiting for worker status..";
done

mkdir -p /home/${admin_user}/.kube
cp /var/snap/microk8s/current/credentials/client.config /home/${admin_user}/.kube/config
chmod 600 /home/${admin_user}/.kube/config
chown -R ${admin_user}:${admin_user} /home/${admin_user}/.kube
/snap/bin/microk8s.helm3 repo add 2martens https://repo.2martens.de/charts/
/snap/bin/microk8s.helm3 repo add argo https://argoproj.github.io/argo-helm
/snap/bin/microk8s.helm3 repo add cilium https://helm.cilium.io
/snap/bin/microk8s.helm3 upgrade cilium cilium/cilium --version 1.13.4 --namespace kube-system --reuse-values --set prometheus.enabled=true --set operator.prometheus.enabled=true --set hubble.metrics.enableOpenMetrics=true --set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,httpV2:exemplars=true;labelsContext=source_ip\,source_namespace\,source_workload\,destination_ip\,destination_namespace\,destination_workload\,traffic_direction}"
/snap/bin/microk8s.helm3 install setup 2martens/cluster_setup --values /run/tmpfiles.d/cluster-setup-values.yaml
%{ if high_availability ~}
/snap/bin/microk8s.helm3 install argo-cd argo/argo-cd --create-namespace -n argocd --values /run/tmpfiles.d/argocd-values-ha.yaml
%{ else ~}
/snap/bin/microk8s.helm3 install argo-cd argo/argo-cd --create-namespace -n argocd --values /run/tmpfiles.d/argocd-values.yaml
%{ endif ~}
/snap/bin/microk8s.helm3 install argocd-config 2martens/argocd-configuration -n argocd --set environment=${argocd_environment}
