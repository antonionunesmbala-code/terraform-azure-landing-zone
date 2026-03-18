variable "location" {
	description = "Região Azure onde os recursos de plataforma (logging, networking, etc.) serão criados."
	type        = string
}

variable "prefix" {
	description = "Prefixo base para nomear recursos de plataforma (por exemplo, 'alz')."
	type        = string
}

variable "environment" {
	description = "Nome do ambiente (por exemplo, 'dev', 'qa', 'prod')."
	type        = string
}

variable "management_group_parent_id" {
	description = "ID do management group pai sob o qual a hierarquia base será criada. Se nulo, será usado o tenant root."
	type        = string
	default     = null
}

variable "tags" {
	description = "Mapa de tags adicionais a aplicar aos recursos de plataforma."
	type        = map(string)
	default     = {}
}

variable "policy_scope" {
	description = "Scope opcional onde será atribuída a policy (subscription ou management group). Se vazio, nenhum assignment é criado."
	type        = string
	default     = ""
}

variable "policy_parameters_json" {
	description = "String JSON opcional com os parâmetros para a policy de Allowed locations ou similar."
	type        = string
	default     = ""
}

variable "rbac_principal_id" {
	description = "Object ID opcional de um utilizador, grupo ou service principal para RBAC. Se vazio, nenhum role assignment é criado."
	type        = string
	default     = ""
}

variable "rbac_role_definition_name" {
	description = "Nome da role definition a atribuir (ex.: 'Reader', 'Contributor')."
	type        = string
	default     = "Reader"
}

variable "rbac_scope" {
	description = "Scope opcional para o role assignment (resource group, subscription, etc.). Se vazio, nenhum assignment é criado."
	type        = string
	default     = ""
}

