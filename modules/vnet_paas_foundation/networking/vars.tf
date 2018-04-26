variable "location" {}
variable "resource_prefix" {}
variable "resource_group_name" {}
variable "dns_servers" {
  type = "list"
}

variable "nsg_diagnostics_retention" {}
variable "waf_diagnostics_retention" {}
variable "dev_gateway_diagnostics_retention" {}

variable "diagnostics_storage_account_id" {}
variable "oms_workspace_id" {}
variable "tags" {
  default = {}
}
