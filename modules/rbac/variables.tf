variable "principal_id" {
	description = "Object ID do principal (utilizador, grupo ou service principal) para o qual será criado o role assignment. Se vazio, nenhum assignment é criado."
	type        = string
	default     = ""
}

variable "role_definition_name" {
	description = "Nome da role definition a atribuir (por exemplo, 'Reader', 'Contributor')."
	type        = string
	default     = "Reader"
}

variable "scope" {
	description = "Scope onde o role assignment será criado (resource group, subscription, management group ou recurso individual). Se vazio, nenhum assignment é criado."
	type        = string
	default     = ""
}

