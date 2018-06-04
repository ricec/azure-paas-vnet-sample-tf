output "primary_location" {
  value = "${var.primary_location}"
}

output "secondary_location" {
  value = "${var.secondary_location}"
}

output "ase_id" {
  value = "${module.ase.ase_id}"
}

output "secondary_ase_id" {
  value = "${module.secondary_ase.ase_id}"
}
