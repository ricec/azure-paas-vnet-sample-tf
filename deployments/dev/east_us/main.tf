provider "azurerm" {
  version = "1.4.0"
}

locals {
  resource_prefix = "prefix-dev"

  base_tags = {
    OwnerTeam = "TheTeam",
    ProductName = "TheProduct",
    CostCenter = "11111"
  }
  service_1_tags = {
    Tier = "App"
    Component = "Service1"
  }
}

module "foundation" {
  source             = "../../../modules/foundation"

  # NOTE: This location must be the friendly name (e.g. South Central US) as
  # ASEs don't play nicely with normalized location names.
  primary_location   = "East US"
  secondary_location = "West US"
  resource_prefix    = "${local.resource_prefix}"
  base_hostname      = "chrrice.net"
  base_tags          = "${local.base_tags}"

  shared_app_rg_name = "${local.resource_prefix}-app-shared"
  ops_rg_name        = "${local.resource_prefix}-ops"
  networking_rg_name = "${local.resource_prefix}-networking"

  key_vault_deployer_object_id = "b60e21b7-f926-456b-a4f6-c8290eafd061"

  apim_publisher_email = "chrrice@microsoft.com"
  apim_publisher_name  = "chrrice"
  apim_sku_count       = 1
}

module "service_1" {
  source              = "../../../modules/service_1"
  location            = "${module.foundation.primary_location}"
  resource_prefix     = "${local.resource_prefix}-service-1"
  resource_group_name = "${local.resource_prefix}-service-1"
  ase_id              = "${module.foundation.ase_id}"
  tags                = "${merge(local.base_tags, local.service_1_tags)}"
}
