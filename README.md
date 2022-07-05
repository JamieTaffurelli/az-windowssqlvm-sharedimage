# Azure Windows Virtual Machine with SQL from Shared Image Gallery module

This repo contains a [Terraform](https://www.terraform.io/) module that defines an Azure Windows Virtual Machine with SQL taken from a Shared Image Gallery. It also deploys a public IP, private IP, disks, VM extensions and Data Collection Rule.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.sql_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_managed_disk.datadisk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_managed_disk.logdisk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_monitor_diagnostic_setting.network_interface_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.public_ip_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.virtual_machine_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_mssql_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_virtual_machine) | resource |
| [azurerm_network_interface.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_public_ip.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group_template_deployment.data_collection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_virtual_machine_data_disk_attachment.datadisk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_data_disk_attachment.logdisk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.av](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.bg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.dep](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.gh](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.nwa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.pol](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [random_password.admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.sql_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.encryption_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.password_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_log_analytics_workspace.logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_shared_image.images](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/shared_image) | data source |
| [azurerm_storage_account.diag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_subnet.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_collection_rule_name"></a> [data\_collection\_rule\_name](#input\_data\_collection\_rule\_name) | Name of data collection rule to send diagnostics | `string` | n/a | yes |
| <a name="input_data_collection_rule_resource_group_name"></a> [data\_collection\_rule\_resource\_group\_name](#input\_data\_collection\_rule\_resource\_group\_name) | Resource Group of data collection rule to send diagnostics | `string` | n/a | yes |
| <a name="input_enable_accelerated_networking"></a> [enable\_accelerated\_networking](#input\_enable\_accelerated\_networking) | Enable accelerated networking, not available for all VM skus | `string` | `true` | no |
| <a name="input_encryption_key_vault_name"></a> [encryption\_key\_vault\_name](#input\_encryption\_key\_vault\_name) | Name of the Key Vault to place disk encryption keys | `string` | n/a | yes |
| <a name="input_encryption_key_vault_resource_group_name"></a> [encryption\_key\_vault\_resource\_group\_name](#input\_encryption\_key\_vault\_resource\_group\_name) | Resource Group name of the Key Vault to place disk encryption keys | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the Virtual Network | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Name of Log Analytics Workspace to send diagnostics | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | Resource Group of Log Analytics Workspace to send diagnostics | `string` | n/a | yes |
| <a name="input_network_interface_name"></a> [network\_interface\_name](#input\_network\_interface\_name) | Name of Network Interface to deploy | `string` | n/a | yes |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | Size in GB of OS disk | `number` | `127` | no |
| <a name="input_password_key_vault_name"></a> [password\_key\_vault\_name](#input\_password\_key\_vault\_name) | Name of the Key Vault to place admin passwords | `string` | n/a | yes |
| <a name="input_password_key_vault_resource_group_name"></a> [password\_key\_vault\_resource\_group\_name](#input\_password\_key\_vault\_resource\_group\_name) | Resource Group name of the Key Vault to place admin passwords | `string` | n/a | yes |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | Private IP address of the VM | `string` | n/a | yes |
| <a name="input_public_ip_name"></a> [public\_ip\_name](#input\_public\_ip\_name) | Name of public ip to deploy | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group name to deploy to | `string` | n/a | yes |
| <a name="input_shared_image_gallery_name"></a> [shared\_image\_gallery\_name](#input\_shared\_image\_gallery\_name) | Name of the shared image gallery to take image from | `string` | n/a | yes |
| <a name="input_shared_image_gallery_resource_group_name"></a> [shared\_image\_gallery\_resource\_group\_name](#input\_shared\_image\_gallery\_resource\_group\_name) | Resource Group name of the shared image gallery to take the image from | `string` | n/a | yes |
| <a name="input_shared_image_name"></a> [shared\_image\_name](#input\_shared\_image\_name) | Name of the shared image to deploy the VM with | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | Size of VM to deploy | `string` | n/a | yes |
| <a name="input_sql_data_disk_lun"></a> [sql\_data\_disk\_lun](#input\_sql\_data\_disk\_lun) | Lun of the data disk | `number` | `3` | no |
| <a name="input_sql_data_disk_name"></a> [sql\_data\_disk\_name](#input\_sql\_data\_disk\_name) | Name of the SQL data disk | `string` | `"sqllog"` | no |
| <a name="input_sql_data_disk_size_gb"></a> [sql\_data\_disk\_size\_gb](#input\_sql\_data\_disk\_size\_gb) | Size of the SQL data disk | `number` | n/a | yes |
| <a name="input_sql_log_disk_lun"></a> [sql\_log\_disk\_lun](#input\_sql\_log\_disk\_lun) | Lun of the log disk | `number` | `2` | no |
| <a name="input_sql_log_disk_name"></a> [sql\_log\_disk\_name](#input\_sql\_log\_disk\_name) | Name of the SQL log disk | `string` | `"sqllog"` | no |
| <a name="input_sql_log_disk_size_gb"></a> [sql\_log\_disk\_size\_gb](#input\_sql\_log\_disk\_size\_gb) | Size of the SQL log disk | `number` | `127` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Storage Account to send boot diagnostics | `string` | n/a | yes |
| <a name="input_storage_account_resource_group_name"></a> [storage\_account\_resource\_group\_name](#input\_storage\_account\_resource\_group\_name) | Resource Group name of the Storage Account to send boot diagnostics | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Name of the subnet to deploy the VM to | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply | `map(string)` | n/a | yes |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | timezone to use for OS | `string` | `"GMT Standard Time"` | no |
| <a name="input_virtual_machine_name"></a> [virtual\_machine\_name](#input\_virtual\_machine\_name) | Name of VM to deploy | `string` | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the Virtual Network to deploy VM to | `string` | n/a | yes |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | Resource Group name of the Virtual Network to deploy VM to | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Availability zone to deploy VM to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_interface_id"></a> [network\_interface\_id](#output\_network\_interface\_id) | Resource ID of the Netowrk Interface |
| <a name="output_network_interface_ip"></a> [network\_interface\_ip](#output\_network\_interface\_ip) | IP address of the Network Interface |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | Public IP address |
| <a name="output_public_ip_id"></a> [public\_ip\_id](#output\_public\_ip\_id) | Resource ID of the public IP |
| <a name="output_virtual_machine_id"></a> [virtual\_machine\_id](#output\_virtual\_machine\_id) | Resource ID of the Virtual Machine |
| <a name="output_virtual_machine_identity_object_id"></a> [virtual\_machine\_identity\_object\_id](#output\_virtual\_machine\_identity\_object\_id) | Object ID of assigned identity |
| <a name="output_virtual_machine_private_ip_address"></a> [virtual\_machine\_private\_ip\_address](#output\_virtual\_machine\_private\_ip\_address) | Private IP address of the Virtual Machine |
| <a name="output_virtual_machine_public_ip_address"></a> [virtual\_machine\_public\_ip\_address](#output\_virtual\_machine\_public\_ip\_address) | Public IP address of the Virtual Machine |
<!-- END_TF_DOCS -->