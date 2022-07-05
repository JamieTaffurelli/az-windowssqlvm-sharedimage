variable "resource_group_name" {
  type        = string
  description = "Resource Group name to deploy to"
}

variable "location" {
  type        = string
  description = "Location of the Virtual Network"
}

variable "virtual_machine_name" {
  type        = string
  description = "Name of VM to deploy"
}

variable "size" {
  type        = string
  description = "Size of VM to deploy"
}

variable "zone" {
  type        = string
  description = "Availability zone to deploy VM to"
}

variable "os_disk_size_gb" {
  type        = number
  default     = 127
  description = "Size in GB of OS disk"
}

variable "timezone" {
  type        = string
  default     = "GMT Standard Time"
  description = "timezone to use for OS"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet to deploy the VM to"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the Virtual Network to deploy VM to"
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "Resource Group name of the Virtual Network to deploy VM to"
}

variable "password_key_vault_name" {
  type        = string
  description = "Name of the Key Vault to place admin passwords"
}

variable "password_key_vault_resource_group_name" {
  type        = string
  description = "Resource Group name of the Key Vault to place admin passwords"
}

variable "encryption_key_vault_name" {
  type        = string
  description = "Name of the Key Vault to place disk encryption keys"
}

variable "encryption_key_vault_resource_group_name" {
  type        = string
  description = "Resource Group name of the Key Vault to place disk encryption keys"
}

variable "shared_image_name" {
  type        = string
  description = "Name of the shared image to deploy the VM with"
}

variable "shared_image_gallery_name" {
  type        = string
  description = "Name of the shared image gallery to take image from"
}

variable "shared_image_gallery_resource_group_name" {
  type        = string
  description = "Resource Group name of the shared image gallery to take the image from"
}

variable "public_ip_name" {
  type        = string
  description = "Name of public ip to deploy"
}

variable "network_interface_name" {
  type        = string
  description = "Name of Network Interface to deploy"
}

variable "enable_accelerated_networking" {
  type        = string
  default     = true
  description = "Enable accelerated networking, not available for all VM skus"
}

variable "private_ip_address" {
  type        = string
  description = "Private IP address of the VM"
}

variable "storage_account_name" {
  type        = string
  description = "Storage Account to send boot diagnostics"
}

variable "storage_account_resource_group_name" {
  type        = string
  description = "Resource Group name of the Storage Account to send boot diagnostics"
}

variable "sql_log_disk_name" {
  type        = string
  default     = "sqllog"
  description = "Name of the SQL log disk"
}

variable "sql_log_disk_size_gb" {
  type        = number
  default     = 127
  description = "Size of the SQL log disk"
}

variable "sql_log_disk_lun" {
  type        = number
  default     = 2
  description = "Lun of the log disk"
}

variable "sql_data_disk_name" {
  type        = string
  default     = "sqllog"
  description = "Name of the SQL data disk"
}

variable "sql_data_disk_size_gb" {
  type        = number
  description = "Size of the SQL data disk"
}

variable "sql_data_disk_lun" {
  type        = number
  default     = 3
  description = "Lun of the data disk"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of Log Analytics Workspace to send diagnostics"
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "Resource Group of Log Analytics Workspace to send diagnostics"
}

variable "data_collection_rule_name" {
  type        = string
  description = "Name of data collection rule to send diagnostics"
}

variable "data_collection_rule_resource_group_name" {
  type        = string
  description = "Resource Group of data collection rule to send diagnostics"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
}
