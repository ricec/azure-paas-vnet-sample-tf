resource "azurerm_application_insights" "monitoring" {
  name                = "${var.resource_prefix}-insights"
  location            = "${data.azurerm_resource_group.monitoring.location}"
  resource_group_name = "${data.azurerm_resource_group.monitoring.name}"
  application_type    = "Web"
  tags                = "${var.tags}"
}
