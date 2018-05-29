resource "azurerm_subnet" "ase" {
  name                      = "ase"
  resource_group_name       = "${data.azurerm_resource_group.networking.name}"
  virtual_network_name      = "${azurerm_virtual_network.main.name}"
  address_prefix            = "172.16.4.0/24"
  network_security_group_id = "${azurerm_network_security_group.ase.id}"
}

resource "azurerm_network_security_group" "ase" {
  name                = "${var.resource_prefix}-ase-nsg"
  location            = "${data.azurerm_resource_group.networking.location}"
  resource_group_name = "${data.azurerm_resource_group.networking.name}"
  tags                = "${var.tags}"


  security_rule {
    name = "AllowInboundHttpsFromVnet"
    description = "Allow HTTPs inbound from VNet"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "443"
    source_address_prefix = "VirtualNetwork"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 110
    direction = "Inbound"
  }

  ## ASE Dependencies
  ## https://docs.microsoft.com/en-us/azure/app-service/environment/network-info#ase-dependencies

  # Inbound
  security_rule {
    name = "AllowInboundManagementPorts"
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

  # Outbound
  security_rule {
    name = "AllowOutboundHttps"
    description = "HTTPS outbound required by ASE for access to various Azure APIs"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "443"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 100
    direction = "Outbound"
  }

  security_rule {
    name = "AllowOutboundSQL"
    description = "SQL outbound required for ASE to access Azure SQL Database"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_ranges = ["1433", "11000-11999", "14000-14999"]
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 110
    direction = "Outbound"
  }

  security_rule {
    name = "AllowOutboundDns"
    description = "DNS outbound required for ASE to access Azure DNS"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "53"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 120
    direction = "Outbound"
  }

  security_rule {
    name = "DenyInternetOutbound"
    description = "Deny remaining internet-bound traffic"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "Internet"
    access = "Deny"
    priority = 4000
    direction = "Outbound"
  }

  provisioner "local-exec" {
    command = "${var.diagnostic_commands["nsg"]}"

    environment {
      resource_id = "${azurerm_network_security_group.ase.id}"
    }
  }
}
