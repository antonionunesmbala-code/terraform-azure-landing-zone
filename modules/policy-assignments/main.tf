locals {
	create_assignment = var.policy_scope != ""

	assignment_name = var.assignment_name != "" ? var.assignment_name : (var.policy_definition_display_name != "" ? replace(lower(var.policy_definition_display_name), " ", "-") : "policy-assignment")

	policy_parameters = var.parameters_json != "" ? jsondecode(var.parameters_json) : {}

	# Detetar o tipo de scope com base no ID fornecido.
	scope_is_management_group  = local.create_assignment && can(regex("^/providers/Microsoft.Management/managementGroups/", var.policy_scope))
	scope_is_resource_group    = local.create_assignment && !local.scope_is_management_group && can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+$", var.policy_scope))
	scope_is_subscription      = local.create_assignment && !local.scope_is_management_group && !local.scope_is_resource_group && can(regex("^/subscriptions/[^/]+$", var.policy_scope))
	scope_is_resource          = local.create_assignment && !local.scope_is_management_group && !local.scope_is_resource_group && !local.scope_is_subscription
}

# Policy definition built-in, obtida por display name.
data "azurerm_policy_definition" "this" {
	display_name = var.policy_definition_display_name
}

# Policy assignment por Management Group.
resource "azurerm_management_group_policy_assignment" "this" {
	count = local.scope_is_management_group ? 1 : 0

	name                 = local.assignment_name
	management_group_id  = var.policy_scope
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

# Policy assignment por Subscription.
resource "azurerm_subscription_policy_assignment" "this" {
	count = local.scope_is_subscription ? 1 : 0

	name                 = local.assignment_name
	subscription_id      = var.policy_scope
	policy_definition_id = data.azurerm_policy_definition.this.id

	location   = var.location != "" ? var.location : null
	parameters = local.policy_parameters

	dynamic "identity" {
		for_each = var.identity_type != "" ? [1] : []
		content {
			type = var.identity_type
		}
	}
}

# Policy assignment por Resource Group.
resource "azurerm_resource_group_policy_assignment" "this" {
	count = local.scope_is_resource_group ? 1 : 0

	name                = local.assignment_name
	resource_group_id   = var.policy_scope
	policy_definition_id = data.azurerm_policy_definition.this.id

	location   = var.location != "" ? var.location : null
	parameters = local.policy_parameters

	dynamic "identity" {
		for_each = var.identity_type != "" ? [1] : []
		content {
			type = var.identity_type
		}
	}
}

# Policy assignment por recurso individual.
resource "azurerm_resource_policy_assignment" "this" {
	count = local.scope_is_resource ? 1 : 0

	name                 = local.assignment_name
	resource_id          = var.policy_scope
	policy_definition_id = data.azurerm_policy_definition.this.id

	location   = var.location != "" ? var.location : null
	parameters = local.policy_parameters

	dynamic "identity" {
		for_each = var.identity_type != "" ? [1] : []
		content {
			type = var.identity_type
		}
	}
}

