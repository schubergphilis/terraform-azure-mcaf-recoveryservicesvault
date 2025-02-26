locals {
  identity_system_assigned_user_assigned = (var.system_assigned_identity_enabled && (length(var.var.user_assigned_identities) > 0 || var.cmk_identity_id != null)) ? {
    this = {
      type                       = "SystemAssigned, UserAssigned"
      user_assigned_resource_ids = setunion(var.var.user_assigned_identities, try([var.cmk_identity_id], []))
    }
  } : null
  identity_system_assigned = var.system_assigned_identity_enabled ? {
    this = {
      type                       = "SystemAssigned"
      user_assigned_resource_ids = null
    }
  } : null
  identity_user_assigned = (length(var.var.user_assigned_identities) > 0 || var.cmk_identity_id != null) ? {
    this = {
      type                       = "UserAssigned"
      user_assigned_resource_ids = setunion(var.var.user_assigned_identities, try([var.cmk_identity_id], []))
    }
  } : null
}