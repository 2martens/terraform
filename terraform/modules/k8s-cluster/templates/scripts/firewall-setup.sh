#!/bin/sh

printf "[sshd]\nenabled = true\nbanaction = iptables-multiport" > /etc/fail2ban/jail.local
systemctl enable fail2ban

ufw allow OpenSSH
ufw allow 16443 comment "Kubernetes API endpoint"
ufw allow 80 comment HTTP
ufw allow 443 comment HTTPS
ufw allow to ${node_ip} port 4244 comment "Hubble peer endpoint"
ufw allow to ${node_ip} port 8472 comment "VXLAN connectivity"
ufw allow to ${node_ip} port 9100 comment "Metrics endpoint"
ufw allow to ${node_ip} port 9962 comment "Cilium agent metrics"
ufw allow to ${node_ip} port 9963 comment "Cilium operator metrics"
ufw allow to ${node_ip} port 9964 comment "Cilium agent endpoint"
ufw allow to ${node_ip} port 9965 comment "Hubble metrics endpoint"
ufw allow to ${node_ip} port 10249 comment "kube-proxy metrics port"
ufw allow to ${node_ip} port 10250 comment "cadvisor port"
ufw allow to ${node_ip} port 10259 comment "kube-scheduler port"
ufw allow to ${node_ip} port 10257 comment "kube-controller-manager port"
ufw allow to ${node_ip} port 25000 comment "port for joining nodes"
ufw allow to ${node_ip} port 10901 comment "port for thanos sidecar"
ufw enable