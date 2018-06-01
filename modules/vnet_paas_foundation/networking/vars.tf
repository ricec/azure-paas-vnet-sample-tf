variable "region" {
  type = "map"
}
variable "resource_group_name" {}

variable "waf_sku" {}
variable "waf_capacity" {}
variable "dev_gateway_sku" {}
variable "dev_gateway_capacity" {}
variable "apim_scm_hostname" {}
variable "apim_portal_hostname" {}
variable "apim_private_pfx" {}
variable "apim_public_cer" {}
variable "ase_private_pfx" {}
variable "ase_public_cer" {}

# Dev Gateway Ingress
variable "service_1_name" {}

variable "diagnostic_retentions" {
  type = "map"
}
variable "diagnostics_storage_account_id" {}
variable "oms_workspace_id" {}

variable "tags" {
  default = {}
}
