variable "primary_prefix" {}
variable "secondary_prefix" {}
variable "primary_location" {}
variable "secondary_location" {}
variable "resource_group_name" {}
variable "oms_retention" {}

variable "diagnostic_profiles" {
  type = "map"
}

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
