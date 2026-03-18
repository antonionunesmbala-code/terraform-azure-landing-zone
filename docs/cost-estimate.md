# Estimativa de Custos – Azure Landing Zone (Fundação)

Este documento apresenta uma visão qualitativa dos **custos potenciais** associados à implementação desta Azure Landing Zone de fundação.

O objetivo não é substituir a calculadora oficial da Azure, mas sim:

- Identificar **quais os componentes que podem gerar custos**
- Distinguir **recursos com custo direto** de **recursos sem custo direto**
- Dar recomendações para **manter custos baixos em ambiente de testes/portefólio**

> Importante: os valores exatos dependem sempre da região, tipo de subscrição, volume de utilização e acordos comerciais. Para decisões reais, deve ser usada a **Calculadora de Preços oficial da Azure**.

---

## Componentes atualmente implementados

A solução, tal como implementada neste repositório, inclui os seguintes tipos de componentes:

- **Management Groups** (hierarquia base)
- **Resource Groups** (logging, networking)
- **Log Analytics Workspace** (logging centralizado)
- **Virtual Network (VNet)**
- **Subnet**
- **Policy Assignments** (por exemplo, *Allowed locations*)
- **RBAC / Role Assignments**

---

## Recursos sem custo direto

Alguns recursos utilizados nesta fundação **não têm custo direto** associado, embora possam influenciar como outros recursos são cobrados:

- **Management Groups**
  - Servem para organizar subscrições e aplicar governance
  - Não são faturados como recurso separado

- **Resource Groups**
  - São apenas contentores lógicos para recursos
  - Não têm custo direto

- **RBAC / Role Assignments**
  - Atribuir permissões (roles) não tem custo direto
  - O custo está associado aos recursos a que estas permissões dão acesso, não ao RBAC em si

- **Policy Assignments (Azure Policy)**
  - A própria atribuição de policies, principalmente nesta fundação simples (por exemplo, *Allowed locations*), não gera custo direto
  - O impacto pode ser indireto (impedir criação de recursos em regiões mais caras, por exemplo), mas não há cobrança pelo assignment em si

- **Virtual Network (VNet) e Subnet**, na forma básica aqui usada
  - Uma VNet e subnets simples, sem gateways VPN, ExpressRoute, NAT ou outros serviços associados, **não costumam gerar custo direto significativo**
  - O custo surge quando se ligam outros serviços à rede (por exemplo, tráfego entre regiões, gateways, appliances de rede, etc.)

---

## Recursos com potencial de custo

O principal componente com potencial de custo direto nesta fundação é:

- **Log Analytics Workspace**
  - Custo baseado tipicamente em **ingestão de dados** (GB/mês) e **retenção** (número de dias)
  - Mesmo em ambientes de demonstração, algum custo pode existir, embora geralmente baixo se o volume de logs for reduzido

Outros aspetos a considerar:

- Tráfego de rede entre regiões ou para fora da Azure **não é diretamente configurado neste projeto**, mas pode gerar custos se forem adicionados workloads reais
- Qualquer recurso adicional criado manualmente e configurado para enviar logs para o workspace (VMs, App Services, AKS, etc.) vai contribuir para o volume de dados ingeridos

---

## Tabela qualitativa de custos

A tabela seguinte resume, de forma qualitativa, os tipos de custo por componente já implementado.

| Componente              | Tipo de custo          | Observação                                                                 |
|-------------------------|------------------------|----------------------------------------------------------------------------|
| Management Groups       | Sem custo direto       | Organização e governance a nível de tenant/subscrição.                    |
| Resource Groups         | Sem custo direto       | Contentores lógicos de recursos.                                          |
| Log Analytics Workspace | Custo de ingestão/armazenamento | Depende do volume de dados enviados e da retenção configurada. |
| Virtual Network         | Normalmente sem custo direto na configuração base | Custo surge com serviços ligados e tráfego específico. |
| Subnet                  | Sem custo direto       | Partilha o modelo de custos da VNet e dos recursos associados.            |
| Policy Assignments      | Sem custo direto       | Define regras; não é cobrada como recurso individual nesta fundação.      |
| RBAC (Role Assignments) | Sem custo direto       | Controla acessos; custo está nos recursos alvo, não nas permissões.       |

> Nota: Esta tabela é qualitativa e não substitui uma análise detalhada em contexto de produção.

---

## Como reduzir custos em ambiente de testes

Para um ambiente de **demonstração ou portefólio**, o objetivo é manter o custo o mais baixo possível, garantindo ainda assim um deployment realista. Algumas recomendações:

- **Usar baixo volume de logs**
  - Evitar ligar grandes quantidades de recursos em produção real ao Log Analytics Workspace
  - Ligar apenas alguns recursos de teste, se necessário, e durante um período limitado

- **Evitar retenção longa**
  - Usar períodos de retenção mais curtos no workspace (por exemplo, 30 dias ou menos) para reduzir custos de armazenamento

- **Destruir recursos após testes**
  - Após gerar as evidências necessárias para o portefólio (por exemplo, capturas de ecrã, excertos de `terraform plan/apply`, documentação), considerar correr `terraform destroy` no ambiente `dev`
  - Isto elimina recursos e evita custos recorrentes

- **Não adicionar componentes pagos desnecessários**
  - Nesta fase de fundação, evitar adicionar serviços como gateways VPN, firewalls, bases de dados geridas ou instâncias de computação persistentes
  - Se forem necessários para demonstração, criar recursos pequenos e temporários

---

## Nota final

Esta estimativa é **qualitativa** e focada no desenho atual deste repositório. Os custos reais vão depender de fatores como:

- Região Azure utilizada
- Volume de dados enviados para o Log Analytics Workspace
- Período de retenção configurado
- Recursos adicionais ligados a esta landing zone

Para qualquer planeamento de custos em cenário real, deve ser utilizada a **[Calculadora de Preços oficial da Azure](https://azure.microsoft.com/pricing/calculator/)**, parametrizada com os recursos concretos do ambiente em questão.
