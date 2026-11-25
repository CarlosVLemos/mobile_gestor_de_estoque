# Contract — Spec 022

Status: `DRAFT` | Version: 1 | Mode: `STANDARD (CRITICAL para coleta de dados pessoais/contrato)` | Human approval: pendente

Execution mode: `SINGLE_WRITER` para schema, contratos, auth/sync/outbox e arquivos compartilhados. `PARALLEL_SAFE` apenas com ownership explícito e até dois writers em paths distintos.

## Objetivo
Medir saúde operacional, adoção e desempenho com dados úteis e mínimos, sem transformar telemetria em vigilância ou sobrecarregar a rede.

## Remote contract
Nenhum endpoint de telemetria assumido. Maquiavel valida ingestão/autorização e quotas se necessário; contrato de métricas comerciais da 019 permanece separado.

Campos, tipos, IDs, paginação, erros, permissões, tenant scope e idempotência que mudarem precisam de tabela de contrato auditada e SHA do backend antes de FROZEN. Ausência de contrato bloqueia a parte dependente, não autoriza inventar API.

## Local contract
Interface de observabilidade sem dependência de vendor no domínio; fila limitada e separada da outbox comercial, descarte seguro somente de telemetria; sem migração de vendas para analytics.

## UI states
Gerência vê indicadores comerciais autorizados; equipe técnica acessa saúde operacional separada. Suporte mostra versão e status de sync, sem log bruto ou identificadores sensíveis.

## Allowed paths (propostos, não autorização de escrita)
- lib/core/sync/**, lib/core/network/**, lib/app/** e módulo de observabilidade a definir
- lib/features/sales/** somente instrumentação contratada, docs/engineering/**, test/**; coordenação com 016 e 020.

## Acceptance invariants
- **REQ-022-01** — Definir eventos tipados mínimos: início/fim sync, resultado/categoria de falha, duração, contagem de operações conhecidas, versão e jornada de venda (duração/resultado, sem identificação de cliente/produto). Separar logs técnicos de métricas comerciais.
- **REQ-022-02** — Métricas: taxa de conclusão de tarefa, p50/p95 de busca e sync, falhas por categoria, idade de pendência conhecida, replay/duplicação, versões em uso e falha de startup. Cada uma com denominador, janela, fonte, cobertura e tratamento de dados ausentes.
- **REQ-022-03** — Offline: armazenar somente eventos mínimos com fila limitada por tamanho/idade; backoff e envio em lote; telemetria nunca bloqueia venda, auth ou outbox; dados não enviados não contam como zero global.
- **REQ-022-04** — Manter cardinalidade baixa, sem IDs de pessoas/tenants em labels públicos; restringir acesso, retenção e agregação conforme 020; não usar dados reais em CI.
- **REQ-022-05** — Baseline piloto: p95 busca <=300ms com 10 mil produtos e aparelho definido, venda cinco itens <=90s como hipótese, zero duplicação/perda nos cenários E2E. Medir antes de alertar; alertas com dono e ação.
- **REQ-022-06** — Visão gerencial simples (019) consome métricas comerciais do servidor, não eventos de analytics; operação técnica fica em painel separado para equipe. Capacidade: medir volume, tempo e consumo com dataset sintético; não pressupor necessidade de microsserviço.

## Invariantes transversais
- Page → Controller → UseCase → Repository → DAO/API; domain sem Flutter, application sem Dio/Drift/JSON, presentation sem transporte/persistência.
- Contexto físico userId+tenantId; preço/estoque/autorização/confirmação remotos soberanos; demo isolado; price=null válido quando restrito.
- Nunca apagar pendências ou tratar intenção local como confirmada. Migration, ownership, rota, protocolo e contrato congelado só mudam via Change Request.
- Sem execução local de testes/analyze/format/build/codegen ou equivalentes sem autorização explícita. CI aprovado executa apenas comandos e gatilhos definidos na 015.

## Freeze checklist
- [ ] Escolher transporte e destino de telemetria de acordo com infraestrutura/custo/privacidade; MVP pode usar evidência local e backend existente se adequado.
- [ ] Definir retenção, consentimento/base legal aplicável, acesso e limiares após baseline; nenhuma coleta remota antes da aprovação.
- [ ] Registrar SHA/base, paths definitivos, matriz de testes, riscos, responsável e aprovação humana.
