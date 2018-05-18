output "vnet_id" {
  value = "${azurerm_virtual_network.main.id}"
}

output "apim_subnet_name" {
  value = "${azurerm_subnet.apim.name}"
}

output "ase_subnet_name" {
  value = "${azurerm_subnet.ase.name}"
}

output "dev_gateway_subnet_name" {
  value = "${azurerm_subnet.dev_gateway.name}"
}

output "waf_subnet_name" {
  value = "${azurerm_subnet.waf.name}"
}

output "dns_zone_name" {
  value = "${var.dns_zone_name}"
}
