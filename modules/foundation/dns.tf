module "dns" {
  source              = "../components/dns_private_zone"
  zone_name           = "${var.base_hostname}"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  resolution_vnet_ids = "${list(module.networking.vnet_id, module.secondary_network.vnet_id)}"
}
