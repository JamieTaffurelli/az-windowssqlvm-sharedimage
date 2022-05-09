data "azurerm_log_analytics_workspace" "logs" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group_name
}

data "azurerm_virtual_network" "network" {
  name                = var.virtual_network_name
  resource_group_name = var.virtual_network_resource_group_name
}

data "azurerm_subnet" "network" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.virtual_network_resource_group_name
}

data "azurerm_key_vault" "password_kv" {
  name                = var.password_key_vault_name
  resource_group_name = var.password_key_vault_resource_group_name
}

data "azurerm_shared_image" "images" {
  name                = var.shared_image_name
  gallery_name        = var.shared_image_gallery_name
  resource_group_name = var.shared_image_gallery_resource_group_name
}

data "azurerm_storage_account" "diag" {
  name                = var.storage_account_name
  resource_group_name = var.storage_account_resource_group_name
}

data "azurerm_key_vault" "encryption_kv" {
  name                = var.encryption_key_vault_name
  resource_group_name = var.encryption_key_vault_resource_group_name
}

data "azurerm_client_config" "current" {}

resource "azurerm_public_ip" "vm" {
  name                    = var.public_ip_name
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku                     = "Standard"
  allocation_method       = "Static"
  sku_tier                = "Regional"
  zones                   = [1, 2, 3]
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
  tags                    = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "public_ip_diagnostics" {
  name                       = "security-logging"
  target_resource_id         = azurerm_public_ip.vm.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id

  log {
    category = "DDoSProtectionNotifications"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "DDoSMitigationFlowLogs"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "DDoSMitigationReports"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}

resource "azurerm_network_interface" "vm" {
  name                          = var.network_interface_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  enable_ip_forwarding          = false
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.network.id
    private_ip_address_version    = "IPv4"
    private_ip_address_allocation = "Static"
    public_ip_address_id          = azurerm_public_ip.vm.id
    primary                       = true
    private_ip_address            = var.private_ip_address
  }
  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "network_interface_diagnostics" {
  name                       = "security-logging"
  target_resource_id         = azurerm_network_interface.vm.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}

resource "random_password" "admin_password" {
  length           = 16
  special          = true
  lower            = true
  number           = true
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "!^(){}[]-_=+"
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = var.virtual_machine_name
  value        = random_password.admin_password.result
  key_vault_id = data.azurerm_key_vault.password_kv.id

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.virtual_machine_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = "cddadmin"
  admin_password      = azurerm_key_vault_secret.admin_password.value
  network_interface_ids = [
    azurerm_network_interface.vm.id
  ]
  zone                       = var.zone
  source_image_id            = data.azurerm_shared_image.images.id
  allow_extension_operations = true
  enable_automatic_updates   = false
  timezone                   = var.timezone
  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    storage_account_uri = data.azurerm_storage_account.diag.primary_blob_endpoint
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  lifecycle {
    ignore_changes = [
      admin_password
    ]
  }
  tags = var.tags
}

resource "azurerm_managed_disk" "logdisk" {
  name                 = "${var.virtual_machine_name}-${var.sql_log_disk_name}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.sql_log_disk_size_gb
  zone                 = var.zone
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "logdisk" {
  managed_disk_id    = azurerm_managed_disk.logdisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = var.sql_log_disk_lun
  caching            = "ReadWrite"
}

resource "azurerm_managed_disk" "datadisk" {
  name                 = "${var.virtual_machine_name}-${var.sql_data_disk_name}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.sql_data_disk_size_gb
  zone                 = var.zone
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "datadisk" {
  managed_disk_id    = azurerm_managed_disk.datadisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = var.sql_data_disk_lun
  caching            = "ReadWrite"
}
/*
resource "azurerm_virtual_machine_extension" "ade" {
  name                       = "AzureDiskEncryption"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "AzureDiskEncryption"
  type_handler_version       = "2.2"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "EncryptionOperation": "EnableEncryption",
      "KeyVaultURL": "${data.azurerm_key_vault.encryption_kv.vault_uri}",
      "KeyVaultResourceId": "${data.azurerm_key_vault.encryption_kv.id}",
      "VolumeType": "All"
    }
SETTINGS
  tags = var.tags
  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.logdisk,
    azurerm_virtual_machine_data_disk_attachment.datadisk
  ]
}
*/
resource "azurerm_virtual_machine_extension" "logs" {
  name                       = "MicrosoftMonitoringAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  settings           = <<SETTINGS
    {
      "workspaceId": "${data.azurerm_log_analytics_workspace.logs.workspace_id}"
    }
SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey": "${data.azurerm_log_analytics_workspace.logs.primary_shared_key}"
    }
PROTECTED_SETTINGS
  tags               = var.tags
}

resource "azurerm_virtual_machine_extension" "dep" {
  name                       = "DependencyAgentWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.10"
  auto_upgrade_minor_version = true
  tags                       = var.tags
  depends_on                 = [azurerm_virtual_machine_extension.logs]
}

resource "azurerm_virtual_machine_extension" "pol" {
  name                       = "AzurePolicyforWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.GuestConfiguration"
  type                       = "ConfigurationforWindows"
  type_handler_version       = "1.1"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true
  tags                       = var.tags
  depends_on                 = [azurerm_virtual_machine_extension.logs]
}

resource "azurerm_virtual_machine_extension" "av" {
  name                       = "IaaSAntimalware"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.5"
  auto_upgrade_minor_version = true

  settings   = <<SETTINGS
    {
      "AntimalwareEnabled": "true",
      "RealtimeProtectionEnabled": "true",
      "ScheduledScanSettings": {
        "isEnabled": "true",
        "scanType": "Quick",
        "day": "7",
        "time": "120"
      }
    }
SETTINGS
  tags       = var.tags
  depends_on = [azurerm_virtual_machine_extension.logs]
}

resource "azurerm_virtual_machine_extension" "nwa" {
  name                       = "NetworkWatcherAgentWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentWindows"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
  tags                       = var.tags
  depends_on                 = [azurerm_virtual_machine_extension.logs]
}

resource "azurerm_resource_group_template_deployment" "data_collection" {
  name                = "data-collection-${var.virtual_machine_name}"
  resource_group_name = var.resource_group_name
  template_content    = file("arm\\vmDataCollectionRuleAssociation.json")
  parameters_content = jsonencode({
    "vmName" = {
      value = azurerm_windows_virtual_machine.vm.name
    },
    "associationName" = {
      value = "VM-Health-Dcr-Association"
    },
    "dataCollectionRuleId" = {
      value = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.data_collection_rule_resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${var.data_collection_rule_name}"
    }
  })
  deployment_mode = "Incremental"
  depends_on      = [azurerm_virtual_machine_extension.logs]
}

resource "azurerm_virtual_machine_extension" "gh" {
  name                       = "GuestHealthWindowsAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Monitor.VirtualMachines.GuestHealth"
  type                       = "GuestHealthWindowsAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  tags                       = var.tags
  depends_on                 = [azurerm_resource_group_template_deployment.data_collection]
}

resource "azurerm_virtual_machine_extension" "bg" {
  name                       = "BGInfo"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "BGInfo"
  type_handler_version       = "2.1"
  auto_upgrade_minor_version = true
  tags                       = var.tags
}

resource "random_password" "sql_admin_password" {
  length           = 16
  special          = true
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "!^(){}[]-_=+"
}

resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "${var.virtual_machine_name}-sql"
  value        = random_password.sql_admin_password.result
  key_vault_id = data.azurerm_key_vault.password_kv.id

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "azurerm_mssql_virtual_machine" "vm" {
  virtual_machine_id               = azurerm_windows_virtual_machine.vm.id
  sql_license_type                 = "PAYG"
  r_services_enabled               = false
  sql_connectivity_port            = 1433
  sql_connectivity_type            = "PRIVATE"
  sql_connectivity_update_password = azurerm_key_vault_secret.sql_admin_password.value
  sql_connectivity_update_username = "cddadmin"

  storage_configuration {
    disk_type             = "NEW"
    storage_workload_type = "GENERAL"

    data_settings {
      default_file_path = "F:\\SQLData"
      luns              = [var.sql_data_disk_lun]
    }

    log_settings {
      default_file_path = "G:\\SQLLog"
      luns              = [var.sql_log_disk_lun]
    }
  }

  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.logdisk,
    azurerm_virtual_machine_data_disk_attachment.datadisk
  ]

  lifecycle {
    ignore_changes = [
      sql_connectivity_update_password
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "virtual_machine_diagnostics" {
  name                       = "security-logging"
  target_resource_id         = azurerm_windows_virtual_machine.vm.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}
