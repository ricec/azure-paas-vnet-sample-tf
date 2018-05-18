provider "azurerm" {}

data "azurerm_resource_group" "networking" {
  name     = "${var.resource_group_name}"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.resource_prefix}-vnet"
  location            = "${data.azurerm_resource_group.networking.location}"
  resource_group_name = "${data.azurerm_resource_group.networking.name}"
  address_space       = ["172.16.0.0/16"]
  dns_servers         = "${var.dns_servers}"
  tags                = "${var.tags}"
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = "${data.azurerm_resource_group.networking.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "172.16.1.0/24"
}

resource "null_resource" "dns" {
  triggers {
    vnet_id = "${azurerm_virtual_network.main.id}"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create_dns_private_zone.sh"

    environment {
      zone_name           = "${var.dns_zone_name}"
      resource_group_name = "${data.azurerm_resource_group.networking.name}"
      vnet_id             = "${azurerm_virtual_network.main.id}"
    }
  }
}
