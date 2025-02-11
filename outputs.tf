output "recovery_services_vault_id" {
  description = "The ID of the Recovery Service Vault"
  value       = azurerm_recovery_services_vault.this.id
}