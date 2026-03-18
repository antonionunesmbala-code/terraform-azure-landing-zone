locals {
	create_assignment = var.principal_id != "" && var.scope != ""
}

# Role assignment simples e reutilizável.
resource "azurerm_role_assignment" "this" {
	count = local.create_assignment ? 1 : 0

	scope                = var.scope
	role_definition_name = var.role_definition_name
	principal_id         = var.principal_id
}

