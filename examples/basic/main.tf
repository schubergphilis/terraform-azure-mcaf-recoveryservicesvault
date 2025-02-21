terraform {
  required_version = ">= 1.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4"
    }
  }
}

module "recoveryservicesvault" {
  source              = "../../"
  resource_group_name = "example-recovery-services-vault-rg"
  recovery_services_vault = {
    name                          = "example-recoveryservicesvault"
    location                      = "eastus"
    public_network_access_enabled = false
    sku = {
      name = "Standard"
    }
    storage_mode_type                = GeoRedundant
    cross_region_restore_enabled     = true
    soft_delete_enabled              = true
    system_assigned_identity_enabled = true
    immutability                     = 0
  }

  rsv_encryption = {
    cmk_encryption_enabled = true
    cmk_key_vault_key_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-keyvault-rg/providers/Microsoft.KeyVault/vaults/example-keyvault/keys/example-key"
    cmk_identity           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-keyvault-rg/providers/Microsoft.KeyVault/vaults/example-keyvault"
  }

  vm_backup_policy = {
    name                           = "example-vm-backup-policy"
    timezone                       = "UTC"
    instant_restore_retention_days = 5
    policy_type                    = "VMBkp"
    frequency                      = "Daily"
    retention_daily                = 7

    backup = {
      time          = "23:00"
      hour_interval = 6
      hour_duration = 12
      weekdays      = ["Monday", "Wednesday"]
    }

    retention_weekly = {
      count    = 4
      weekdays = ["Monday", "Wednesday"]
    }

    retention_monthly = {
      count = 12
      days  = [1, 15]
    }

    retention_yearly = {
      count  = 10
      months = ["January", "July"]
      days   = [1, 15]
    }
  }

  file_share_backup_policy = {
    name              = "example-file-share-backup-policy"
    retention_daily   = 7
    retention_weekly  = 4
    retention_monthly = 12
    retention_yearly  = 10
    time_zone         = "UTC"
    backup = {
      time = "23:00"
      hourly = {
        interval        = 6
        start_time      = "00:00"
        window_duration = 12
      }
    }
    retention_weekly = {
      count    = 4
      weekdays = ["Monday", "Wednesday"]
    }
    retention_monthly = {
      count = 12
      days  = [1, 15]
    }
    retention_yearly = {
      count  = 10
      months = ["January", "July"]
      days   = [1, 15]
    }
  }


  tags = {
    environment = "prd"
  }
}
