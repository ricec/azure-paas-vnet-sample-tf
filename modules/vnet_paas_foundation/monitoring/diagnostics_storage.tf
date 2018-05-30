resource "azurerm_storage_account" "primary" {
  name                      = "${replace(var.primary_prefix, "-", "")}logs"
  location                  = "${var.primary_location}"
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
  name                      = "${replace(var.secondary_prefix, "-", "")}logs"
  location                  = "${var.secondary_location}"
  resource_group_name       = "${var.resource_group_name}"
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_blob_encryption    = true
  enable_file_encryption    = true
  enable_https_traffic_only = true
  tags                      = "${var.tags}"
}
