variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources."
  default     = {}
}

variable "recovery_services_vault" {
  type = object({
    name                             = string
    resource_group_name              = string
    location                         = string
    public_network_access_enabled    = optional(bool, false)
    sku                              = optional(string, "Standard")
    storage_mode_type                = optional(string, "ZoneRedundant")
    cross_region_restore_enabled     = optional(bool, false)
    soft_delete_enabled              = optional(bool, true)
    system_assigned_identity_enabled = optional(bool, false)
    immutability                     = optional(string, null),
  })
}

variable "rsv_encryption" {
  type = object({
    cmk_encryption_enabled = optional(string)
    cmk_identity           = optional(string)
    cmk_key_vault_key_id   = optional(string)
  })
  default = {
    cmk_encryption_enabled = false
    cmk_identity           = null
    cmk_key_vault_key_id   = null
  }
}
