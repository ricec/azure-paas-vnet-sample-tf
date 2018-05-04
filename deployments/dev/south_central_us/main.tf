provider "azurerm" { }

locals {
  location        = "East US"
  resource_prefix = "prefix-dev"

  base_tags = {
    OwnerTeam = "TheTeam",
    ProductName = "TheProduct",
    CostCenter = "11111"
  }
}

module "foundation" {
  source          = "../../../modules/vnet_paas_foundation"
  location        = "${local.location}"
  resource_prefix = "${local.resource_prefix}"
  base_hostname   = "chrrice.net"
  base_tags       = "${local.base_tags}"

  shared_app_rg_name = "${local.resource_prefix}-app-shared"
  ops_rg_name        = "${local.resource_prefix}-ops"
  networking_rg_name = "${local.resource_prefix}-networking"

  key_vault_deployer_object_id = "b60e21b7-f926-456b-a4f6-c8290eafd061"

  apim_publisher_email = "chrrice@microsoft.com"
  apim_publisher_name  = "chrrice"
  apim_sku             = "Developer"
  apim_sku_count       = 1
}
