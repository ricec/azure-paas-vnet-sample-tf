resource "azurerm_subnet" "apim" {
  name                 = "apim"
  resource_group_name  = "${data.azurerm_resource_group.networking.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "172.16.3.0/24"
}

resource "azurerm_network_security_group" "apim" {
  name                = "${var.resource_prefix}-apim-nsg"
  location            = "${data.azurerm_resource_group.networking.location}"
  resource_group_name = "${data.azurerm_resource_group.networking.name}"
  tags                = "${var.tags}"

  security_rule {
    name = "AllowHttps"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "443"
    source_address_prefix = "VirtualNetwork"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 110
    direction = "Inbound"
  }

  security_rule {
    name = "AllowManagementEndpoint"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "3443"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 130
    direction = "Inbound"
  }

  security_rule {
    name = "AllowAzureSQL"
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
    name = "AllowEventHubLogging"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "5672"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 110
    direction = "Outbound"
  }

  security_rule {
    name = "AllowGitFileShare"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "445"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 120
    direction = "Outbound"
  }

  security_rule {
    name = "AllowResourceHealth"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "1886"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 130
    direction = "Outbound"
  }

  security_rule {
    name = "AllowSMTP"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "25028"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 140
    direction = "Outbound"
  }

  security_rule {
    name = "AllowRedisCache"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "6381-6383"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 150
    direction = "Outbound"
  }

  provisioner "local-exec" {
    command = "${var.diagnostic_commands["nsg"]}"

    environment {
      resource_id = "${azurerm_network_security_group.apim.id}"
    }
  }
}
