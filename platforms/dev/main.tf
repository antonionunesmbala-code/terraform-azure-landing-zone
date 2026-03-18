locals {
	common_prefix = "${var.prefix}-${var.environment}"

	common_tags = merge(
		{
			environment = var.environment
			project     = "azure-landing-zone"
			owner       = "platform-team"
		},
		var.tags,
	)
}

# Hierarquia base de management groups (opcional, depende de permissões).
module "management_groups" {
	source = "../../modules/management-groups"

	management_group_prefix    = local.common_prefix
	parent_management_group_id = var.management_group_parent_id
}

# Logging centralizado com Log Analytics.
module "logging" {
	source = "../../modules/logging"

	prefix   = local.common_prefix
	location = var.location
	tags     = local.common_tags
}

# Networking base com VNet e subnet principal.
module "networking" {
	source = "../../modules/networking"

	prefix   = local.common_prefix
	location = var.location

	address_space   = ["10.10.0.0/16"]
	subnet_name     = "default"
	subnet_prefixes = ["10.10.1.0/24"]

	tags = local.common_tags
}

# Policy assignment simples (por exemplo, Allowed locations).
module "policy_assignments" {
	source = "../../modules/policy-assignments"

	policy_scope                   = var.policy_scope
	policy_definition_display_name = "Allowed locations"
	assignment_name                = "${local.common_prefix}-allowed-locations"
	location                       = var.location
	parameters_json                = var.policy_parameters_json
}

# Role assignment opcional para um principal específico.
module "rbac" {
	source = "../../modules/rbac"

	principal_id         = var.rbac_principal_id
	role_definition_name = var.rbac_role_definition_name
	scope                = var.rbac_scope
}

