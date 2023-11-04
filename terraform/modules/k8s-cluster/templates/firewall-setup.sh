#!/bin/sh

printf "[sshd]\nenabled = true\nbanaction = iptables-multiport" > /etc/fail2ban/jail.local
systemctl enable fail2ban

ufw allow OpenSSH
ufw allow 16443 comment "Kubernetes API endpoint"
ufw allow 80 comment HTTP
ufw allow 443 comment HTTPS
ufw allow to ${node_ip} port 9100 comment "Metrics endpoint"
ufw allow to ${node_ip} port 10250 comment "cadvisor port"
ufw allow to ${node_ip} port 10259 comment "kube-scheduler port"
ufw allow to ${node_ip} port 10257 comment "kube-controller-manager port"
ufw allow to ${node_ip} port 25000 comment "port for joining nodes"
ufw enable