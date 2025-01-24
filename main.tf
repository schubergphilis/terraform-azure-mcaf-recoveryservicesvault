resource "azurerm_recovery_services_vault" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  public_network_access_enabled = var.public_network_access_enabled
  sku                           = var.sku
  storage_mode_type             = var.storage_mode_type
  cross_region_restore_enabled  = var.storage_mode_type == "GeoRedundant" ? true : false
  location                      = var.location
  soft_delete_enabled           = var.soft_delete_enabled
  immutability                  = var.immutability
  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Recovery Service Vault"
    })
  )

  monitoring {
    alerts_for_all_job_failures_enabled            = true
    alerts_for_critical_operation_failures_enabled = true
  }

  dynamic "encryption" {
    for_each = var.cmk_encryption_enabled ? ["this"] : []

    content {
      infrastructure_encryption_enabled = true
      user_assigned_identity_id         = var.system_assigned_identity_enabled == false ? var.cmk_identity : null
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