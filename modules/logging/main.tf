locals {
	logging_rg_name = var.resource_group_name != "" ? var.resource_group_name : (var.prefix != "" ? "${var.prefix}-logging-rg" : "logging-rg")
	workspace_name  = var.workspace_name != "" ? var.workspace_name : (var.prefix != "" ? "${var.prefix}-log-analytics" : "log-analytics-ws")
}

# Resource group dedicado a logging/monitorização.
resource "azurerm_resource_group" "logging" {
	name     = local.logging_rg_name
	location = var.location
	tags     = var.tags
}

# Log Analytics Workspace para recolha centralizada de logs.
resource "azurerm_log_analytics_workspace" "this" {
	name                = local.workspace_name
	location            = var.location
	resource_group_name = azurerm_resource_group.logging.name
	sku                 = "PerGB2018"
	retention_in_days   = 30
	tags                = var.tags
}

