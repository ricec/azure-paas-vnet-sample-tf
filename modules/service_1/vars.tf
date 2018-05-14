variable "location" {}
variable "resource_prefix" {}
variable "resource_group_name" {}
variable "ase_id" {}

variable "app_service_plan_sku_name" {
  default = "I1"
}

variable "tags" {
  default = {}
}
