terraform {
	required_version = ">= 1.5.0"

	required_providers {
		azurerm = {
			source  = "hashicorp/azurerm"
			version = ">= 3.0.0"
		}
	}
}

provider "azurerm" {
	features {}
}

variable "location" {
	description = "Região Azure onde os recursos de exemplo serão criados."
	type        = string
}

variable "prefix" {
	description = "Prefixo base para os recursos de exemplo (por exemplo, 'alz')."
	type        = string
}

variable "environment" {
	description = "Nome do ambiente (por exemplo, 'dev')."
	type        = string
}

locals {
	common_prefix = "${var.prefix}-${var.environment}"

	common_tags = {
		environment = var.environment
		project     = "azure-landing-zone-example"
	}
}

# Logging simples para o exemplo.
module "logging" {
	source = "../../modules/logging"

	prefix   = local.common_prefix
	location = var.location
	tags     = local.common_tags
}

# Networking simples para o exemplo.
module "networking" {
	source = "../../modules/networking"

	prefix   = local.common_prefix
	location = var.location

	address_space   = ["10.20.0.0/16"]
	subnet_name     = "default"
	subnet_prefixes = ["10.20.1.0/24"]

	tags = local.common_tags
}

output "example_logging_workspace_name" {
	description = "Nome do Log Analytics Workspace criado pelo exemplo."
	value       = module.logging.workspace_name
}

output "example_networking_vnet_name" {
	description = "Nome da VNet criada pelo exemplo."
	value       = module.networking.vnet_name
}

