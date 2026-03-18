# Módulo: Networking

Este módulo cria a base de **networking** da landing zone, composta por um **Resource Group**, uma **Virtual Network (VNet)** e uma **subnet principal**.

## Objetivo

- Fornecer uma rede simples e consistente para o ambiente
- Servir de base para futuras topologias (por exemplo, hub‑spoke)
- Manter names e tags alinhados com o resto da plataforma

---

## Recursos criados

- `azurerm_resource_group.network` – Resource Group dedicado a rede
- `azurerm_virtual_network.this` – Virtual Network principal do ambiente
- `azurerm_subnet.this` – Subnet principal dentro da VNet

---

## Variáveis principais

- `prefix` (string, opcional)
	- Prefixo base para os recursos de rede (ex.: `alz-dev`)

- `location` (string, obrigatório)
	- Região Azure onde o resource group e a VNet serão criados

- `resource_group_name` (string, opcional)
	- Nome explícito do resource group de rede
	- Se vazio, é gerado como `<prefix>-network-rg` ou `network-rg`

- `vnet_name` (string, opcional)
	- Nome explícito da VNet
	- Se vazio, é gerado como `<prefix>-vnet` ou `vnet`

- `address_space` (list(string), obrigatório)
	- Lista de prefixos de endereço para a VNet (ex.: `["10.10.0.0/16"]`)

- `subnet_name` (string, obrigatório)
	- Nome da subnet principal (ex.: `default`)

- `subnet_prefixes` (list(string), obrigatório)
	- Lista de prefixos de endereço para a subnet (ex.: `["10.10.1.0/24"]`)

- `tags` (map(string), opcional)
	- Tags a aplicar a todos os recursos de rede

---

## Outputs

- `resource_group_name` – Nome do resource group de rede
- `resource_group_id` – ID do resource group de rede
- `vnet_id` – ID da VNet criada
- `vnet_name` – Nome da VNet criada
- `subnet_id` – ID da subnet principal
- `subnet_name` – Nome da subnet principal

---

## Exemplo de utilização

```hcl
module "networking" {
	source = "../../modules/networking"

	prefix   = "alz-dev"
	location = "westeurope"

	address_space   = ["10.10.0.0/16"]
	subnet_name     = "default"
	subnet_prefixes = ["10.10.1.0/24"]

	tags = {
		environment = "dev"
		project     = "azure-landing-zone"
	}
}
```

---

## Evolução futura

- Suporte para múltiplas subnets ou conjuntos de subnets por domínio (app, data, gestão)
- Extensão para topologias hub‑spoke, firewalls e gateways
- Integração com módulos de conectividade (VPN, ExpressRoute, etc.)

