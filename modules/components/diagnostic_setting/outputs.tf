output "command" {
  value = "${data.template_file.create_diagnostic_settings_command.rendered}"
}
