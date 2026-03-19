output "policy_assignment_id" {
	description = "ID do policy assignment criado, ou null se nenhum assignment tiver sido criado."
	value = try(
		azurerm_management_group_policy_assignment.this[0].id,
		azurerm_subscription_policy_assignment.this[0].id,
		azurerm_resource_group_policy_assignment.this[0].id,
		azurerm_resource_policy_assignment.this[0].id,
		null,
	)
}

output "policy_assignment_name" {
	description = "Nome do policy assignment criado, ou null se nenhum assignment tiver sido criado."
	value = try(
		azurerm_management_group_policy_assignment.this[0].name,
		azurerm_subscription_policy_assignment.this[0].name,
		azurerm_resource_group_policy_assignment.this[0].name,
		azurerm_resource_policy_assignment.this[0].name,
		null,
	)
}

