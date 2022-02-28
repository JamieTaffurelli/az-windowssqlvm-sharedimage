output "recovery_services_vault_id" {
  value       = azurerm_recovery_services_vault.backup.id
  description = "Resource ID of the Recovery Services Vault"
}

output "vm_backup_policy_id" {
  value       = azurerm_backup_policy_vm.backup.id
  description = "Resource ID of the VM backup policy"
}
