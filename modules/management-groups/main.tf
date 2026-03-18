locals {
	# Hierarquia base de management groups para a landing zone.
	# As chaves representam identificadores lógicos internos; o nome final
	# do management group pode levar um prefixo (por exemplo, "alz-dev-platform").
	default_management_groups = {
		platform = {
			display_name = "Platform"
			parent       = ""
		}

		"landing-zones" = {
			display_name = "Landing Zones"
			parent       = "platform"
		}

		sandbox = {
			display_name = "Sandbox"
			parent       = "platform"
		}
	}

	management_groups = merge(
		local.default_management_groups,
		var.additional_management_groups,
	)
}

resource "azurerm_management_group" "this" {
	for_each = local.management_groups

	# Nome técnico do management group (único no tenant).
	name = var.management_group_prefix != "" ? "${var.management_group_prefix}-${each.key}" : each.key

	display_name = each.value.display_name

	# Se "parent" estiver definido, encadeia com outro management group do módulo;
	# caso contrário, usa o management group pai passado por variável (ou tenant root).
	parent_management_group_id = each.value.parent != "" ? azurerm_management_group.this[each.value.parent].id : var.parent_management_group_id
}

