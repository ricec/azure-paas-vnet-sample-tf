variable "resource_prefix" {}
variable "resource_group_name" {}
variable "dns_servers" {
  type = "list"
}

variable "diagnostic_commands" {
  type = "map"
}
variable "tags" {
  default = {}
}
