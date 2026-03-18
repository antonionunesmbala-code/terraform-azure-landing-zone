output "role_assignment_id" {
	description = "ID do role assignment criado, ou null se nenhum assignment tiver sido criado."
	value       = try(azurerm_role_assignment.this[0].id, null)
}

