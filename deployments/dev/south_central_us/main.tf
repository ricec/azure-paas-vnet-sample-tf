provider "azurerm" { }

module "foundation" {
  source          = "../../../modules/vnet_paas_foundation"
  location        = "South Central US"
  resource_prefix = "prefix-dev"
  base_hostname   = "chrrice.net"

  base_tags = {
    OwnerTeam = "TheTeam",
    ProductName = "TheProduct",
    CostCenter = "11111"
  }

  ops_rg_name        = "prefix-dev-ops"
  networking_rg_name = "prefix-dev-networking"

  key_vault_deployer_object_id = "b60e21b7-f926-456b-a4f6-c8290eafd061"
}
