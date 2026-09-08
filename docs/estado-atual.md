# Estado e próxima validação — 8 de setembro de 2026

Este documento consolida a execução atual. O ponto de entrada canônico continua
sendo [Contexto operacional](../para%20mobile/00-contexto-operacional.md).

## Situação por frente

| Frente | Código disponível | Pendências para aceite |
| --- | --- | --- |
| Base visual / 001–006 | Shell, tema, catálogo, painel e vendas locais | Revalidar regressões; registros antigos descrevem suas próprias etapas |
| 007 | Dio, ApiClient, erros, Result e redaction | Auditoria anterior não valida a árvore atual; conversor geral NetworkFailure segue pendente |
| 008 / 008B | Pontos de injeção para contexto, acesso e banco | Sessão/token, contrato de login, abertura física isolada e logout não implementados |
| 009A | Schema Drift v1 de catálogo, painel, checkpoints e locks | Resolver dependências, gerar código, analisar e executar testes; não publicado |
| 009B | Engine, mutex, lease com TTL, checkpoints transacionais, lifecycle e estado | Executar testes; logs estruturados ainda pendentes |
| 009C | Coleções de leitura, repositórios Drift, streams autoDispose, controllers e avisos | Decoder real do painel; contexto autenticado; aceite visual/integrado; cursor estável |
| 010 | Spec de outbox | Não implementada; vendas continuam rascunhos em memória |

**009A/B/C não estão aprovadas nem prontas para publicação.** Código escrito,
contrato confirmado e teste executado são estados distintos.

## O que acontece no startup atual

`bootstrap.dart` registra a composição de leitura e o binding de lifecycle.
`operationalDatabaseProvider` é `null` por padrão: nenhuma conexão anônima é
aberta, a engine fica ausente e as telas usam a demonstração existente.

Com banco de contexto validado fornecido, os repositórios mudam para Drift.
O catálogo exige `catalogReadAccessProvider` preenchido com feature/permissões
validadas. O painel usa `dashboardFinancialAccessProvider`; sua coleção HTTP só
é registrada com `dashboardRemoteDecoderProvider` configurado. Não há fallback
para dados fictícios quando o banco real está configurado.

O responsável pela sessão ainda precisa fornecer Dio autenticado/base URL,
gerenciar o arquivo por usuário/tenant e descartar o contexto anterior. Antes de
fechar o banco, deve **aguardar `engine.dispose()`**, depois invalidar o contexto
conforme a 008B. A limpeza automática do provider não substitui essa espera.

## Catálogo e limites do contrato

- `GET /api/mobile/products`, `per_page: 50`, `page`, `sort: created_at`,
  `direction: asc`; `updated_since` somente quando já houver referência confiável.
- Categorias são obtidas dos próprios produtos, sem endpoint adicional.
- Cada página faz upsert de categorias antes de produtos; dados/checkpoint
  ficam na mesma transação protegida pela lease.
- Campos inválidos abortam a página; preço nulo é válido. Preços antigos são
  ocultados na leitura se o acesso financeiro atual estiver revogado.
- `page` é offset, não cursor estável. Cada nova execução reinicia a janela na
  página 1; o offset salvo serve como progresso, não como garantia de retomada.
- O filtro `updated_since` permanece fixo durante a janela. Não se promove
  `max(updated_at)` ou horário do dispositivo a watermark remoto. Sem referência
  confiável, as próximas execuções repetem a leitura completa por upsert.
- Não há tombstones nem snapshot estável documentados. Ausência em uma resposta
  não apaga produtos; mudanças concorrentes ainda exigem reconciliação futura.

## Painel: o que falta do backend

O contrato documenta o envelope, mas não as chaves/tipos internos de `kpis`,
`low_stock_alert`, movimentos e gráficos. Foi solicitado payload anonimizado ou
caminho do backend; esse conteúdo não estava disponível nesta execução.

`DashboardRemoteDataSource` consome o endpoint existente e valida envelope e
coerência financeira. `DashboardRemoteDecoder` é um contrato sem implementação
real: os testes usam um dublê explícito, que não define o contrato HTTP.

A persistência já substitui KPIs, alertas e detalhes atomicamente. Os detalhes
têm formato JSON **local** v1 baseado nas entidades atuais; não são um payload
remoto presumido. Após confirmar o contrato, implementar o decoder, conferir
mascaramento de todos os blocos e registrá-lo no contexto autenticado.

## Estados e ciclo de vida

- Controllers e streams de catálogo/painel usam autoDispose.
- A UI recebe alterações locais sem refresh manual; refresh solicita a engine.
- Falha de rede/servidor mantém cache com aviso. Sem cache há estado acionável.
- `401`/`403` bloqueiam a leitura visual. A engine mantém a negação até ser
  recomposta por contexto revalidado, inclusive se a tela for remontada.
- Observer dispara bootstrap/retomada quando há engine. Retomada respeita mais
  de cinco minutos desde o término; refresh manual ignora cooldown.
- Desmontar o consumidor cancela sua assinatura. A shell com IndexedStack pode
  manter abas montadas: trocar de aba não equivale a desmontar a tela.

## Validação realmente executada nesta sessão

- `git diff --check`, sem erros.
- Inspeção textual de imports e fronteiras de camada via Python.
- SQL do lock extraído do adaptador e exercitado com SQLite/Python na etapa 009B.

Essas verificações **não** comprovam compilação Dart, funcionamento dos bindings
Drift, comportamento Riverpod ou ausência de overflow.

Dart e Flutter não estão instalados. Não foram executados `flutter pub get`,
geração Drift, `dart format`, `flutter analyze`, testes Flutter nem inspeção visual.
O `pubspec.lock` permanece anterior à inclusão do Drift; não foi editado à mão.

## Próxima sessão com SDK

Na raiz, resolver e gerar antes de tentar compilar:

```sh
flutter pub get
dart run build_runner build
dart format lib test
flutter analyze
flutter test test/core/database test/core/sync
flutter test test/features/catalog test/features/dashboard test/features/reading_reactivity_test.dart
flutter test test/app test/architecture test/shared test/theme
flutter test
```

Revisar/versionar o lockfile resolvido. O `app_database.g.dart` deve ser gerado;
não foi escrito manualmente. O schema v1 nunca foi publicado nesta execução.
Se houver banco anterior já distribuído, preparar migração aditiva e teste de
preservação antes de habilitar a integração.

Validar em aparelho: catálogo/painel em 320px e texto 2x; cache após reinício;
refresh com rede desligada; falha parcial; 401/403; desmontagem de consumidor;
nenhum overflow horizontal. Não regenerar goldens sem inspecionar diferenças.

## Ordem de continuação

1. Gerar, formatar, analisar e corrigir os testes escritos.
2. Obter contrato completo do painel e implementar o decoder real.
3. Concluir sessão/isolamento da 008/008B e configurar o contexto autenticado.
4. Validar bootstrap, leitura offline, troca de usuário e teardown no dispositivo.
5. Confirmar cursor/watermark/tombstones antes de habilitar delta com avanço.
6. Revisar logs e publicar somente após aceite; outbox permanece outra entrega.
