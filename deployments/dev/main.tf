terraform {
  backend "azurerm" {
    container_name       = "dev"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  version = "1.4.0"
}

module "config" {
  source = "../../modules/config"
}

locals {
  resource_prefix = "prefix-dev"
  base_tags = "${merge(module.config.base_tags, map("Environment", "Dev"))}"
  ops_tags = {
    Tier = "Ops"
  }
  networking_tags = {
    Tier = "Networking"
  }
  shared_app_tags = {
    Tier = "App"
  }
  service_1_tags = {
    Tier = "App"
    Component = "Service1"
  }
}

module "foundation" {
  source             = "../../modules/foundation"

  # Regions
  primary_location   = "East US"
  secondary_location = "West US"

  # Namespacing
  resource_prefix    = "${local.resource_prefix}"
  base_hostname      = "chrrice.net"

  # Resource Groups
  shared_app_rg_name = "${local.resource_prefix}-app-shared"
  ops_rg_name        = "${local.resource_prefix}-ops"
  networking_rg_name = "${local.resource_prefix}-networking"

  # Tagging
  ops_tags          = "${merge(local.base_tags, local.ops_tags)}"
  networking_tags   = "${merge(local.base_tags, local.networking_tags)}"
  shared_app_tags   = "${merge(local.base_tags, local.shared_app_tags)}"

  # Key Vault
  key_vault_deployer_object_id = "b60e21b7-f926-456b-a4f6-c8290eafd061"

  # APIM
  apim_publisher_email    = "chrrice@microsoft.com"
  apim_publisher_name     = "chrrice"
  apim_primary_capacity   = 1
  apim_secondary_capacity = 1
}

module "service_1" {
  source              = "../../modules/services/service_1"
  location            = "${module.foundation.primary_location}"
  resource_prefix     = "${local.resource_prefix}-service-1"
  resource_group_name = "${local.resource_prefix}-service-1"
  ase_id              = "${module.foundation.primary_ase_id}"
  tags                = "${merge(local.base_tags, local.service_1_tags)}"
}
