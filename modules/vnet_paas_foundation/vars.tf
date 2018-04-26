variable "location" {}
variable "resource_prefix" {}
variable "base_hostname" {}
variable "base_tags" {
  default = {}
}

variable "ops_rg_name" {}
variable "secrets_tags" {
  default = {
    Tier = "Ops"
  }
}
variable "key_vault_sku" {
  default = "standard"
}
variable "key_vault_diagnostics_retention" {
  default = "365"
}
variable "key_vault_deployer_object_id" {}

# Shared App Infrastructure

variable "shared_app_rg_name" {}
variable "shared_app_tags" {
  default = {
    Tier = "App"
  }
}

# Monitoring

variable "monitoring_tags" {
  default = {
    Tier = "Ops"
  }
}

variable "oms_retention" {
  default = 30
}


# Networking

variable "networking_rg_name" {}
variable "networking_tags" {
  default = {
    Tier = "Networking"
  }
}

variable "dns_servers" {
  default = []
}

variable "nsg_diagnostics_retention" {
  default = 365
}

variable "waf_diagnostics_retention" {
  default = 365
}

variable "dev_gateway_diagnostics_retention" {
  default = 365
}
