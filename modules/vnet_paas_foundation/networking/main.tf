provider "azurerm" {}

resource "azurerm_virtual_network" "main" {
  name                = "${var.resource_prefix}-vnet"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  address_space       = ["172.16.0.0/16"]
  tags                = "${var.tags}"
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = "${var.resource_group_name}"
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
      resource_group_name = "${var.resource_group_name}"
      vnet_id             = "${azurerm_virtual_network.main.id}"
    }
  }
}
