output "vnet_id" {
  value = "${azurerm_virtual_network.main.id}"
}

output "apim_subnet_name" {
  value = "${azurerm_subnet.apim.name}"
}

output "apim_subnet_id" {
  value = "${azurerm_subnet.apim.id}"
}

output "ase_subnet_name" {
  value = "${azurerm_subnet.ase.name}"
}

output "ase_subnet_id" {
  value = "${azurerm_subnet.ase.id}"
}

output "dev_gateway_subnet_name" {
  value = "${azurerm_subnet.dev_gateway.name}"
}

output "dev_gateway_subnet_id" {
  value = "${azurerm_subnet.dev_gateway.id}"
}

output "waf_subnet_name" {
  value = "${azurerm_subnet.waf.name}"
}

output "waf_subnet_id" {
  value = "${azurerm_subnet.waf.id}"
}
