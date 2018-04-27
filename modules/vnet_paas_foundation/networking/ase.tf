resource "azurerm_subnet" "ase" {
  name                 = "ase"
  resource_group_name  = "${azurerm_resource_group.networking.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "172.16.4.0/24"
}

resource "azurerm_network_security_group" "ase" {
  name                = "${var.resource_prefix}-ase-nsg"
  location            = "${azurerm_resource_group.networking.location}"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  tags                = "${var.tags}"

  security_rule {
    name = "AllowHttps"
    description = "This is the Https inbound rule"
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
    name = "AllowAzureHealthProbes"
    description = "Required port used by Azure infrastructure for managing and maintaining App Service Environments"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "454-455"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 120
    direction = "Inbound"
  }

  security_rule {
    name = "AllowOutboundSQL_1433"
    description = "Allowing ASE to communicate to SQL DB"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "1433"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 100
    direction = "Outbound"
  }

  security_rule {
    name = "AllowOutboundSQL_11000-11999"
    description = "Allowing ASE to communicate to SQL DB"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "11000-11999"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 110
    direction = "Outbound"
  }

  security_rule {
    name = "AllowOutboundSQL_14000-14999"
    description = "Allowing ASE to communicate to SQL DB"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "14000-14999"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 120
    direction = "Outbound"
  }

  security_rule {
    name = "AllowOutboundtoAzureDomain"
    description = "Allowing Outbound access on port 53 is required for communication with Azure DNS servers"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "53"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 130
    direction = "Outbound"
  }

  provisioner "local-exec" {
    command = "${var.diagnostic_commands["nsg"]}"

    environment {
      resource_id = "${azurerm_network_security_group.ase.id}"
    }
  }
}
