output "workspace_id" {
	description = "ID completo do Log Analytics Workspace criado."
	value       = azurerm_log_analytics_workspace.this.id
}

output "workspace_name" {
	description = "Nome do Log Analytics Workspace criado."
	value       = azurerm_log_analytics_workspace.this.name
}

output "resource_group_name" {
	description = "Nome do resource group de logging."
	value       = azurerm_resource_group.logging.name
}

output "resource_group_id" {
	description = "ID do resource group de logging."
	value       = azurerm_resource_group.logging.id
}

