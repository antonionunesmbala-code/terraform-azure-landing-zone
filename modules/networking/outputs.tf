output "resource_group_name" {
	description = "Nome do resource group de rede."
	value       = azurerm_resource_group.network.name
}

output "resource_group_id" {
	description = "ID do resource group de rede."
	value       = azurerm_resource_group.network.id
}

output "vnet_id" {
	description = "ID da virtual network criada."
	value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
	description = "Nome da virtual network criada."
	value       = azurerm_virtual_network.this.name
}

output "subnet_id" {
	description = "ID da subnet principal criada."
	value       = azurerm_subnet.this.id
}

output "subnet_name" {
	description = "Nome da subnet principal criada."
	value       = azurerm_subnet.this.name
}

