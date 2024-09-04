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
