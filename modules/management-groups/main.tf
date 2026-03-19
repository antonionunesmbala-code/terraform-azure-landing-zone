locals {
	# Definição base de management groups para a landing zone.
	base_management_groups = {
		platform = {
			display_name = "Platform"
		}

		"landing-zones" = {
			display_name = "Landing Zones"
		}

		sandbox = {
			display_name = "Sandbox"
		}
	}
}

# Management group raiz para a plataforma.
resource "azurerm_management_group" "platform" {
	# Nome técnico do management group (único no tenant).
	name = var.management_group_prefix != "" ? "${var.management_group_prefix}-platform" : "platform"

	display_name = local.base_management_groups.platform.display_name

	# Se um management group pai tiver sido fornecido, encadeia sob esse grupo;
	# caso contrário, cria diretamente sob o tenant root.
	parent_management_group_id = var.parent_management_group_id
}

# Management group para landing zones, filho de platform.
resource "azurerm_management_group" "landing_zones" {
	name = var.management_group_prefix != "" ? "${var.management_group_prefix}-landing-zones" : "landing-zones"

	display_name = local.base_management_groups["landing-zones"].display_name

	parent_management_group_id = azurerm_management_group.platform.id
}

# Management group para sandboxes, filho de platform.
resource "azurerm_management_group" "sandbox" {
	name = var.management_group_prefix != "" ? "${var.management_group_prefix}-sandbox" : "sandbox"

	display_name = local.base_management_groups.sandbox.display_name

	parent_management_group_id = azurerm_management_group.platform.id
}

# Management groups adicionais, sempre como filhos de um dos grupos base
# ou de um management group externo identificado por ID completo.
resource "azurerm_management_group" "additional" {
	for_each = var.additional_management_groups

	name = var.management_group_prefix != "" ? "${var.management_group_prefix}-${each.key}" : each.key

	display_name = each.value.display_name

	# Se "parent" for um dos grupos base, usa o respetivo ID;
	# caso contrário, assume que é um ID completo de management group externo.
	parent_management_group_id = (
												   each.value.parent == "platform" ? azurerm_management_group.platform.id :
												   each.value.parent == "landing-zones" ? azurerm_management_group.landing_zones.id :
												   each.value.parent == "sandbox" ? azurerm_management_group.sandbox.id :
												   each.value.parent
												 )
}

