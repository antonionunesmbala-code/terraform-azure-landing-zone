output "policy_assignment_id" {
	description = "ID do policy assignment criado, ou null se nenhum assignment tiver sido criado."
	value       = try(azurerm_policy_assignment.this[0].id, null)
}

output "policy_assignment_name" {
	description = "Nome do policy assignment criado, ou null se nenhum assignment tiver sido criado."
	value       = try(azurerm_policy_assignment.this[0].name, null)
}

