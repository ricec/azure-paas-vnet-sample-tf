provider "azurerm" {
  version = "1.6.0"
}

module "config" {
  source = "../../modules/config"
}

resource "azurerm_resource_group" "tfstate" {
  name     = "${module.config.tfstate_resource_group_name}"
  location = "${module.config.tfstate_location}"
  tags     = "${module.config.base_tags}"
}

resource "azurerm_storage_account" "tfstate" {
  name                      = "${module.config.tfstate_storage_account_name}"
  location                  = "${azurerm_resource_group.tfstate.location}"
  resource_group_name       = "${azurerm_resource_group.tfstate.name}"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  enable_blob_encryption    = true
  enable_file_encryption    = true
  enable_https_traffic_only = true
  tags                      = "${module.config.base_tags}"
}

resource "azurerm_storage_container" "dev" {
  name                  = "dev"
  resource_group_name   = "${azurerm_resource_group.tfstate.name}"
  storage_account_name  = "${azurerm_storage_account.tfstate.name}"
  container_access_type = "private"
}

data "template_file" "tfinit_sh" {
  template = "${file("${path.module}/templates/tfinit.sh")}"

  vars {
    resource_group_name  = "${azurerm_resource_group.tfstate.name}"
    storage_account_name = "${azurerm_storage_account.tfstate.name}"
  }
}

resource "local_file" "tfinit_sh" {
  content = "${data.template_file.tfinit_sh.rendered}"
  filename = "${path.module}/../../scripts/generated/tfinit.sh"
}
