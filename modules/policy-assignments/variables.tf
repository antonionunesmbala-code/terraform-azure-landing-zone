variable "policy_scope" {
	description = "Scope onde a policy será atribuída (management group ou subscription). Se vazio, nenhum assignment é criado."
	type        = string
	default     = ""
}

variable "policy_definition_display_name" {
	description = "Display name da policy definition built-in a utilizar (por exemplo, 'Allowed locations')."
	type        = string
	default     = "Allowed locations"
}

variable "assignment_name" {
	description = "Nome opcional do policy assignment. Se vazio, é gerado a partir do display name da policy."
	type        = string
	default     = ""
}

variable "location" {
	description = "Localização opcional para o policy assignment. Necessária quando é usada managed identity."
	type        = string
	default     = ""
}

variable "parameters_json" {
	description = "String JSON opcional com os parâmetros da policy (será convertida para mapa)."
	type        = string
	default     = ""
}

variable "identity_type" {
	description = "Tipo de identidade a atribuir ao policy assignment (por exemplo, 'SystemAssigned'). Se vazio, nenhuma identidade é configurada."
	type        = string
	default     = ""
}

