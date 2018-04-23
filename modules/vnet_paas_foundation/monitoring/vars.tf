variable "location" {}
variable "resource_prefix" {}
variable "resource_group_name" {}
variable "oms_retention" {}

variable "oms_solutions" {
  default = [
    "AzureWebAppsAnalytics",
    "AzureSQLAnalytics",
    "ChangeTracking",
    "KeyVaultAnalytics",
    "Security",
    "ApplicationInsights",
    "AzureActivity",
    "SecurityCenterFree"
  ]
}

variable "tags" {
  default = {}
}
