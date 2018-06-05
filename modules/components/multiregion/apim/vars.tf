variable "primary_region" {
  type = "map"
}
variable "secondary_region" {
  type = "map"
}
variable "resource_group_name" {}
variable "publisher_email" {}
variable "publisher_name" {}
variable "sku" {}
variable "primary_capacity" {}
variable "secondary_capacity" {}
variable "api_hostname" {}
variable "portal_hostname" {}
variable "scm_hostname" {}
variable "ssl_cert" {}
variable "primary_subnet_id" {}
variable "secondary_subnet_id" {}
variable "dns_zone_name" {}
variable "dns_zone_resource_group_name" {}

variable "diagnostic_retention" {}
variable "diagnostics_storage_account_id" {}
variable "oms_workspace_id" {}

variable "tags" {
  default = {}
}
