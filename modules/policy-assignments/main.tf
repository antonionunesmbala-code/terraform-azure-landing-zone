locals {
	create_assignment = var.policy_scope != ""

	assignment_name = var.assignment_name != "" ? var.assignment_name : (var.policy_definition_display_name != "" ? replace(lower(var.policy_definition_display_name), " ", "-") : "policy-assignment")

	policy_parameters = var.parameters_json != "" ? jsondecode(var.parameters_json) : {}
}

# Policy definition built-in, obtida por display name.
data "azurerm_policy_definition" "this" {
	display_name = var.policy_definition_display_name
}

# Policy assignment simples. Só é criado se um scope tiver sido fornecido.
resource "azurerm_policy_assignment" "this" {
	count                = local.create_assignment ? 1 : 0

	name                 = local.assignment_name
	scope                = var.policy_scope
	policy_definition_id = data.azurerm_policy_definition.this.id

	# Location é necessária apenas quando existe identidade.
	location   = var.location != "" ? var.location : null
	parameters = local.policy_parameters

	dynamic "identity" {
		for_each = var.identity_type != "" ? [1] : []
		content {
			type = var.identity_type
		}
	}
}

