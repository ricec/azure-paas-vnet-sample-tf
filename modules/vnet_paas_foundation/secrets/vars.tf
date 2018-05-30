variable "resource_prefix" {}
variable "resource_group_name" {}
variable "key_vault_sku" {}
variable "key_vault_deployer_object_id" {}
variable "ase_cert_config" { type = "map" }
variable "apim_cert_config" { type = "map" }

variable "key_vault_diagnostic_retention" {}
variable "diagnostics_storage_account_id" {}
variable "oms_workspace_id" {}

variable "tags" {
  default = {}
}
