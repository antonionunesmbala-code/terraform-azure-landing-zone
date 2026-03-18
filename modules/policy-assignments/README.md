# Módulo: Policy Assignments

Este módulo gere **atribuições de políticas (Azure Policy Assignments)** de forma simples e segura, usando definitions built‑in.

## Objetivo

- Fornecer um ponto de partida mínimo para governance
- Atribuir uma policy built‑in (por omissão, *Allowed locations*) a um scope
- Não criar assignments quando não há scope definido, evitando falhas em ambientes sem permissões

---

## Recursos criados

- `data.azurerm_policy_definition.this` – Policy definition built‑in obtida por display name
- `azurerm_policy_assignment.this` – Policy assignment (criado apenas se `policy_scope` for definido)

---

## Variáveis principais

- `policy_scope` (string, opcional)
	- Scope onde a policy será atribuída (management group ou subscription)
	- Se vazio, **nenhum** policy assignment é criado

- `policy_definition_display_name` (string, opcional)
	- Display name da policy definition built‑in
	- Valor por omissão: `"Allowed locations"`

- `assignment_name` (string, opcional)
	- Nome do policy assignment
	- Se vazio, é gerado a partir do display name da policy (ex.: `allowed-locations`)

- `location` (string, opcional)
	- Localização a utilizar quando o assignment tiver managed identity associada

- `parameters_json` (string, opcional)
	- String JSON com os parâmetros da policy
	- É convertida internamente para mapa com `jsondecode`

- `identity_type` (string, opcional)
	- Tipo de identidade a atribuir ao policy assignment (ex.: `SystemAssigned`)
	- Se vazio, não é criada qualquer identidade

---

## Outputs

- `policy_assignment_id` – ID do policy assignment criado, ou `null` se não existir
- `policy_assignment_name` – Nome do policy assignment criado, ou `null` se não existir

---

## Exemplo de utilização simples (Allowed locations)

```hcl
module "policy_assignments" {
	source = "../../modules/policy-assignments"

	policy_scope = "/subscriptions/00000000-0000-0000-0000-000000000000"

	# Usa a policy built-in "Allowed locations" por omissão
	parameters_json = jsonencode({
		listOfAllowedLocations = {
			value = ["westeurope"]
		}
	})
}
```

---

## Notas sobre evolução futura

- É possível adicionar suporte a múltiplos assignments, usando uma lista de objetos com scopes e parâmetros diferentes
- Podem ser adicionadas políticas mais complexas (segurança, tagging obrigatória, compliance) mantendo a mesma interface
- Quando forem necessárias policies que exijam managed identity, basta definir `identity_type` e `location` adequados

