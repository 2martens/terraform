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