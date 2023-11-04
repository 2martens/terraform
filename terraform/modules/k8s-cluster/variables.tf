variable "admin_ssh_key" {
  description = "SSH key to provide to each server for the admin"
  type = object({
    id : number,
    name : string
    public_key : string
  })
}

variable "admin_user" {
  description = "Linux username for the admin user on each server"
  type        = string
}

variable "admin_email" {
  description = "Email of the admin. Will be passed to cluster setup helm chart and subsequently be used for registering with Lets Encrypt"
  type        = string
}

variable "terraform_private_ssh_key" {
  description = "Private SSH key to be used by Terraform to connect with remote machines"
  type        = string
  sensitive   = true
}

variable "terraform_public_ssh_key" {
  description = "Public SSH key for the private key used by Terraform to connect with remote machines"
  type        = string
}

variable "locations" {
  description = "Locations in which the resources should be created. Singular resources will always be created in the first. Must be all in the same network zone."
  type = list(object({
    id : number,
    name : string,
    datacenter_name : string,
    network_zone : string
  }))
}

variable "domain" {
  description = "The registered domain that should be used as the base for all subdomains."
  type        = string
}

variable "network_id" {
  description = "ID of the private network used to connect servers with each other and the loadbalancer"
  type        = number
}

variable "server_subnet_id" {
  description = "ID of the subnet of the private network that is supposed to house the servers and loadbalancer"
  type        = string
}

variable "private_node_ips" {
  description = "One IP in the private network subnet for each manager node created."
  type        = list(string)
}

variable "private_worker_node_ips" {
  description = "One IP in the private network subnet for each worker node created."
  type        = list(string)
  default     = []
}

variable "basic_firewall_id" {
  description = "ID of the basic firewall for each server"
  type        = number
}

variable "k8s_firewall_id" {
  description = "ID of the K8s specific firewall"
  type        = number
}

variable "cluster_name" {
  description = "The name of the cluster. For example test, qs, prod. Will be used for names and subdomains and must be unique within the Hetzner project (identified by API token)."
  type        = string
  default     = "test"
}

variable "argocd_environment" {
  description = "The Argo CD environment to use. Argo CD will install the applications of that environment to the cluster."
  type        = string
  default     = "test"
}

variable "argocd_chart_version" {
  description = "The Argo CD chart version to use."
  type        = string
  default     = "0.1.1"
}

variable "number_nodes" {
  description = "Number of manager nodes in the cluster."
  type        = number
  default     = 1
}

variable "number_worker_nodes" {
  description = "Number of worker nodes in the cluster."
  type        = number
  default     = 0
}

variable "image_name" {
  description = "Name of the image to use for the servers."
  type        = string
  default     = "ubuntu-22.04"
}

variable "server_type" {
  description = "Hetzner server type like cax21 (default)"
  type        = string
  default     = "cax21"
}

variable "create_loadbalancer" {
  description = "Specifies if a loadbalancer is created as gateway in front of the k8s servers. If false, the first server acts as gateway."
  type        = bool
  default     = false
}

variable "loadbalancer_type" {
  description = "Type of the loadbalancer used. By default lb11 is used."
  type        = string
  default     = "lb11"
}

variable "loadbalancer_ip" {
  description = "The private IP of the loadbalancer. Variable contains valid IP but must be overriden if a loadbalancer is used."
  type        = string
  default     = "0.0.0.0"
}

variable "cluster_token_ttl_seconds" {
  description = "Number of seconds the join token is valid"
  type        = number
  default     = 3600
}

variable "microk8s_channel" {
  description = "The snap channel used for the microk8s installation"
  type        = string
  default     = "1.28/stable"
}

variable "vault_service_principal" {
  description = "Service Principal to access to Hashicorp Vault Secrets"
  type = object({
    client_id : string
    client_secret : string
  })
  sensitive = true
}