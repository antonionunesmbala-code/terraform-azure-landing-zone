# Azure Landing Zone Foundation com Terraform

## Visão geral

Este repositório contém uma implementação inicial de uma **Azure Landing Zone** utilizando **Terraform**, focada em boas práticas, modularidade e clareza de código.

O objetivo é disponibilizar uma fundação reutilizável para ambientes Azure, adequada para portefólio técnico e pronta para evolução para cenários mais complexos (multi‑ambiente, hub‑spoke, CI/CD, etc.).

---

## Objetivo do projeto

Este projeto foi construído para:

- Demonstrar competências em **Azure** e **Terraform**
- Fornecer uma base de **Landing Zone** simples mas realista
- Separar claramente **módulos de plataforma** de **configuração de ambiente**
- Servir de ponto de partida para uma Landing Zone empresarial mais completa

---

## Estrutura do repositório

```text
terraform-azure-landing-zone/
├── docs/                    # Documentação (arquitetura, decisões, guia de deployment)
├── modules/                 # Módulos Terraform reutilizáveis
│   ├── logging/             # Resource group + Log Analytics Workspace
│   ├── management-groups/   # Hierarquia base de management groups
│   ├── networking/          # Resource group + VNet + subnets
│   ├── policy-assignments/  # Atribuição de policies a subscription/MG
│   └── rbac/                # Role assignments reutilizáveis
├── platforms/
│   └── dev/                 # Composição principal dos módulos para ambiente dev
├── examples/
│   └── basic-platform/      # Exemplo mínimo de consumo de módulos
├── LICENSE
├── README.md
└── .gitignore
```

---

## Arquitetura

A arquitetura desta landing zone é organizada em três camadas principais:

- **Governance layer**: hierarquia de management groups, assignments de Azure Policy (ex.: *Allowed locations*) e RBAC básico
- **Platform layer**: serviços partilhados de plataforma, como logging centralizado (Log Analytics Workspace) e rede base (VNet + subnet)
- **Workloads / future layer**: camada preparada para, no futuro, receber subscrições e workloads de negócio que consumirão esta fundação

Os módulos em `modules/` representam blocos de construção para estas camadas, enquanto `platforms/dev/` mostra um exemplo concreto de composição para um ambiente de desenvolvimento.

Para uma descrição detalhada da arquitetura, ver:

- [docs/architecture.md](docs/architecture.md)

---

## Custos

Esta fundação utiliza principalmente recursos sem custo direto (management groups, resource groups, VNet/Subnet simples, RBAC, Azure Policy) e **um Log Analytics Workspace**, que é o principal ponto potencial de custo, dependendo do volume de dados ingeridos e da retenção configurada.

Em contexto de demonstração/portefólio, com baixo volume de logs e retenção moderada, o custo tende a ser reduzido, especialmente se os recursos forem destruídos após os testes.

Para uma análise qualitativa mais detalhada e recomendações de otimização em ambiente de testes, ver:

- [docs/cost-estimate.md](docs/cost-estimate.md)

---

## Tecnologias utilizadas

- **Terraform** (>= 1.5)
- **Provider azurerm** (recursos de Azure Resource Manager)
- **Provider azuread** (integração opcional com Azure AD)
- **Azure CLI** para autenticação e configuração de contexto

---

## Componentes implementados

- Hierarquia base de **Management Groups**
- **Logging** centralizado com Log Analytics Workspace
- **Networking** base com VNet e subnets
- **Policy Assignments** simples (por exemplo, *Allowed locations*)
- **RBAC** com criação de role assignments parametrizáveis
- Ambiente **dev** funcional em `platforms/dev`
- Exemplo mínimo em `examples/basic-platform`

---

## Instruções de utilização (ambiente dev)

### 1. Pré-requisitos

- Conta Azure ativa
- **Azure CLI** instalada (`az`)
- Permissões suficientes para:
  - Criar resource groups, VNets e Log Analytics Workspaces na subscription
  - Opcional: criar management groups e atribuir policies (normalmente a nível de tenant ou root management group)
- **Terraform** instalado (>= 1.5)

Autenticar na Azure:

```bash
az login
az account show           # confirmar subscription em uso
```

### 2. Preparar o backend remoto (estado Terraform)

O ficheiro `platforms/dev/backend.tf` assume um backend do tipo `azurerm`. Antes de correr o Terraform, garante que existe:

- Um resource group para o estado (por exemplo, `rg-tfstate-dev`)
- Uma storage account (por exemplo, `stterraformdev0001`)
- Um contentor de blobs (por exemplo, `tfstate`)

Exemplo (ajustar nomes à tua realidade):

```bash
az group create -n rg-tfstate-dev -l westeurope
az storage account create -g rg-tfstate-dev -n stterraformdev0001 -l westeurope --sku Standard_LRS
az storage container create --account-name stterraformdev0001 -n tfstate
```

### 3. Configurar variáveis do ambiente dev

Dentro da pasta `platforms/dev`:

```bash
cd platforms/dev
cp terraform.tfvars.example terraform.tfvars
```

Editar `terraform.tfvars` com os valores desejados:

```hcl
location    = "westeurope"
prefix      = "alz"
environment = "dev"

# Opcional: definir o management group pai (se existir)
# management_group_parent_id = "/providers/Microsoft.Management/managementGroups/<id-root>"
```

### 4. Inicializar e validar Terraform

```bash
terraform init
terraform validate
```

### 5. Plan e apply

```bash
terraform plan
terraform apply
```

Após o `apply`, serão criados:

- Management groups base (se configurados)
- Resource groups de logging e networking
- Log Analytics Workspace
- VNet e subnets definidas
- Policy assignment simples (por exemplo, *Allowed locations*)
- Role assignments definidos em `rbac_role_assignments` (se existirem)

---

## Pré-requisitos resumidos

- Azure CLI autenticada (`az login`)
- Terraform >= 1.5 instalado
- Permissões adequadas na Azure subscription e, se aplicável, a nível de management groups

---

## Documentação complementar

Este repositório inclui documentação adicional que ajuda a enquadrar a solução:

- [docs/architecture.md](docs/architecture.md) – Arquitetura lógica e organização por camadas
- [docs/decisions.md](docs/decisions.md) – Decisões de arquitetura (ADR)
- [docs/deployment-guide.md](docs/deployment-guide.md) – Guia passo a passo de deployment
- [docs/cost-estimate.md](docs/cost-estimate.md) – Estimativa qualitativa de custos e recomendações

---

## Roadmap

- Adicionar novos ambientes (por exemplo, `platforms/prod` e `platforms/qa`)
- Evoluir o módulo de networking para topologia hub‑spoke
- Expandir o catálogo de policies (segurança, compliance, tagging obrigatória)
- Integrar diagnóstico e logging adicionais (Activity Logs, Diagnostic Settings)
- Adicionar pipeline de CI/CD (por exemplo, GitHub Actions ou Azure DevOps)

---

## Autor

**António Nunes Mbala**  
Cloud & DevOps Engineer

Se tiveres sugestões de melhoria ou quiseres discutir o desenho da landing zone, abre uma issue ou cria um pull request.

---

Este repositório pretende ser uma base **simples, funcional e profissional** para demonstrar competências em Azure Landing Zones com Terraform, mantendo espaço claro para evolução futura.

