#!/bin/sh

until /snap/bin/microk8s.status --wait-ready;
  do sleep 3; echo "waiting for worker status..";
done

mkdir -p /home/${admin_user}/.kube
/snap/bin/microk8s.kubectl config view > /home/${admin_user}/.kube/config
chmod 600 /home/${admin_user}/.kube/config
chown -R ${admin_user}:${admin_user} /home/2martensAdmin/.kube
/snap/bin/microk8s.helm3 repo add 2martens https://repo.2martens.de/charts/
/snap/bin/microk8s.helm3 install setup 2martens/cluster_setup --values /run/tmpfiles.d/cluster-setup-values.yaml
%{ if high_availability ~}
/snap/bin/microk8s.helm3 install argo-cd 2martens/argocd --create-namespace -n argocd --version ${argocd_version} --set environment=${argocd_environment} --values /run/tmpfiles.d/argocd-values-ha.yaml
%{ else ~}
/snap/bin/microk8s.helm3 install argo-cd 2martens/argocd --create-namespace -n argocd --version ${argocd_version} --set environment=${argocd_environment}
%{ endif ~}