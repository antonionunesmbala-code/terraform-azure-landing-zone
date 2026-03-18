output "management_group_ids" {
	description = "Mapa com os IDs dos management groups criados, indexados pela chave lógica (por exemplo, 'platform', 'landing-zones', 'sandbox')."
	value       = { for k, mg in azurerm_management_group.this : k => mg.id }
}

output "platform_management_group_id" {
	description = "ID do management group 'platform', se criado."
	value       = try(azurerm_management_group.this["platform"].id, null)
}

output "landing_zones_management_group_id" {
	description = "ID do management group 'landing-zones', se criado."
	value       = try(azurerm_management_group.this["landing-zones"].id, null)
}

output "sandbox_management_group_id" {
	description = "ID do management group 'sandbox', se criado."
	value       = try(azurerm_management_group.this["sandbox"].id, null)
}

