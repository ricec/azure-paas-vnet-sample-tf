resource "azurerm_subnet" "waf" {
  name                 = "waf"
  resource_group_name  = "${azurerm_resource_group.networking.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "172.16.2.0/24"
}

resource "azurerm_network_security_group" "waf" {
  name                = "${var.resource_prefix}-waf-nsg"
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
    command = "${data.template_file.create_nsg_diagnostic_settings.rendered}"

    environment {
      resource_id = "${azurerm_network_security_group.waf.id}"
    }
  }
}
