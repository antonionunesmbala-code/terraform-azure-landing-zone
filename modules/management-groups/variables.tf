variable "management_group_prefix" {
	description = "Prefixo opcional a aplicar aos nomes dos management groups (por exemplo, 'alz-dev')."
	type        = string
	default     = ""
}

variable "parent_management_group_id" {
	description = "ID do management group pai, se existir, sob o qual a hierarquia base será criada. Se nulo, os grupos serão criados diretamente sob o tenant root."
	type        = string
	default     = null
}

variable "additional_management_groups" {
	description = "Mapa opcional de management groups adicionais a criar. A chave é o identificador lógico; 'parent' deve referir outra chave deste mapa ou um dos grupos base (platform, landing-zones, sandbox)."
	type = map(object({
		display_name = string
		parent       = string
	}))
	default = {}
}

