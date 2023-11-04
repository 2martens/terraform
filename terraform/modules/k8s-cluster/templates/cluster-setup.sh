#!/bin/sh

microk8s helm repo add 2martens https://repo.2martens.de/charts/
microk8s helm install setup 2martens/cluster_setup --values /run/tmpfiles.d/cluster-setup-values.yaml
%{ if high_availability ~}
microk8s helm install argocd 2martens/argocd --set environment=${argocd_environment} --values /run/tmpfiles.d/argocd-values-ha.yaml
%{ else ~}
microk8s helm install argocd 2martens/argocd --set environment=${argocd_environment}
%{ endif ~}