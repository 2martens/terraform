#!/bin/sh

until /snap/bin/microk8s.status --wait-ready;
  do sleep 3; echo "waiting for worker status..";
done

/snap/bin/microk8s helm repo add 2martens https://repo.2martens.de/charts/
/snap/bin/microk8s helm install setup 2martens/cluster_setup --values /run/tmpfiles.d/cluster-setup-values.yaml
%{ if high_availability ~}
/snap/bin/microk8s helm install argocd 2martens/argocd --set environment=${argocd_environment} --values /run/tmpfiles.d/argocd-values-ha.yaml
%{ else ~}
/snap/bin/microk8s helm install argocd 2martens/argocd --set environment=${argocd_environment}
%{ endif ~}