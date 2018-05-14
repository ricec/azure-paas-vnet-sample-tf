output "ase_id" {
  value = "${azurerm_template_deployment.ase.outputs["aseId"]}"
}
