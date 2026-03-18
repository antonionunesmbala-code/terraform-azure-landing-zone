# Módulo: RBAC

Este módulo gere **Role Assignments (RBAC)** de forma simples, criando uma atribuição de role para um principal e um scope específicos.

## Objetivo

- Fornecer um bloco reutilizável para criar role assignments mínimos
- Evitar complexidade excessiva em fases iniciais da landing zone
- Permitir extensão futura para múltiplos assignments

---

## Recursos criados

- `azurerm_role_assignment.this` – Role assignment único (criado apenas se as variáveis necessárias forem fornecidas)

---

## Variáveis principais

- `principal_id` (string, opcional)
	- Object ID do utilizador, grupo ou service principal
	- Se vazio, **nenhum** role assignment é criado

- `role_definition_name` (string, opcional)
	- Nome da role definition (ex.: `Reader`, `Contributor`)
	- Valor por omissão: `"Reader"`

- `scope` (string, opcional)
	- Scope do role assignment (resource group, subscription, management group, etc.)
	- Se vazio, **nenhum** role assignment é criado

---

## Output

- `role_assignment_id` – ID do role assignment criado, ou `null` se não existir

---

## Exemplo de utilização

```hcl
module "rbac" {
	source = "../../modules/rbac"

	principal_id         = "00000000-0000-0000-0000-000000000000" # Object ID de um utilizador/grupo/SPN
	role_definition_name = "Reader"
	scope                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/alz-dev-logging-rg"
}
```

---

## Evolução futura

- Suporte a listas de assignments (múltiplos principals e scopes)
- Integração com dados de Azure AD (por exemplo, resolução de grupos por nome)
- Possibilidade de criar custom roles antes de atribuir

