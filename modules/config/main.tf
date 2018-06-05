locals {
  prefix = "prefix"
}

output "tfstate_resource_group_name" {
  value = "${local.prefix}_tf_state"
}

output "tfstate_storage_account_name" {
  value = "${local.prefix}tfstate"
}

output "tfstate_location" {
  value = "East US"
}

output "base_tags" {
  value = {
    OwnerTeam = "TheTeam",
    ProductName = "TheProduct",
    CostCenter = "11111"
  }
}
