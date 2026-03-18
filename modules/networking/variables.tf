variable "prefix" {
	description = "Prefixo base para os recursos de rede (por exemplo, 'alz-dev')."
	type        = string
	default     = ""
}

variable "location" {
	description = "Região Azure onde o resource group e a VNet serão criados."
	type        = string
}

variable "resource_group_name" {
	description = "Nome opcional do resource group de rede. Se vazio, será gerado a partir do prefixo."
	type        = string
	default     = ""
}

variable "vnet_name" {
	description = "Nome opcional da virtual network. Se vazio, será gerado a partir do prefixo."
	type        = string
	default     = ""
}

variable "address_space" {
	description = "Lista de prefixos de endereço para a VNet (por exemplo, ['10.10.0.0/16'])."
	type        = list(string)
}

variable "subnet_name" {
	description = "Nome da subnet principal a criar dentro da VNet."
	type        = string
}

variable "subnet_prefixes" {
	description = "Lista de prefixos de endereço para a subnet principal (por exemplo, ['10.10.1.0/24'])."
	type        = list(string)
}

variable "tags" {
	description = "Mapa de tags a aplicar aos recursos de rede."
	type        = map(string)
	default     = {}
}

