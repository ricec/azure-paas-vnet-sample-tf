resource "azurerm_resource_group" "networking" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
  tags     = "${var.tags}"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.resource_prefix}-vnet"
  location            = "${azurerm_resource_group.networking.location}"
  resource_group_name = "${azurerm_resource_group.networking.name}"
  address_space       = ["172.16.0.0/16"]
  dns_servers         = "${var.dns_servers}"
  tags                = "${var.tags}"
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = "${azurerm_resource_group.networking.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "172.16.1.0/24"
}

data "template_file" "nsg_diagnostic_settings" {
  template = "${file("${path.module}/diagnostics/nsg_logs.json.tpl")}"

  vars {
    retention = "${var.nsg_diagnostics_retention}"
  }
}

data "template_file" "create_nsg_diagnostic_settings" {
  template = "${file("${path.module}/../diagnostics/create_diagnostic_settings.sh.tpl")}"

  vars {
    logs_json = "${data.template_file.nsg_diagnostic_settings.rendered}"
    metrics_json = ""
    storage_account_id = "${var.diagnostics_storage_account_id}"
    oms_workspace_id = "${var.oms_workspace_id}"
  }
}

