# Contract — Spec 019

Status: `DRAFT` | Version: 1 | Mode: `CRITICAL` | Human approval: pendente

Execution mode: `SINGLE_WRITER` para schema, contratos, auth/sync/outbox e arquivos compartilhados. `PARALLEL_SAFE` apenas com ownership explícito e até dois writers em paths distintos.

## Objetivo
Dar ao vendedor e à gerência visão confiável de vendas, pendências e crescimento, sem confundir estimativas com valores confirmados.

## Remote contract
Documentação mobile registra /dashboard e sale-intents create/get/confirm; contrato histórico multi-device, campos exatos de totais e propostas precisam auditoria dev Laravel. Sem endpoint ou permissão inventada. Replays devem retornar estado final coerente.

Campos, tipos, IDs, paginação, erros, permissões, tenant scope e idempotência que mudarem precisam de tabela de contrato auditada e SHA do backend antes de FROZEN. Ausência de contrato bloqueia a parte dependente, não autoriza inventar API.

## Local contract
Projeções locais tipadas para venda/resumo/proposta e valores exatos; migrations não destrutivas e versionamento de payload antigo. Paginação/índices no banco, deduplicar ID remoto/local com regra contratada; preservar outbox e histórico.

## UI states
Histórico/Detalhe, filtros, revisão comparativa clara, ação de aceite explícito, valores estimados/confirmados, painel com poucos indicadores e data de atualização; sem informação financeira restrita.

## Allowed paths (propostos, não autorização de escrita)
- lib/features/sales/**, lib/features/dashboard/**, lib/core/database/**, lib/shared/formatters/**
- lib/features/catalog/** somente ajuste monetário coordenado; backend em spec cross-repo separada; test/features/** e migrations.

## Acceptance invariants
- **REQ-019-01** — Histórico local com busca por cliente/identificador, período/status, paginação e detalhe de itens/quantidades; diferenciar local e confirmado; vendas em outros dispositivos só quando sincronizadas por contrato aprovado.
- **REQ-019-02** — Modelar proposta tipada com revisão, itens afetados, quantidade/preço original e proposto, motivos e total; aceitar/rejeitar conscientemente conforme API. Não interpretar proposalJson na UI; se detalhe indisponível, bloquear aceite cego e oferecer reconectar/consultar, sujeito a contrato aprovado.
- **REQ-019-03** — CAS/revisão vigente e aceite explícito; proposta expirada/alterada exige nova revisão. Sem autoaceite, sem reescrever negociação silenciosamente.
- **REQ-019-04** — Valores monetários exatos em centavos inteiros ou decimal contratado, arredondamento e escala explícitos; preservar null/restrição e payloads antigos. Total final vem do servidor; total histórico local é estimativa até reconciliação, nunca rotulado confirmado sem evidência.
- **REQ-019-05** — Gerência: visão compacta por período, vendas confirmadas, vendedores ativos, estoque baixo, pendências conhecidas e evolução; aproveitar dashboard real e permissões. Não apresentar pendências de aparelhos desconectados como contagem global completa; explicitar escopo, fuso, freshness e denominadores.
- **REQ-019-06** — Vendedor vê próprio escopo; gerência só agregados e registros autorizados. Histórico e filtros locais nunca misturam tenant, e cache não concede novas permissões.

## Invariantes transversais
- Page → Controller → UseCase → Repository → DAO/API; domain sem Flutter, application sem Dio/Drift/JSON, presentation sem transporte/persistência.
- Contexto físico userId+tenantId; preço/estoque/autorização/confirmação remotos soberanos; demo isolado; price=null válido quando restrito.
- Nunca apagar pendências ou tratar intenção local como confirmada. Migration, ownership, rota, protocolo e contrato congelado só mudam via Change Request.
- Sem execução local de testes/analyze/format/build/codegen ou equivalentes sem autorização explícita. CI aprovado executa apenas comandos e gatilhos definidos na 015.

## Freeze checklist
- [ ] Auditar backend atual: campos da proposta, totais, IDs e histórico/paginação, quais métricas e permissões existem; bloquear partes ausentes.
- [ ] Definir política de rejeição/cancelamento e precisão/arredondamento com backend; definir significado de cada KPI e landing híbrida.
- [ ] Registrar SHA/base, paths definitivos, matriz de testes, riscos, responsável e aprovação humana.
