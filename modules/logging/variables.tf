variable "prefix" {
	description = "Prefixo base para os recursos de logging (por exemplo, 'alz-dev')."
	type        = string
	default     = ""
}

variable "location" {
	description = "Região Azure onde os recursos de logging serão criados."
	type        = string
}

variable "resource_group_name" {
	description = "Nome opcional do resource group de logging. Se vazio, será gerado a partir do prefixo."
	type        = string
	default     = ""
}

variable "workspace_name" {
	description = "Nome opcional do Log Analytics Workspace. Se vazio, será gerado a partir do prefixo."
	type        = string
	default     = ""
}

variable "tags" {
	description = "Mapa de tags a aplicar aos recursos de logging."
	type        = map(string)
	default     = {}
}

