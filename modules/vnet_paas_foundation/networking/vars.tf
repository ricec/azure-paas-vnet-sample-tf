variable "resource_prefix" {}
variable "resource_group_name" {}
variable "location" {}
variable "dns_zone_name" {}

variable "nsg_diagnostic_retention" {}
variable "diagnostics_storage_account_id" {}
variable "oms_workspace_id" {}

variable "tags" {
  default = {}
}
