<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.18.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_recovery_services_vault_file_share_policy"></a> [recovery\_services\_vault\_file\_share\_policy](#module\_recovery\_services\_vault\_file\_share\_policy) | ./modules/filesharepolicy | n/a |
| <a name="module_recovery_services_vault_vm_policy"></a> [recovery\_services\_vault\_vm\_policy](#module\_recovery\_services\_vault\_vm\_policy) | ./modules/virtualmachinepolicy | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_recovery_services_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/recovery_services_vault) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Location of the resources to create | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the Recovery Services Vault. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the Recovery Services Vault should be created. | `string` | n/a | yes |
| <a name="input_cmk_identity_id"></a> [cmk\_identity\_id](#input\_cmk\_identity\_id) | The user-assigned identity to use for Customer Managed Key encryption. | `string` | `null` | no |
| <a name="input_cmk_key_vault_key_id"></a> [cmk\_key\_vault\_key\_id](#input\_cmk\_key\_vault\_key\_id) | The Key Vault key ID for CMK encryption. | `string` | `null` | no |
| <a name="input_cross_region_restore_enabled"></a> [cross\_region\_restore\_enabled](#input\_cross\_region\_restore\_enabled) | Enable or disable cross region restore for backups in the vault. | `bool` | `false` | no |
| <a name="input_file_share_backup_policy"></a> [file\_share\_backup\_policy](#input\_file\_share\_backup\_policy) | A map objects for backup and retation options.<br><br>    - `name` - (Optional) The name of the private endpoint. One will be generated if not set.<br>    - `role_assignments` - (Optional) A map of role assignments to create on the <br><br>    - `backup` - (required) backup options.<br>        - `frequency` - (Required) Sets the backup frequency. Possible values are hourly, Daily and Weekly.<br>        - `time` - (required) Specify time in a 24 hour format HH:MM. "22:00"<br>        - `hour_interval` - (Optional) Interval in hour at which backup is triggered. Possible values are 4, 6, 8 and 12. This is used when frequency is hourly. 6<br>        - `hour_duration` -  (Optional) Duration of the backup window in hours. Possible values are between 4 and 24 This is used when frequency is hourly. 12<br>        - `weekdays` -  (Optional) The days of the week to perform backups on. Must be one of Sunday, Monday, Tuesday, Wednesday, Thursday, Friday or Saturday. This is used when frequency is Weekly. ["Tuesday", "Saturday"]<br>    - `retention_daily` - (Optional)<br>      - `count` - <br>    - `retantion_weekly` -<br>      - `count` -<br>      - `weekdays` -<br>    - `retantion_monthly` -<br>      - `count` -  # (Required) The number of monthly backups to keep. Must be between 1 and 9999<br>      - `weekdays` - (Optional) The weekday backups to retain . Must be one of Sunday, Monday, Tuesday, Wednesday, Thursday, Friday or Saturday.<br>      - `weeks` -  # (Optional) The weeks of the month to retain backups of. Must be one of First, Second, Third, Fourth, Last.<br>      - `days` -  # (Optional) The days of the month to retain backups of. Must be between 1 and 31.<br>      - `include_last_days` -  # (Optional) Including the last day of the month, default to false.<br>    - `retantion_yearly` -<br>      - `months` - # (Required) The months of the year to retain backups of. Must be one of January, February, March, April, May, June, July, August, September, October, November and December.<br>      - `count` -  # (Required) The number of monthly backups to keep. Must be between 1 and 9999<br>      - `weekdays` - (Optional) The weekday backups to retain . Must be one of Sunday, Monday, Tuesday, Wednesday, Thursday, Friday or Saturday.<br>      - `weeks` -  # (Optional) The weeks of the month to retain backups of. Must be one of First, Second, Third, Fourth, Last.<br>      - `days` -  # (Optional) The days of the month to retain backups of. Must be between 1 and 31.<br>      - `include_last_days` -  # (Optional) Including the last day of the month, default to false.<br><br>    example:<br>      retentions = {<br>      rest1 = {<br>        backup = {<br>          frequency     = "hourly"<br>          time          = "22:00"<br>          hour\_interval = 6<br>          hour\_duration = 12<br>          # weekdays      = ["Tuesday", "Saturday"]<br>        }<br>        retention\_daily = 7<br>        retention\_weekly = {<br>          count    = 7<br>          weekdays = ["Monday", "Wednesday"]<br><br>        }<br>        retention\_monthly = {<br>          count = 5<br>          # weekdays =  ["Tuesday","Saturday"]<br>          # weeks = ["First","Third"]<br>          days = [3, 10, 20]<br>        }<br>        retention\_yearly = {<br>          count  = 5<br>          months = []<br>          # weekdays =  ["Tuesday","Saturday"]<br>          # weeks = ["First","Third"]<br>          days = [3, 10, 20]<br>        }<br><br>        }<br>      } | <pre>map(object({<br>    name            = string<br>    timezone        = string<br>    frequency       = string<br>    retention_daily = optional(number, null)<br><br>    backup = object({<br>      time = string<br>      hourly = optional(object({<br>        interval        = number<br>        start_time      = string<br>        window_duration = number<br>      }))<br>    })<br><br>    retention_weekly = optional(object({<br>      count    = optional(number, 7)<br>      weekdays = optional(list(string), [])<br>    }), {})<br><br>    retention_monthly = optional(object({<br>      count             = optional(number, 0)<br>      weekdays          = optional(list(string), [])<br>      weeks             = optional(list(string), [])<br>      days              = optional(list(number), [])<br>      include_last_days = optional(bool, false)<br>    }), {})<br><br>    retention_yearly = optional(object({<br>      count             = optional(number, 0)<br>      months            = optional(list(string), [])<br>      weekdays          = optional(list(string), [])<br>      weeks             = optional(list(string), [])<br>      days              = optional(list(number), [])<br>      include_last_days = optional(bool, false)<br>    }), {})<br>  }))</pre> | `null` | no |
| <a name="input_immutability"></a> [immutability](#input\_immutability) | Enable or disable immutability for backups in the vault. | `string` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Enable or disable public network access, defaults to false | `bool` | `false` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The SKU of the Recovery Services Vault, defaults to 'Standard' | `string` | `"Standard"` | no |
| <a name="input_soft_delete_enabled"></a> [soft\_delete\_enabled](#input\_soft\_delete\_enabled) | Enable or disable soft delete for the vault, defaults to true | `bool` | `true` | no |
| <a name="input_storage_mode_type"></a> [storage\_mode\_type](#input\_storage\_mode\_type) | The storage mode type for the vault. Possible values are 'GeoRedundant', 'LocallyRedundant', or 'ZoneRedundant', defaults to 'ZoneRedundant' | `string` | `"GeoRedundant"` | no |
| <a name="input_system_assigned_identity_enabled"></a> [system\_assigned\_identity\_enabled](#input\_system\_assigned\_identity\_enabled) | Whether to use a system assigned identity for the vault. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to vault. | `map(string)` | `{}` | no |
| <a name="input_user_assigned_identities"></a> [user\_assigned\_identities](#input\_user\_assigned\_identities) | Set of user-assigned resource IDs for identity assignment. | `set(string)` | `[]` | no |
| <a name="input_vm_backup_policy"></a> [vm\_backup\_policy](#input\_vm\_backup\_policy) | A map of objects for backup and retention options.<br><br>    - `name` - (Required) The name of the backup policy.<br>    - `timezone` - (Required) The timezone for the backup policy.<br>    - `instant_restore_retention_days` - (Optional) The number of days to retain instant restore points.<br>    - `instant_restore_resource_group` - (Optional) A map of resource group options for instant restore.<br>        - `prefix` - (Optional) Prefix for the resource group name.<br>        - `suffix` - (Optional) Suffix for the resource group name.<br>    - `policy_type` - (Required) The type of the backup policy.<br>    - `frequency` - (Required) The frequency of the backup. Possible values are Hourly, Daily, and Weekly.<br><br>    - `backup` - (Required) Backup options.<br>        - `time` - (Required) Specify time in a 24-hour format HH:MM. Example: "22:00".<br>        - `hour_interval` - (Optional) Interval in hours at which backup is triggered. Possible values are 4, 6, 8, and 12. This is used when frequency is Hourly.<br>        - `hour_duration` - (Optional) Duration of the backup window in hours. Possible values are between 4 and 24. This is used when frequency is Hourly.<br>        - `weekdays` - (Optional) The days of the week to perform backups on. Must be one of Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, or Saturday. This is used when frequency is Weekly.<br><br>    - `retention_daily` - (Optional) The number of daily backups to retain.<br>    - `retention_weekly` - (Optional) A map of weekly retention options.<br>        - `count` - (Optional) The number of weekly backups to retain.<br>        - `weekdays` - (Optional) The weekdays to retain backups. Must be one of Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, or Saturday.<br>    - `retention_monthly` - (Optional) A map of monthly retention options.<br>        - `count` - (Required) The number of monthly backups to retain. Must be between 1 and 9999.<br>        - `weekdays` - (Optional) The weekdays to retain backups. Must be one of Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, or Saturday.<br>        - `weeks` - (Optional) The weeks of the month to retain backups. Must be one of First, Second, Third, Fourth, Last.<br>        - `days` - (Optional) The days of the month to retain backups. Must be between 1 and 31.<br>        - `include_last_days` - (Optional) Include the last day of the month. Defaults to false.<br>    - `retention_yearly` - (Optional) A map of yearly retention options.<br>        - `count` - (Required) The number of yearly backups to retain. Must be between 1 and 9999.<br>        - `months` - (Required) The months of the year to retain backups. Must be one of January, February, March, April, May, June, July, August, September, October, November, or December.<br>        - `weekdays` - (Optional) The weekdays to retain backups. Must be one of Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, or Saturday.<br>        - `weeks` - (Optional) The weeks of the month to retain backups. Must be one of First, Second, Third, Fourth, Last.<br>        - `days` - (Optional) The days of the month to retain backups. Must be between 1 and 31.<br>        - `include_last_days` - (Optional) Include the last day of the month. Defaults to false.<br><br>    Example:<br>      vm\_backup\_policy = {<br>        example\_policy = {<br>          name                           = "example\_policy"<br>          timezone                       = "UTC"<br>          policy\_type                    = "VMBkp"<br>          frequency                      = "Hourly"<br>          backup = {<br>            time          = "22:00"<br>            hour\_interval = 6<br>            hour\_duration = 12<br>          }<br>          retention\_daily = 7<br>          retention\_weekly = {<br>            count    = 7<br>            weekdays = ["Monday", "Wednesday"]<br>          }<br>          retention\_monthly = {<br>            count    = 5<br>            days     = [3, 10, 20]<br>          }<br>          retention\_yearly = {<br>            count  = 5<br>            months = ["January", "July"]<br>            days   = [3, 10, 20]<br>          }<br>        }<br>      } | <pre>map(object({<br>    name                           = string<br>    timezone                       = string<br>    instant_restore_retention_days = optional(number, null)<br>    policy_type                    = string<br>    frequency                      = string<br><br>    retention_daily = optional(number, null)<br><br>    backup = object({<br>      time          = string<br>      hour_interval = optional(number, null)<br>      hour_duration = optional(number, null)<br>      weekdays      = optional(list(string), [])<br>    })<br><br>    retention_weekly = optional(object({<br>      count    = optional(number, 7)<br>      weekdays = optional(list(string), [])<br>    }), {})<br><br>    retention_monthly = optional(object({<br>      count             = optional(number, 0)<br>      weekdays          = optional(list(string), [])<br>      weeks             = optional(list(string), [])<br>      days              = optional(list(number), [])<br>      include_last_days = optional(bool, false)<br>    }), {})<br><br>    retention_yearly = optional(object({<br>      count             = optional(number, 0)<br>      months            = optional(list(string), [])<br>      weekdays          = optional(list(string), [])<br>      weeks             = optional(list(string), [])<br>      days              = optional(list(number), [])<br>      include_last_days = optional(bool, false)<br>    }), {})<br>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_recovery_services_vault_id"></a> [recovery\_services\_vault\_id](#output\_recovery\_services\_vault\_id) | The ID of the Recovery Service Vault |
<!-- END_TF_DOCS --># terraform-azure-mcaf-backupvault
