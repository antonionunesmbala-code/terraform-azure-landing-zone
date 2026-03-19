locals {
	base_management_group_ids = {
		platform      = azurerm_management_group.platform.id
		"landing-zones" = azurerm_management_group.landing_zones.id
		sandbox       = azurerm_management_group.sandbox.id
	}
}

output "management_group_ids" {
	description = "Mapa com os IDs dos management groups criados, indexados pela chave lógica (por exemplo, 'platform', 'landing-zones', 'sandbox')."
	value       = merge(local.base_management_group_ids, { for k, mg in azurerm_management_group.additional : k => mg.id })
}

output "platform_management_group_id" {
	description = "ID do management group 'platform', se criado."
	value       = azurerm_management_group.platform.id
}

output "landing_zones_management_group_id" {
	description = "ID do management group 'landing-zones', se criado."
	value       = azurerm_management_group.landing_zones.id
}

output "sandbox_management_group_id" {
	description = "ID do management group 'sandbox', se criado."
	value       = azurerm_management_group.sandbox.id
}

