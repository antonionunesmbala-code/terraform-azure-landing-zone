# Módulo: Logging

Este módulo cria a fundação de **logging e monitorização** para a landing zone, através de um **Resource Group** dedicado e de um **Log Analytics Workspace**.

## Objetivo

- Centralizar logs e métricas num workspace único
- Fornecer um ponto de integração para futuras diagnostic settings
- Manter nomes e tags consistentes em todos os ambientes

---

## Recursos criados

- `azurerm_resource_group.logging` – Resource Group dedicado a logging
- `azurerm_log_analytics_workspace.this` – Log Analytics Workspace principal

---

## Variáveis principais

- `prefix` (string, opcional)
	- Prefixo base para os recursos de logging (ex.: `alz-dev`)

- `location` (string, obrigatório)
	- Região Azure onde o resource group e o workspace serão criados

- `resource_group_name` (string, opcional)
	- Nome explícito do resource group de logging
	- Se vazio, é gerado como `<prefix>-logging-rg` ou `logging-rg` se não houver prefixo

- `workspace_name` (string, opcional)
	- Nome explícito do Log Analytics Workspace
	- Se vazio, é gerado como `<prefix>-log-analytics` ou `log-analytics-ws`

- `tags` (map(string), opcional)
	- Tags a aplicar a todos os recursos do módulo

---

## Outputs

- `workspace_id` – ID completo do Log Analytics Workspace
- `workspace_name` – Nome do workspace
- `resource_group_name` – Nome do resource group de logging
- `resource_group_id` – ID do resource group de logging

---

## Exemplo de utilização

```hcl
module "logging" {
	source = "../../modules/logging"

	prefix   = "alz-dev"
	location = "westeurope"

	tags = {
		environment = "dev"
		project     = "azure-landing-zone"
	}
}
```

---

## Evolução futura

- Adicionar diagnostic settings de subscriptions, activity logs e recursos críticos para o workspace
- Integrar com soluções de monitorização adicionais (por exemplo, Azure Monitor, Application Insights)
- Suportar múltiplos workspaces, caso necessário, mantendo a mesma interface simples

