# Decisões de Arquitetura (ADR)

Este documento regista as principais decisões técnicas e de arquitetura tomadas para esta Azure Landing Zone.

Cada decisão é descrita de forma resumida, com foco em clareza e na preparação para evolução futura.

---

## ADR-001 – Uso de Terraform como IaC

**Decisão**  
Utilizar **Terraform** como ferramenta principal de Infrastructure as Code.

**Motivação**

- Amplamente utilizado na indústria e reconhecido em portefólios técnicos
- Ecosistema maduro de módulos e integrações com Azure
- Linguagem declarativa simples de ler e rever em código

**Consequências**

- Facilita a automatização de ambientes Azure
- Permite reutilização de módulos entre ambientes (dev, qa, prod)
- Requer gestão adequada de estado (backend remoto)

---

## ADR-002 – Estrutura modular por domínio

**Decisão**  
Organizar o código em módulos separados por domínio funcional em `modules/`:

- `management-groups`
- `logging`
- `networking`
- `policy-assignments`
- `rbac`

**Motivação**

- Promover reutilização entre ambientes
- Facilitar leitura e manutenção do código
- Permitir evolução independente de cada domínio (por exemplo, networking pode ficar mais complexo sem impactar logging)

**Consequências**

- Aumenta a clareza da solução
- Impõe uma disciplina de interfaces bem definidas (variáveis e outputs)

---

## ADR-003 – Ambiente dev separado em `platforms/dev`

**Decisão**  
Criar um ambiente **dev** dedicado em `platforms/dev`, que compõe os módulos da pasta `modules/`.

**Motivação**

- Ter um exemplo de utilização completo e funcional
- Isolar a configuração específica de ambiente (nomes, localizações, tags) dos módulos genéricos
- Permitir que, no futuro, novos ambientes (`platforms/qa`, `platforms/prod`) reutilizem a mesma base

**Consequências**

- Fica claro o que é “plataforma” (módulos) vs “ambiente” (platforms/dev)
- Facilita demonstração em contexto de portefólio

---

## ADR-004 – Uso de backend remoto em Azure Storage

**Decisão**  
Configurar o estado Terraform (`terraform state`) num backend remoto do tipo **azurerm**, usando Azure Storage.

**Motivação**

- Evitar perda de estado em máquinas locais
- Permitir colaboração futura em equipa
- Alinhar com boas práticas de produção

**Consequências**

- Requer criação prévia de resource group, storage account e contentor
- Exige configuração correta das credenciais da Azure CLI

---

## ADR-005 – Convenção de naming simples com prefixo + ambiente

**Decisão**  
Adotar uma convenção de nomes baseada em:

```text
<prefix>-<environment>-<componente>
```

Exemplos:

- `alz-dev-logging-rg`
- `alz-dev-network-rg`
- `alz-dev-vnet`

**Motivação**

- Facilitar identificação rápida do ambiente e propósito do recurso
- Manter nomes curtos e profissionais
- Preparar o caminho para naming mais rigoroso no futuro (por exemplo, incluindo localização, tipo de recurso, etc.)

**Consequências**

- Torna o ambiente dev legível e organizado
- Pode ser refinado em ambientes enterprise sem quebrar a estrutura base

---

## ADR-006 – Foco em fundação, não em cenário enterprise completo

**Decisão**  
Implementar **fundação mínima funcional**, em vez de tentar replicar a totalidade de uma Azure Landing Zone enterprise.

**Motivação**

- Manter o projeto focado, claro e didático
- Evitar sobrecarga de complexidade desnecessária para objetivos de portefólio
- Garantir que o código é fácil de entender e adaptar

**Consequências**

- Alguns aspetos avançados (por exemplo, hub‑spoke completo, identity centralizada, políticas de segurança complexas) ficam preparados para evolução futura, mas não totalmente implementados
- A estrutura de módulos e ambientes já suporta estas evoluções sem alterações de raiz

---

## ADR-007 – Providers azurerm e azuread

**Decisão**  
Utilizar os providers **azurerm** e **azuread** como base para interação com Azure Resource Manager e Azure Active Directory.

**Motivação**

- azurerm: gestão de recursos de infraestrutura (resource groups, VNets, Log Analytics, policies, role assignments)
- azuread: preparado para cenários onde seja necessário resolver utilizadores, grupos ou service principals

**Consequências**

- O projeto está pronto para evoluir para cenários com dependências fortes de Azure AD
- Em fases iniciais, o uso de azuread pode ser limitado ou apenas opcional

