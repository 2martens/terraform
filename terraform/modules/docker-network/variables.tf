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

variable "terraform_private_ssh_key" {
  description = "Private SSH key to be used by Terraform to connect with remote machines"
  type        = string
  sensitive   = true
}

variable "terraform_public_ssh_key" {
  description = "Public SSH key for the private key used by Terraform to connect with remote machines"
  type        = string
}

variable "github_public_ssh_key" {
  description = "Public SSH key for the private key used by GitHub Actions to connect with remote machines"
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
  description = "ID of the private network used to connect servers with each other"
  type        = number
}

variable "server_subnet_id" {
  description = "ID of the subnet of the private network that is supposed to house the servers"
  type        = string
}

variable "private_node_ips" {
  description = "One IP in the private network subnet for each Docker Swarm node created."
  type = list(string)
}

variable "basic_firewall_id" {
  description = "ID of the basic firewall for each server"
  type        = number
}

variable "stage_name" {
  description = "The name of the stage. For example test, qs, prod. Will be used for names and subdomains and must be unique within the Hetzner project (identified by API token)."
  type        = string
  default     = "test"
}

variable "number_nodes" {
  description = "Number of nodes in the docker swarm."
  type        = number
  default     = 0
}

variable "image_name" {
  description = "Name of the image to use for the servers."
  type        = string
  default     = "ubuntu-24.04"
}

variable "server_type" {
  description = "Hetzner server type like cax21 (default)"
  type        = string
  default     = "cax21"
}

