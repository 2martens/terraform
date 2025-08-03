# Terraform

This repo contains the representation of all infrastructure on Hetzner.


## Modules
It contains modules for a domain (not really working), a k8s cluster with MicroK8s on Hetzner, and a Docker swarm cluster. 

The k8s-cluster module supports single and multi-node MicroK8s clusters. So far, a single node cluster has been successfully created.

More information about the Docker cluster module can be found [here](docs/docker-cluster.md).

## Technical notes

The element function is used not by accident. It allows iterating over a list multiple times with an index higher than 
the length of the list. IDEs may suggest using index access instead, but this will not work.
