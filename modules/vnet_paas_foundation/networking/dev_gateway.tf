resource "azurerm_subnet" "dev_gateway" {
  name                 = "dev-gateway"
  resource_group_name  = "${azurerm_resource_group.networking.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "172.16.5.0/24"
}

resource "azurerm_network_security_group" "dev_gateway" {
  name                = "${var.resource_prefix}-dev-gateway-nsg"
  location            = "${azurerm_resource_group.networking.location}"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  tags                = "${var.tags}"

  security_rule {
    name = "AllowHttps"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "443"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 110
    direction = "Inbound"
  }

  security_rule {
    name = "AllowGatewayBackendHealth"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "65503-65534"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 120
    direction = "Inbound"
  }

  provisioner "local-exec" {
    command = "${var.diagnostic_commands["nsg"]}"

    environment {
      resource_id = "${azurerm_network_security_group.dev_gateway.id}"
    }
  }
}
