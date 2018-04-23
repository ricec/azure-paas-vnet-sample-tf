resource "azurerm_storage_account" "diagnostics" {
  name                      = "${replace(var.resource_prefix, "-", "")}logs"
  location                  = "${azurerm_resource_group.monitoring.location}"
  resource_group_name       = "${azurerm_resource_group.monitoring.name}"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_blob_encryption    = true
  enable_file_encryption    = true
  enable_https_traffic_only = true
  tags                      = "${var.tags}"
}
