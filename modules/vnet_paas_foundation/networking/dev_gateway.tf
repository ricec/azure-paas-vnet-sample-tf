resource "azurerm_subnet" "dev_gateway" {
  name                      = "dev-gateway"
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${azurerm_virtual_network.main.name}"
  address_prefix            = "172.16.5.0/24"
  network_security_group_id = "${azurerm_network_security_group.dev_gateway.id}"
}

resource "azurerm_network_security_group" "dev_gateway" {
  name                = "${var.resource_prefix}-dev-gateway-nsg"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  tags                = "${var.tags}"

  security_rule {
    name = "AllowInboundHttps"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "443"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 100
    direction = "Inbound"
  }

  ## Application Gateway Dependencies
  ## https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-faq
  security_rule {
    name = "AllowInboundHealth"
    description = "Required ports for monitoring Application Gateway backend health"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "65503-65534"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 110
    direction = "Inbound"
  }

  provisioner "local-exec" {
    command = "${module.nsg_diagnostics.command}"

    environment {
      resource_id = "${azurerm_network_security_group.dev_gateway.id}"
    }
  }
}
