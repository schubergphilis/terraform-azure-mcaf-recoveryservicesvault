variable "name" {
  description = "The name of the Recovery Services Vault."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
}

variable "location" {
  description = "The Azure region where the vault should be located."
  type        = string
}

variable "public_network_access_enabled" {
  description = "Enable or disable public network access, defaults to false"
  type        = bool
  default     = false
}

variable "sku" {
  description = "The SKU of the Recovery Services Vault, defaults to 'Standard'"
  type        = string
  default     = "Standard"
}

variable "storage_mode_type" {
  description = "The storage mode type for the vault. Possible values are 'GeoRedundant', 'LocallyRedundant', or 'ZoneRedundant', defaults to 'ZoneRedundant'"
  type        = string
  default     = "ZoneRedundant"
}

variable "soft_delete_enabled" {
  description = "Enable or disable soft delete for the vault, defaults to true"
  type        = bool
  default     = true
}

variable "immutability" {
  description = "Enable or disable immutability for backups in the vault."
  type        = bool
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the vault."
  type        = map(string)
  default     = {}
}

variable "cmk_encryption_enabled" {
  description = "Whether to enable CMK encryption for the vault."
  type        = bool
  default     = false
}

variable "system_assigned_identity_enabled" {
  description = "Whether to use a system assigned identity for the vault."
  type        = bool
  default     = false
}

variable "cmk_identity" {
  description = "The user-assigned identity to use for Customer Managed Key encryption."
  type        = string
  default     = null
}

variable "cmk_key_vault_key_id" {
  description = "The Key Vault key ID for CMK encryption."
  type        = string
  default     = null
}

variable "user_assigned_resource_ids" {
  description = "List of user-assigned resource IDs for identity assignment."
  type        = list(string)
  default     = []
}

variable "role_assignments" {
  type = map(object({
    role_definition_name                   = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. If you are using a condition, valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}
