# Docker cluster

This module creates a number of Docker nodes on Hetzner.

Each node is prepared for running inside a Docker swarm cluster.
Due to limitations of Terraform, the nodes cannot be joined automatically and this has to be done manually.

The first manager node will be the first manager node of the Docker swarm cluster. You need to SSH onto it
with the configured SSH key and run the following commands to get the join tokens:

```bash
docker swarm join-token manager
docker swarm join-token worker
```

Afterward, you can join the other nodes by using the join commands from the first manager node.

The module does not create DNS records, and you need to create them manually. The output of the module
will contain the IP addresses of all the nodes.

Once you have more than one manager node, a load balancer will be created and configured to direct traffic to the 
manager nodes, using the round-robin algorithm.

The firewall is configured to allow SSH to each node. HTTP and HTTPS are only allowed on the manager nodes.
Furthermore, all necessary ports for Docker swarm are opened on the private node ips.

The manager nodes will also receive a `github` user with the specified SSH key so that GitHub Actions can access the
nodes to deploy applications within the swarm.

To generate the certificates with LetsEncrypt, the certbot is installed on the first manager node.
But you need to manually trigger the certificate request on the first manager node.

First, however, the nginx needs to be deployed to the new swarm. Refer to this repository:
https://github.com/2mnartens/cloud-configuration

```bash
sudo certbot certonly \
  --webroot \
  --webroot-path /var/www/certbot \
  -d yourdomain.com 
```

This will create the certificates and place them in the directory `/etc/letsencrypt/live/yourdomain.com/` on 
the first manager node.

You should add a deploy-hook to the first manager node so that Nginx is restarted when the certificates are updated.
This hook must be placed in the `/etc/letsencrypt/renewal-hooks/deploy` directory on the first manager node.
It can look like this:

```bash
#!/bin/bash
docker service update --force nginx_nginx-proxy
```

This assumes the configuration from the other repository.

## Not yet solved

The certificates are only available on the first manager node. All other Nginx containers will only run with
self-signed certificates. This will lead to problems once the domain is targeting the load balancer and a request
ends up on the "wrong" node.
