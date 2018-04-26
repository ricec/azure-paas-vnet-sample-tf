output "oms_workspace_id" {
  value = "${azurerm_log_analytics_workspace.monitoring.id}"
}

output "diagnostics_storage_account_id" {
  value = "${azurerm_storage_account.diagnostics.id}"
}
