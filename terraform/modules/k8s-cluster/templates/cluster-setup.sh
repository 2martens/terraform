#!/bin/sh

helm repo add 2martens https://repo.2martens.de/charts/
helm install setup 2martens/cluster_setup --values /run/terraform/cluster-setup-values.yaml
%{ if high_availability ~}
helm install argocd 2martens/argocd --set environment=${argocd_environment} --values /run/tmpfiles.d/argocd-values-ha.yaml
%{ else ~}
helm install argocd 2martens/argocd --set environment=${argocd_environment}
%{ endif ~}