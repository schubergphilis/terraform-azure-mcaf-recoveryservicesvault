output "recovery_service_vault_id" {
  description = "The ID of the Recovery Service Vault"
  value = azurerm_recovery_services_vault.this.id
}