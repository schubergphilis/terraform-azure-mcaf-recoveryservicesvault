resource "azurerm_backup_policy_vm" "this" {
    name = var.vm_backup_policy.name
    resource_group_name = var.resource_group_name
    recovery_vault_name = var.recovery_services_vault.name
    policy_type = var.vm_backup_policy.policy_type
    instant_restore_retention_days = var.vm_backup_policy.instant_restore_retention_days
    timezone = var.vm_backup_policy.timezone

  backup {
    frequency     = var.vm_backup_policy.frequency != null ? regex("^Hourly|Daily|Weekly$", var.vm_backup_policy.frequency) : null
    time          = var.vm_backup_policy["backup"].time != null ? var.vm_backup_policy["backup"].time : null
    hour_duration = var.vm_backup_policy.frequency == "Hourly" && var.vm_backup_policy["backup"].hour_duration != null ? regex("/0[1-2]|1[0-2]-0[4-9]|1[1-9]|2[0-4]|3[0-1]|[1-2[4-8]/gm", var.vm_backup_policy["backup"].hour_duration) : null
    hour_interval = var.vm_backup_policy.frequency == "Hourly" && var.vm_backup_policy["backup"].hour_interval != null ? regex("^4|6|8|12$", var.vm_backup_policy["backup"].hour_interval) : null
    weekdays      = var.vm_backup_policy.frequency == "Weekly" && length(var.vm_backup_policy["backup"].weekdays) != null ? var.vm_backup_policy["backup"].weekdays : null
  }

  