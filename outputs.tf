output "allowed_ips" {
  value = local.allowed_list_ips
}

output "final_message" {
  value = "The Cloud Init script can take a few minutes to complete"
}

# Standard Ouput Values

output "state_container_name" {
  value = var.state_container_name
}

output "state_key" {
  value = var.state_key
}
