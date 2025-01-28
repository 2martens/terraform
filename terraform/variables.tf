variable "inwx_user" {
  type      = string
  sensitive = true
}
variable "inwx_password" {
  type      = string
  sensitive = true
}
variable "admin_name" {
  type      = string
  sensitive = true
}
variable "admin_street" {
  type      = string
  sensitive = true
}
variable "admin_city" {
  type = string
}
variable "admin_postal_code" {
  type = string
}
variable "admin_country_code" {
  type = string
}
variable "admin_phone_number" {
  type      = string
  sensitive = true
}
variable "admin_email" {
  type      = string
  sensitive = true
}


variable "hcloud_token" {
  type      = string
  sensitive = true
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

variable "vault_client_id" {
  description = "Client ID of the service principal used to access Hashicorp Cloud"
  type        = string
  sensitive   = true
}
variable "vault_client_secret" {
  description = "Client Secret of the service principal used to access Hashicorp Cloud"
  type        = string
  sensitive   = true
}

variable "aws_access_key" {
  description = "Access key for AWS"
  type        = string
  sensitive   = true
}
variable "aws_secret_key" {
  description = "Secret key for AWS"
  type        = string
  sensitive   = true
}
variable "argocd_test_keycloak_client_secret" {
  description = "Client secret for ArgoCD test Keycloak client"
  type        = string
  sensitive   = true
}
variable "argocd_monitoring_keycloak_client_secret" {
  description = "Client secret for ArgoCD monitoring Keycloak client"
  type        = string
  sensitive   = true
}

variable "keycloak_client_id" {
  description = "Client ID for Keycloak admin access"
  type        = string
  sensitive   = true
}

variable "keycloak_client_secret" {
  description = "Client Secret for Keycloak admin access"
  type        = string
  sensitive   = true
}

variable "keycloak_url" {
  description = "URL of the Keycloak server"
  type        = string
}
