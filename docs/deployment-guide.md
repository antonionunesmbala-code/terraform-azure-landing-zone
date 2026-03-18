# Guia de Deploy – Azure Landing Zone com Terraform

Este guia descreve, passo a passo, como fazer o deploy da landing zone utilizando o ambiente **dev** em `platforms/dev`.

O objetivo é garantir que qualquer pessoa com os pré‑requisitos consegue replicar o deployment de forma consistente.

---

## 1. Pré-requisitos

Antes de começar, certifica‑te de que tens:

- Conta Azure ativa
- **Azure CLI** instalada
- **Terraform** instalado (versão >= 1.5)
- Permissões suficientes na Azure para:
	- Criar resource groups, VNets e Log Analytics Workspaces na subscription
	- (Opcional) Criar management groups e atribuir policies, se quiseres usar essas funcionalidades

Autenticar na Azure:

```bash
az login
az account show           # confirma qual a subscription ativa
```

Se necessário, seleciona a subscription correta:

```bash
az account set --subscription "<subscription-id-ou-nome>"
```

---

## 2. Clonar o repositório

```bash
git clone https://github.com/<teu-utilizador>/terraform-azure-landing-zone.git
cd terraform-azure-landing-zone
```

---

## 3. Preparar o backend remoto (estado Terraform)

O projeto está configurado para usar um backend `azurerm` no ambiente dev, definido em `platforms/dev/backend.tf`.

Antes de correr o Terraform, cria:

- Um **Resource Group** para o estado (por exemplo, `rg-tfstate-dev`)
- Uma **Storage Account** (por exemplo, `stterraformdev0001`)
- Um **contentor** de blobs (por exemplo, `tfstate`)

Exemplo de criação (ajustar nomes, localização e SKU conforme necessário):

```bash
az group create -n rg-tfstate-dev -l westeurope

az storage account create \
	-g rg-tfstate-dev \
	-n stterraformdev0001 \
	-l westeurope \
	--sku Standard_LRS

az storage container create \
	--account-name stterraformdev0001 \
	-n tfstate
```

O ficheiro `backend.tf` já contém um exemplo de configuração para este cenário; ajusta apenas se usares outros nomes.

---

## 4. Configurar variáveis do ambiente dev

A configuração do ambiente dev vive em `platforms/dev`.

```bash
cd platforms/dev
cp terraform.tfvars.example terraform.tfvars
```

Edita o ficheiro `terraform.tfvars` e define pelo menos:

```hcl
location    = "westeurope"   # Região onde os recursos serão criados
prefix      = "alz"          # Prefixo comum a recursos de plataforma
environment = "dev"          # Nome do ambiente

# Opcional: management group pai (se já existir uma hierarquia acima)
# management_group_parent_id = "/providers/Microsoft.Management/managementGroups/<id-root>"

# Opcional: role assignments para RBAC (exemplo comentado no ficheiro)
```

> Nota: As convenções de nomes dos resource groups, VNets e workspaces são derivadas destas variáveis na camada Terraform (`main.tf`), mantendo o ficheiro de variáveis simples.

---

## 5. Inicializar Terraform

Ainda na pasta `platforms/dev`:

```bash
terraform init
```

Este comando:

- Configura o backend remoto
- Faz o download dos providers `azurerm` e `azuread`

---

## 6. Validar a configuração

```bash
terraform validate
```

Este passo garante que a sintaxe está correta e que não há erros óbvios na configuração.

---

## 7. Gerar o plano (plan)

```bash
terraform plan
```

Revisa o plano gerado e confirma:

- Criação da hierarquia de management groups (se configurada)
- Criação dos resource groups de logging e networking
- Criação do Log Analytics Workspace
- Criação da VNet e subnets
- Criação de policy assignments e role assignments (se configurados)

Se tudo estiver conforme o esperado, avança para o apply.

---

## 8. Aplicar as alterações (apply)

```bash
terraform apply
```

Revê o plano final apresentado e confirma quando solicitado. No final, o Terraform mostrará os **outputs** definidos em `platforms/dev/outputs.tf`, que incluem IDs e nomes relevantes (management groups, workspace, VNet, subnets, etc.).

---

## 9. Observações sobre permissões

- **Management Groups**:
	- Para criar ou gerir management groups é normalmente necessário ter permissões a nível de tenant root ou de um management group superior (por exemplo, `Owner` ou `Management Group Contributor`)
- **Policy Assignments**:
	- Para atribuir policies a nível de subscription ou management group é necessário ter permissões como `Owner` ou `Policy Contributor` nesse scope
- **RBAC**:
	- A criação de role assignments requer permissões de `Owner` ou papel equivalente no scope alvo

Se não tiveres estas permissões, podes comentar temporariamente os blocos de módulo relacionados (management-groups, policy-assignments, rbac) no `platforms/dev/main.tf` e focar apenas em logging e networking.

---

## 10. Limpeza (destroy)

Quando quiseres remover os recursos criados pelo ambiente dev:

```bash
terraform destroy
```

Certifica‑te de que estás na pasta `platforms/dev` e usa com cuidado, pois todos os recursos geridos por este estado serão eliminados.

