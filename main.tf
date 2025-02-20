resource "azurerm_recovery_services_vault" "this" {
  name                          = var.recovery_services_vault.name
  resource_group_name           = var.resource_group_name
  public_network_access_enabled = var.recovery_services_vault.public_network_access_enabled
  sku                           = var.recovery_services_vault.sku
  storage_mode_type             = var.recovery_services_vault.storage_mode_type
  cross_region_restore_enabled  = var.recovery_services_vault.cross_region_restore_enabled
  location                      = var.recovery_services_vault.location
  soft_delete_enabled           = var.recovery_services_vault.soft_delete_enabled
  immutability                  = var.recovery_services_vault.immutability
  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Recovery Services Vault"
    })
  )

  monitoring {
    alerts_for_all_job_failures_enabled            = true
    alerts_for_critical_operation_failures_enabled = true
  }

  dynamic "encryption" {
    for_each = var.rsv_encryption.cmk_encryption_enabled == true ? [1] : []

    content {
      infrastructure_encryption_enabled = true
      user_assigned_identity_id         = var.rsv_encryption.system_assigned_identity_enabled == true ? var.rsv_encryption.cmk_identity : null
      use_system_assigned_identity      = var.rsv_encryption.system_assigned_identity_enabled
      key_id                            = var.rsv_encryption.cmk_key_vault_key_id
    }
  }

  dynamic "identity" {
    for_each = var.recovery_services_vault.system_assigned_identity_enabled == true ? [1] : []

    content {
      type = "SystemAssigned"
    }
  }
}