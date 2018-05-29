variable "resource_prefix" {}
variable "resource_group_name" {}
variable "location" {}
variable "dns_zone_name" {}
variable "diagnostic_commands" {
  type = "map"
}
variable "tags" {
  default = {}
}
