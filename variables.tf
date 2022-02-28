variable "resource_group_name" {
  type        = string
  description = "Resource Group name of the Virtual Network"
}

variable "location" {
  type        = string
  description = "Location of the Virtual Network"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the Virtual Network to deploy"
}

variable "virtual_network_address_space" {
  type        = list(string)
  description = "Address space of the Virtual Network to deploy"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of Log Analytics Workspace to send diagnostics"
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "Resource Group of Log Analytics Workspace to send diagnostics"
}

variable "tags" {
  type        = map(string)
  description = "Tags of the Virtual Network"
}
