#!/bin/sh

while test -z "\${command -v microk8s}";
  sleep 5; do echo \"Waiting for cloud init to finish...\";
done

until microk8s.status --wait-ready;
  do sleep 5; echo "waiting for worker status..";
done

sleep 10
microk8s add-node --token ${cluster_token} --token-ttl ${cluster_token_ttl_seconds}
