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
  description = "set of user-assigned resource IDs for identity assignment."
  type        = set(string)
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
A map of role assignments to create on the Recovery Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

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

variable "diagnostic_settings" {
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
  A map of diagnostic settings to create on the Recovery Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

  - `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
  - `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
  - `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
  - `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
  - `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
  - `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
  - `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
  - `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
  - `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
  - `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.
  DESCRIPTION
  nullable    = false

  validation {
    condition     = alltrue([for _, v in var.diagnostic_settings : contains(["Dedicated", "AzureDiagnostics"], v.log_analytics_destination_type)])
    error_message = "Log analytics destination type must be one of: 'Dedicated', 'AzureDiagnostics'."
  }
  validation {
    condition = alltrue(
      [
        for _, v in var.diagnostic_settings :
        v.workspace_resource_id != null || v.storage_account_resource_id != null || v.event_hub_authorization_rule_resource_id != null || v.marketplace_partner_resource_id != null
      ]
    )
    error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
  }
}
