provider "azurerm" { }

module "foundation" {
  source          = "../../../modules/vnet_paas_foundation"
  location        = "South Central US"
  resource_prefix = "prefix-dev"

  base_tags = {
    OwnerTeam = "TheTeam",
    ProductName = "TheProduct",
    CostCenter = "11111"
  }

  monitoring_rg_name = "prefix-dev-ops"
}
