#!/bin/sh

until microk8s.status --wait-ready;
  do sleep 3; echo "waiting for worker status..";
done


if microk8s status | grep "datastore master nodes: 127.0.0.1:19001" > /dev/null 2>&1; then
  microk8s join "${main_node_ip}:25000/${cluster_token}"
else
  echo "Join process already done. Nothing to do"
fi