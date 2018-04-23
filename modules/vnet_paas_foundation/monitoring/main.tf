provider "azurerm" { }

resource "azurerm_resource_group" "monitoring" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}
