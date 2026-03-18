# Módulo: Management Groups

Este módulo cria uma hierarquia base de **Management Groups** no Azure, preparada para servir de fundação a uma Azure Landing Zone.

## O que o módulo faz

- Cria, por omissão, a seguinte hierarquia lógica:

	```text
	<prefix>-platform
	├── <prefix>-landing-zones
	└── <prefix>-sandbox
	```

- Permite definir um **management group pai** opcional
- Permite adicionar **management groups adicionais** através de uma variável de mapa

Os nomes técnicos dos management groups são construídos a partir da chave lógica e de um prefixo opcional.

---

## Variáveis

- `management_group_prefix` (string, opcional)
	- Prefixo a aplicar aos nomes dos management groups (ex.: `alz-dev`)
	- Se vazio, os nomes serão apenas `platform`, `landing-zones`, `sandbox`, etc.

- `parent_management_group_id` (string, opcional)
	- ID do management group pai sob o qual a hierarquia será criada
	- Se nulo, os grupos são criados diretamente sob o tenant root

- `additional_management_groups` (map(object), opcional)
	- Mapa de management groups adicionais
	- Estrutura:

		```hcl
		additional_management_groups = {
			"corp" = {
				display_name = "Corp"
				parent       = "landing-zones" # ou outra chave existente
			}
		}
		```

---

## Outputs

- `management_group_ids` – mapa com os IDs de todos os management groups criados
- `platform_management_group_id` – ID do management group `platform`, se criado
- `landing_zones_management_group_id` – ID do management group `landing-zones`, se criado
- `sandbox_management_group_id` – ID do management group `sandbox`, se criado

---

## Exemplo de utilização

```hcl
module "management_groups" {
	source = "../../modules/management-groups"

	management_group_prefix    = "alz-dev"
	parent_management_group_id = null

	additional_management_groups = {
		"corp" = {
			display_name = "Corp"
			parent       = "landing-zones"
		}
	}
}
```

---

## Notas

- Este módulo requer permissões a nível de tenant ou de um management group superior para criar novos management groups.
- É recomendado usar este módulo a partir de uma camada de ambiente (por exemplo, `platforms/dev`) para separar a definição da hierarquia dos valores concretos de nomes e prefixos.

