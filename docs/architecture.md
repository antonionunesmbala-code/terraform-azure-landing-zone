# Arquitetura da Azure Landing Zone

Este documento descreve a arquitetura de alto nível da landing zone implementada neste repositório, bem como as principais decisões de desenho que orientaram a estrutura de pastas e módulos.

O foco é uma **fundação simples, mas alinhada com boas práticas**, preparada para crescer para cenários mais complexos sem obrigar a reescrever tudo de raiz.

---

## O que é uma Azure Landing Zone

Uma **Azure Landing Zone** é um conjunto de padrões, controlos e recursos que estabelecem a fundação para alojar workloads de forma segura, governada e repetível na Azure. Normalmente inclui:

- Estrutura de **management groups**
- Padrões de **naming** e **tagging**
- **Políticas** de governance (Azure Policy)
- Modelo de **RBAC** (controlo de acessos)
- **Networking** consistente (VNets, subnets, conectividade)
- **Logging** e monitorização centralizados

Neste projeto, implementa‑se uma **versão inicial** desta fundação, focada em mostrar uma abordagem profissional e organizada, adequada para portefólio.

---

## Management Groups

A estrutura de management groups segue uma hierarquia base, pensada para ser clara e extensível:

```text
Tenant Root
│
└── <prefix>-platform
		├── <prefix>-landing-zones
		└── <prefix>-sandbox
```

Onde `<prefix>` é um valor configurável (por exemplo, `alz-dev`), definido na camada de ambiente.

- **platform**: agrupa recursos de plataforma partilhados (logging, rede, segurança comum)
- **landing-zones**: destina‑se a workloads de negócio mais formais (por exemplo, corp, online, line‑of‑business)
- **sandbox**: espaço isolado para experimentação, provas de conceito e testes menos controlados

O módulo `modules/management-groups` é responsável por criar esta hierarquia, permitindo ainda a definição de grupos adicionais no futuro.

---

## Logging

O logging é um dos pilares de uma landing zone saudável. Neste projeto:

- O módulo `modules/logging` cria:
	- Um **Resource Group** dedicado a monitorização
	- Um **Log Analytics Workspace**
- A camada de ambiente (`platforms/dev`) decide:
	- Nome do resource group
	- Nome do workspace
	- Localização (`location`)
	- Tags a aplicar

Esta abordagem desacopla a **implementação técnica** (módulo) da **configuração de ambiente** (valores concretos), facilitando a reutilização do módulo em vários ambientes.

---

## Policy

As **Azure Policies** permitem aplicar controlos de governance de forma consistente. Nesta fase inicial, o objetivo é:

- Ter um módulo simples (`modules/policy-assignments`) capaz de:
	- Receber um `scope` (por exemplo, uma subscription ou management group)
	- Atribuir uma policy definition (por ID direto ou através de uma policy built‑in identificada por display name)
	- Permitir o envio de parâmetros opcionais

Na camada de `platforms/dev`, é usado um exemplo de policy built‑in (por exemplo, *Allowed locations*), com parâmetros mínimos para restringir a localização dos recursos.

O desenho do módulo foi feito para ser **fácil de estender** no futuro, adicionando novos assignments ou policies mais complexas sem alterar a estrutura base.

---

## RBAC

O controlo de acessos é tratado por um módulo específico em `modules/rbac`, que se foca em **role assignments**:

- Recebe uma lista de objetos com:
	- `principal_id` (utilizador, grupo ou service principal)
	- `role_definition_name` (por exemplo, `Reader`, `Contributor`)
	- `scope` (resource group, subscription, management group, etc.)
- Cria um `azurerm_role_assignment` por cada entrada na lista

Este padrão torna o módulo:

- Simples de utilizar
- Reutilizável em vários contextos
- Facilmente extensível para incluir, por exemplo, condições ou descrições adicionais

---

## Networking

O módulo `modules/networking` implementa a base de rede necessária para iniciar a aterragem de workloads:

- **Resource Group** de rede dedicado
- **Virtual Network (VNet)** com um address space configurável
- Um conjunto de **subnets**, parametrizadas através de um mapa

Esta abordagem permite começar com algo simples (uma VNet e uma subnet) e evoluir para:

- Múltiplas VNets (hub‑spoke)
- Subnets específicas para diferentes tipos de workloads (app, data, gestão, etc.)
- Integração com firewalls, gateways VPN, ExpressRoute, etc.

---

## Separação entre módulos e ambiente

Um dos objetivos principais desta landing zone é a **separação clara** entre:

- **Módulos de plataforma** (pasta `modules/`):
	- Cada pasta representa um domínio funcional: management groups, logging, networking, policy, rbac
	- Os módulos expõem variáveis e outputs bem definidos, permitindo reutilização
- **Ambientes** (pasta `platforms/`):
	- `platforms/dev` é um exemplo de ambiente completo
	- No futuro podem existir `platforms/qa`, `platforms/prod`, etc.

Na prática:

- Os módulos não “sabem” que estão em dev, qa ou prod
- A camada de ambiente é responsável por nomes, localizações, tags e integrações

Este padrão torna a solução mais fácil de manter e adequar a diferentes organizações.

---

## Como a estrutura foi pensada para crescer

Alguns exemplos de evoluções futuras suportadas pela arquitetura atual:

- Adicionar novos ambientes apenas criando novas pastas em `platforms/` que reutilizam os mesmos módulos
- Expandir o módulo de networking para topologias hub‑spoke sem quebrar o código existente
- Aumentar o catálogo de policies no módulo de `policy-assignments`, adicionando novos assignments com diferentes scopes
- Criar módulos adicionais (por exemplo, `identity`, `security`, `monitoring`) mantendo a mesma convenção de pastas
- Integrar pipelines de CI/CD que executam Terraform sobre cada ambiente (`platforms/dev`, `platforms/prod`, ...)

Em resumo, a arquitetura foi desenhada para ser **simples hoje**, mas **preparada para crescer amanhã**.

---

## Camadas da arquitetura

Para facilitar a leitura, a arquitetura pode ser vista em três grandes camadas lógicas:

- **Governance layer**
	- Foca‑se em controlo, organização e segurança a nível de tenant/subscrição
	- Inclui:
		- Hierarquia de **Management Groups**
		- **Policy Assignments** (ex.: *Allowed locations*)
		- **RBAC** (role assignments)

- **Platform layer**
	- Agrega serviços partilhados que suportam múltiplos workloads
	- Inclui:
		- **Logging** (Log Analytics Workspace + resource group dedicado)
		- **Networking** (resource group de rede, VNet, subnet principal)

- **Workloads / Future layer**
	- Nesta fundação, é apenas preparada, ainda sem workloads de negócio concretos
	- No futuro, poderá incluir:
		- Subscrições de aplicações
		- VNets adicionais (spokes)
		- Serviços PaaS/IaaS ligados à rede e ao logging existentes

---

## Diagrama – Fluxo de arquitetura (alto nível)

```text
			 ┌───────────────┐
			 │   Terraform   │
			 └───────┬───────┘
				 │
	┌────────────────────────┼────────────────────────┐
	│                        │                        │
┌───────────────┐      ┌───────────────────┐     ┌──────────────────┐
│ Management    │      │ Serviços de       │     │ Governança       │
│ Groups        │      │ Plataforma        │     │ (Policy + RBAC)  │
│               │      │ - Logging         │     │                  │
│               │      │ - Networking      │     │                  │
└───────┬───────┘      └────────┬──────────┘     └────────┬─────────┘
	│                        │                        │
	└──────────────┬─────────┴──────────┬────────────┘
		       │                    │
	       ┌───────────────┐
	       │ Azure Platform│
	       │  Foundation   │
	       └───────┬───────┘
		       │
	       ┌───────────────┐
	       │ Workloads     │
	       │  (Futuros)    │
	       └───────────────┘
```

---

## Diagrama 1 – Visão lógica da Landing Zone

O diagrama seguinte representa, de forma textual, a visão lógica da landing zone tal como suportada pelos módulos atuais:

```text
Tenant Root
│
└── <prefix>-platform                              (Governance + Platform layer)
    │
    ├── Management Groups                          (modules/management-groups)
    │   ├── <prefix>-platform
    │   ├── <prefix>-landing-zones
    │   └── <prefix>-sandbox
    │
    ├── Logging                                    (modules/logging)
    │   ├── Resource Group de logging
    │   └── Log Analytics Workspace
    │
    ├── Networking                                 (modules/networking)
    │   ├── Resource Group de rede
    │   ├── Virtual Network (VNet)
    │   └── Subnet principal
    │
    ├── Governance controls                        (modules/policy-assignments)
    │   └── Policy Assignment (ex.: Allowed locations)
    │
    └── Access control                             (modules/rbac)
	└── Role Assignments opcionais

Workloads futuros                                   (Workloads layer)
└── Subscrições / VNets / serviços de aplicação que consumirão esta fundação
```

---

## Diagrama 2 – Organização do repositório

O repositório está organizado para separar claramente **código reutilizável**, **configuração de ambiente** e **exemplos**:

```text
terraform-azure-landing-zone/
├── modules/                     # Módulos genéricos e reutilizáveis
│   ├── management-groups/       # Hierarquia base de management groups
│   ├── logging/                 # RG de logging + Log Analytics Workspace
│   ├── networking/              # RG de rede + VNet + subnet
│   ├── policy-assignments/      # Atribuição de policies built-in
│   └── rbac/                    # Role assignments simples
│
├── platforms/                   # Configuração de ambientes concretos
│   └── dev/                     # Ambiente de desenvolvimento (dev)
│       ├── main.tf              # Composição dos módulos
│       ├── variables.tf         # Variáveis específicas do ambiente
│       ├── outputs.tf           # Outputs relevantes do ambiente
│       ├── providers.tf         # Providers e versões de Terraform
│       └── backend.tf           # Configuração do backend remoto
│
├── examples/                    # Exemplos mínimos de utilização
│   └── basic-platform/          # Exemplo que consome logging + networking
│       ├── main.tf
│       └── terraform.tfvars.example
│
└── docs/                        # Documentação da solução
		├── architecture.md          # Arquitetura da landing zone
		├── decisions.md             # Decisões de arquitetura (ADR)
		├── deployment-guide.md      # Guia de deployment com Terraform
		└── cost-estimate.md         # Estimativa qualitativa de custos
```

Em resumo:

- `modules/` define **o que** pode ser criado (blocos de construção reutilizáveis)
- `platforms/dev/` define **como** esses blocos são combinados para um ambiente concreto
- `examples/basic-platform/` mostra **um exemplo mínimo** de utilização dos módulos
- `docs/` documenta **a visão, decisões, deployment e custos** da solução


