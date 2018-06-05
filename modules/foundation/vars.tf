# Regions
# NOTE: This location must be the friendly name (e.g. South Central US) as
# ASEs don't play nicely with normalized location names.
variable "primary_location" {}
variable "secondary_location" {}

# Namespacing
variable "resource_prefix" {}
variable "base_hostname" {}

# Resource Groups
variable "ops_rg_name" {}
variable "networking_rg_name" {}
variable "shared_app_rg_name" {}

# Tagging
variable "ops_tags" {
  type = "map"
}
variable "networking_tags" {
  type = "map"
}
variable "shared_app_tags" {
  type = "map"
}

# Key Vault
variable "key_vault_sku" {
  default = "standard"
}
variable "key_vault_deployer_object_id" {}

# APIM
variable "apim_publisher_email" {}
variable "apim_publisher_name" {}
variable "apim_primary_capacity" {}
variable "apim_secondary_capacity" {}

# Monitoring
variable "oms_retention" {
  default = 30
}

variable "diagnostic_retentions" {
  default = {
    apim        = 365
    app_gateway = 365
    key_vault   = 365
    nsg         = 365
  }
}

# Ingress
variable "waf_sku" {
  default = "WAF_Medium"
}

variable "waf_capacity" {
  default = 1
}

variable "dev_gateway_sku" {
  default = "Standard_Small"
}

variable "dev_gateway_capacity" {
  default = 1
}

variable "service_1_name" {
  default = "prefix-dev-service-1-web-app"
}
