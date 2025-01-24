locals {
  identity_system_assigned_user_assigned = (var.system_assigned_identity_enabled && (length(var.user_assigned_resource_ids) > 0 || var.cmk_encryption_enabled != null)) ? {
    this = {
      type                       = "SystemAssigned, UserAssigned"
      user_assigned_resource_ids = setunion(var.user_assigned_resource_ids, try([data.azurerm_user_assigned_identity.this[0].id], []))
    }
  } : null
  identity_system_assigned = var.system_assigned_identity_enabled ? {
    this = {
      type                       = "SystemAssigned"
      user_assigned_resource_ids = null
    }
  } : null
  identity_user_assigned = (length(var.user_assigned_resource_ids) > 0 || var.cmk_encryption_enabled != null) ? {
    this = {
      type                       = "UserAssigned"
      user_assigned_resource_ids = setunion(var.user_assigned_resource_ids, try([data.azurerm_user_assigned_identity.this[0].id], []))
    }
  } : null
}
