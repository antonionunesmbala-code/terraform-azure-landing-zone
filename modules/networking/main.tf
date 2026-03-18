locals {
  network_rg_name = var.resource_group_name != "" ? var.resource_group_name : (var.prefix != "" ? "${var.prefix}-network-rg" : "network-rg")
  vnet_name       = var.vnet_name != "" ? var.vnet_name : (var.prefix != "" ? "${var.prefix}-vnet" : "vnet")
}

# Resource group dedicado a recursos de rede.
resource "azurerm_resource_group" "network" {
  name     = local.network_rg_name
  location = var.location
  tags     = var.tags
}

# Virtual Network base para o ambiente.
resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = var.address_space
  tags                = var.tags
}

# Subnet principal da VNet.
resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.subnet_prefixes
}

