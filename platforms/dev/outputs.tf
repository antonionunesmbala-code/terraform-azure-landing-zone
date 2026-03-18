output "management_group_ids" {
	description = "Mapa com os IDs dos management groups criados no ambiente dev."
	value       = module.management_groups.management_group_ids
}

output "platform_management_group_id" {
	description = "ID do management group 'platform' criado pelo módulo de management groups."
	value       = module.management_groups.platform_management_group_id
}

output "logging_workspace_id" {
	description = "ID do Log Analytics Workspace criado para o ambiente dev."
	value       = module.logging.workspace_id
}

output "logging_workspace_name" {
	description = "Nome do Log Analytics Workspace criado para o ambiente dev."
	value       = module.logging.workspace_name
}

output "networking_resource_group_name" {
	description = "Nome do resource group de rede criado para o ambiente dev."
	value       = module.networking.resource_group_name
}

output "networking_vnet_id" {
	description = "ID da VNet criada para o ambiente dev."
	value       = module.networking.vnet_id
}

output "networking_subnet_id" {
	description = "ID da subnet principal criada para o ambiente dev."
	value       = module.networking.subnet_id
}

output "policy_assignment_id" {
	description = "ID do policy assignment criado (se existir)."
	value       = module.policy_assignments.policy_assignment_id
}

output "rbac_role_assignment_id" {
	description = "ID do role assignment criado (se existir)."
	value       = module.rbac.role_assignment_id
}

