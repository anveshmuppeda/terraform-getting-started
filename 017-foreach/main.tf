resource "local_file" "env_specific_file" {
  for_each = var.environmentVariables
  filename = "${each.value.Environment}.env"
  content = <<EOF
# Environment: ${each.value.Environment}
Application: ${each.value.Application}
Version: ${each.value.Version}
Description: ${each.value.Description}
Owner: ${each.value.Owner}
EOF
}