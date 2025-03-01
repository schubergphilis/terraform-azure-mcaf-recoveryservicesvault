resource "azurerm_recovery_services_vault" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  public_network_access_enabled = var.public_network_access_enabled
  sku                           = var.sku
  storage_mode_type             = var.storage_mode_type
  cross_region_restore_enabled  = var.cross_region_restore_enabled
  location                      = var.location
  soft_delete_enabled           = var.soft_delete_enabled
  immutability                  = var.immutability
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
    for_each = var.cmk_key_vault_key_id != null ? ["this"] : []

    content {
      infrastructure_encryption_enabled = true
      user_assigned_identity_id         = var.system_assigned_identity_enabled == false ? var.cmk_identity_id : null
      use_system_assigned_identity      = var.system_assigned_identity_enabled
      key_id                            = var.cmk_key_vault_key_id
    }
  }

  dynamic "identity" {
    for_each = coalesce(local.identity_system_assigned_user_assigned, local.identity_system_assigned, local.identity_user_assigned, {})

    content {
      type         = identity.value.type
      identity_ids = identity.value.user_assigned_resource_ids
    }
  }
}

resource "azurerm_role_assignment" "this" {
  count                = (var.system_assigned_identity_enabled == true && var.cmk_key_vault_key_id != null) ? 1 : 0
  principal_id         = azurerm_recovery_services_vault.this.identity[0].principal_id
  scope                = var.cmk_key_vault_key_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
}
