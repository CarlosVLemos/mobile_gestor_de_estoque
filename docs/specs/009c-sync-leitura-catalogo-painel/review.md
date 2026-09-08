# Spec 009C — Revisão da execução

## Status em 8 de setembro de 2026

Execução autorizada pelo usuário, substituindo o gate histórico. Implementação
parcial com código e testes escritos; não aprovada, não validada com SDK.

## Código entregue

- ProductRemoteDataSource via ApiClient, com `per_page: 50`, validação de páginas,
  produtos/categorias, preços anuláveis e erros seguros para a engine.
- ProductSyncCollection: upsert em lote, categorias antes de produtos, checkpoint
  na mesma transação protegida pela lease.
- DriftProductRepository: stream local reativa, busca/filtro local e máscara
  financeira orientada por acesso validado injetado.
- DashboardRemoteDataSource/SyncCollection: envelope existente, decoder exigido
  por injeção e substituição transacional de KPIs/alertas/snapshot/checkpoint.
- DashboardLocalStore e DriftDashboardRepository: leitura local reativa e
  proteção contra snapshot financeiro antigo em perfil restrito.
- Casos de uso/StreamProviders e controllers autoDispose, cancelamento de
  assinatura no descarte e proteção contra resultados atrasados de filtro.
- Atualizações do banco refletem na UI; refresh chama a engine; avisos de sync
  mantêm cache; 401/403 bloqueiam leitura e não são tratados como offline.
- Bootstrap registra ReadSyncScope: engine e observer somente com banco/contexto
  fornecido. Sem contexto, o modo demonstrativo atual permanece explícito no código.

## Limites que impedem conclusão integral

1. Falta o contrato interno do dashboard. DashboardRemoteDecoder não tem
   implementação real e a coleção não é registrada sem ele. Foi solicitado
   payload anonimizado/caminho do backend; indisponível nesta execução.
2. Sessão, arquivo por usuário/tenant e fechamento/invalidação em logout
   permanecem na 008/008B. O provider de banco não abre banco anônimo.
3. A API por page não promete snapshot/cursor estável. Cada execução repete a
   janela desde página 1 com filtro fixo. Nenhum timestamp máximo/local vira
   watermark. Sem referência confiável, repetem-se leituras completas por upsert.
4. Não há tombstones: ausência em resposta não apaga produtos.
5. Sem Dart/Flutter, dependências/geração/formatação/análise/testes e validação
   visual não executados. O aceite da 009C continua aberto.

## Testes escritos

- `product_sync_test.dart`: paginação, replay após falha, upsert, preço nulo,
  updated_since fixo, payload inválido, HTTP 401/403/429/500 e stream local.
- `dashboard_sync_test.dart`: substituição/remoção de snapshot, rollback,
  cache offline, restrição financeira e stream. Decoder é dublê, não contrato HTTP.
- `reading_reactivity_test.dart`: telas reativas, cache com aviso, 401/403,
  descarte de assinaturas e catálogo em 320px/texto 2x.
- Testes existentes dos controllers adaptados para manter consumidores durante
  sua execução, pois agora os providers são autoDispose.

## Evidência e continuidade

`git diff --check` e inspeção textual de imports/fronteiras executados sem erros.
Não equivalem a analyze/testes. Roteiro consolidado, composição e dependências em
[estado atual](../../estado-atual.md). Histórico anterior não comprova esta árvore.
