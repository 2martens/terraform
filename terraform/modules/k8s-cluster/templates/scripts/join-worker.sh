#!/bin/sh

while test -z "\${command -v microk8s}";
  sleep 5; do echo \"Waiting for cloud init to finish...\";
done

until microk8s.status --wait-ready;
  do sleep 3; echo "waiting for worker status..";
done


if microk8s status | grep "datastore master nodes: 127.0.0.1:19001" > /dev/null 2>&1; then
  microk8s join ${main_node_ip}:25000/${cluster_token} --worker
else
  echo "Join process already done. Nothing to do"
fi