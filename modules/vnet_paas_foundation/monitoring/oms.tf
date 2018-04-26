resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = "${var.resource_prefix}-oms"
  location            = "${data.azurerm_resource_group.monitoring.location}"
  resource_group_name = "${data.azurerm_resource_group.monitoring.name}"
  sku                 = "PerNode"
  retention_in_days   = "${var.oms_retention}"
  tags                = "${var.tags}"
}

resource "azurerm_log_analytics_solution" "monitoring" {
  count                 = "${length(var.oms_solutions)}"
  solution_name         = "${element(var.oms_solutions, count.index)}"
  location              = "${data.azurerm_resource_group.monitoring.location}"
  resource_group_name   = "${data.azurerm_resource_group.monitoring.name}"
  workspace_resource_id = "${azurerm_log_analytics_workspace.monitoring.id}"
  workspace_name        = "${azurerm_log_analytics_workspace.monitoring.name}"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/${element(var.oms_solutions, count.index)}"
  }
}

resource "azurerm_template_deployment" "monitoring_oms_datasource" {
  name                = "oms-datasource-activity-log"
  resource_group_name = "${data.azurerm_resource_group.monitoring.name}"
  template_body       = "${file("${path.module}/oms_datasource.json")}"

  parameters {
    "omsWorkspaceName" = "${azurerm_log_analytics_workspace.monitoring.name}"
  }

  deployment_mode = "Incremental"
}
