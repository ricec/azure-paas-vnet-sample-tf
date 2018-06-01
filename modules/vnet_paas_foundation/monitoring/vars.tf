variable "primary_region" {
  type = "map"
}
variable "secondary_region" {
  type = "map"
}
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
