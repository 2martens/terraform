#!/bin/sh

until /snap/bin/microk8s.status --wait-ready;
  do sleep 3; echo "waiting for worker status..";
done

/snap/bin/microk8s.helm3 repo add 2martens https://repo.2martens.de/charts/
/snap/bin/microk8s.helm3 install setup 2martens/cluster_setup --values /run/tmpfiles.d/cluster-setup-values.yaml
%{ if high_availability ~}
/snap/bin/microk8s.helm3 install argo-cd 2martens/argocd --create-namespace -n argocd --version ${argocd_version} --set environment=${argocd_environment} --values /run/tmpfiles.d/argocd-values-ha.yaml
%{ else ~}
/snap/bin/microk8s.helm3 install argo-cd 2martens/argocd --create-namespace -n argocd --version ${argocd_version} --set environment=${argocd_environment}
%{ endif ~}