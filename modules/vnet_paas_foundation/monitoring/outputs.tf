output "oms_workspace_id" {
  value = "${azurerm_log_analytics_workspace.monitoring.id}"
}

output "primary_diagnostics_storage_account_id" {
  value = "${azurerm_storage_account.primary.id}"
}

output "secondary_diagnostics_storage_account_id" {
  value = "${azurerm_storage_account.primary.id}"
}

output "diagnostic_commands" {
  value = "${zipmap(keys(var.diagnostic_profiles), data.template_file.create_diagnostic_settings_command.*.rendered)}"
}
