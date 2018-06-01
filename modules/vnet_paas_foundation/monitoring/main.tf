provider "azurerm" {}

resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = "${var.primary_region["prefix"]}-oms"
  location            = "${var.primary_region["location"]}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "PerNode"
  retention_in_days   = "${var.oms_retention}"
  tags                = "${var.tags}"
}

resource "azurerm_log_analytics_solution" "monitoring" {
  count                 = "${length(var.oms_solutions)}"
  solution_name         = "${element(var.oms_solutions, count.index)}"
  location              = "${var.primary_region["location"]}"
  resource_group_name   = "${var.resource_group_name}"
  workspace_resource_id = "${azurerm_log_analytics_workspace.monitoring.id}"
  workspace_name        = "${azurerm_log_analytics_workspace.monitoring.name}"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/${element(var.oms_solutions, count.index)}"
  }
}

resource "azurerm_template_deployment" "monitoring_oms_datasource" {
  name                = "oms-datasource-activity-log"
  resource_group_name = "${var.resource_group_name}"
  template_body       = "${file("${path.module}/oms_datasource.json")}"

  parameters {
    "omsWorkspaceName" = "${azurerm_log_analytics_workspace.monitoring.name}"
  }

  deployment_mode = "Incremental"
}

resource "azurerm_storage_account" "primary" {
  name                      = "${var.primary_region["alphanum_prefix"]}logs"
  location                  = "${var.primary_region["location"]}"
  resource_group_name       = "${var.resource_group_name}"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_blob_encryption    = true
  enable_file_encryption    = true
  enable_https_traffic_only = true
  tags                      = "${var.tags}"
}

resource "azurerm_storage_account" "secondary" {
  name                      = "${var.secondary_region["alphanum_prefix"]}logs"
  location                  = "${var.secondary_region["location"]}"
  resource_group_name       = "${var.resource_group_name}"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_blob_encryption    = true
  enable_file_encryption    = true
  enable_https_traffic_only = true
  tags                      = "${var.tags}"
}
