resource "azurerm_subnet" "apim" {
  name                      = "apim"
  resource_group_name       = "${data.azurerm_resource_group.networking.name}"
  virtual_network_name      = "${azurerm_virtual_network.main.name}"
  address_prefix            = "172.16.3.0/24"
  network_security_group_id = "${azurerm_network_security_group.apim.id}"
}

resource "azurerm_network_security_group" "apim" {
  name                = "${var.resource_prefix}-apim-nsg"
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
    priority = 100
    direction = "Inbound"
  }

  ## APIM Dependencies
  ## https://docs.microsoft.com/en-us/azure/api-management/api-management-using-with-vnet#a-namenetwork-configuration-issues-acommon-network-configuration-issues

  # Inbound
  security_rule {
    name = "AllowInboundManagementPort"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "3443"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 110
    direction = "Inbound"
  }

  security_rule {
    name = "AllowInboundRedisFromVnet"
    description = "Required for Redis Cache access between APIM RoleInstances"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "6381-6383"
    source_address_prefix = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
    access = "Allow"
    priority = 120
    direction = "Inbound"
  }

  # Outbound
  security_rule {
    name = "AllowOutboundHttps"
    description = "HTTPS outbound required by APIM for access to various Azure APIs"
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
    description = "SQL outbound required for APIM to access Azure SQL Database"
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
    name = "AllowOutboundEventHub"
    description = "EventHub outbound required for APIM logging"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "5672"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 120
    direction = "Outbound"
  }

  security_rule {
    name = "AllowOutboundAzureFiles"
    description = "Azure Files outbound required for APIM Git file share access"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "445"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 130
    direction = "Outbound"
  }

  security_rule {
    name = "AllowOutboundResourceHealth"
    description = "Required for APIM to publish heath status"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "1886"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 140
    direction = "Outbound"
  }

  security_rule {
    name = "AllowOutboundSMTP"
    description = "SMTP outbound reqired for APIM to send emails"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "25028"
    source_address_prefix = "*"
    destination_address_prefix = "*"
    access = "Allow"
    priority = 150
    direction = "Outbound"
  }

  security_rule {
    name = "AllowOutboundRedisToVnet"
    description = "Required for Redis Cache access between APIM RoleInstances"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "6381-6383"
    source_address_prefix = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
    access = "Allow"
    priority = 160
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
      resource_id = "${azurerm_network_security_group.apim.id}"
    }
  }
}
