output "public_ip_id" {
  value       = azurerm_public_ip.vm.id
  description = "Resource ID of the public IP"
}

output "public_ip_address" {
  value       = azurerm_public_ip.vm.ip_address
  description = "Public IP address"
}

output "network_interface_id" {
  value       = azurerm_network_interface.vm.id
  description = "Resource ID of the Netowrk Interface"
}

output "network_interface_ip" {
  value       = azurerm_network_interface.vm.private_ip_address
  description = "IP address of the Network Interface"
}

output "virtual_machine_id" {
  value       = azurerm_windows_virtual_machine.vm.id
  description = "Resource ID of the Virtual Machine"
}

output "virtual_machine_identity_object_id" {
  value       = azurerm_windows_virtual_machine.vm.identity[0].principal_id
  description = "Object ID of assigned identity"
}

output "virtual_machine_private_ip_address" {
  value       = azurerm_windows_virtual_machine.vm.private_ip_address
  description = "Private IP address of the Virtual Machine"
}

output "virtual_machine_public_ip_address" {
  value       = azurerm_windows_virtual_machine.vm.public_ip_address
  description = "Public IP address of the Virtual Machine"
}
