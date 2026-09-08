# Mapa do Projeto

Atualizado em 8 de setembro de 2026. A entrada canônica é
[Contexto operacional](para%20mobile/00-contexto-operacional.md); o estado completo
e o roteiro da próxima sessão estão em [docs/estado-atual.md](docs/estado-atual.md).

## Estado atual

A base visual Flutter já existe. Dio está implementado; 009A/B/C acrescentam
schema Drift, engine, lease persistida, coleções e repositórios reativos.
Esse código ainda não foi gerado/analisado/testado com o SDK nesta execução.

O startup usa fixtures enquanto não receber banco/contexto autenticado.
Com contexto injetado, catálogo e painel leem Drift. O catálogo possui fonte
HTTP paginada; o painel ainda exige um decoder real do contrato interno.
Sessão, isolamento físico, outbox e vendas remotas continuam pendentes.

A referência local está em `main`, com mudanças da 009 não commitadas. Não usar
fotografias de junho como prova do estado remoto ou de validação atual.

## Mapa por responsabilidade

| Área | Conteúdo |
| --- | --- |
| `lib/app` | Router, shell, tema, startup e composição `sync/` |
| `lib/core/network` | ApiClient/Dio, redaction e conversão de falhas para sync |
| `lib/core/database` | Schema v1, providers de contexto, lease e checkpoints Drift |
| `lib/core/sync` | Engine, contratos, mutex, lifecycle e estado reativo |
| `lib/features/catalog` | Fonte HTTP, upsert, repositório local, filtros e controller |
| `lib/features/dashboard` | Contrato de decoder, snapshot local, repositório e controller |
| `lib/features/sales` | Carrinho e rascunhos em memória, sem outbox |
| `lib/features/settings` | Contexto e navegação demonstrativos |
| `lib/shared` | Widgets e formatação, sem acesso a dados de features |
| `test/core` | Rede, banco, locks e engine |
| `test/features` | Repositórios, coleções, controllers e reatividade de telas |
| `test/architecture` | Fronteiras de camada |
| `test/goldens` | Baselines visuais históricos, a revalidar |
| `docs/specs` | Especificações, tarefas, revisões e testes por etapa |
| `para mobile` | Fontes canônicas de produto, contratos e processo |

## Leituras por tarefa

Siga `AGENTS.md`. Não é necessário ler toda a documentação por padrão.

- Arquitetura: documentos 05 e 06.
- Negócio/offline: documento 04.
- Interface: documento 02; blueprint `designmobile.md` só para trabalho amplo.
- Integração: documento 03 e revisão da spec correspondente.
- Processo/handoff: documento 08 e `docs/estado-atual.md`.
- Ferramentas externas: documento 07; GitHub MCP/Connector seguem suspensos.

Use `rg --files` para a árvore real. `tree.txt`, quando presente, é um retrato
manual e pode não conter os arquivos recentes.
