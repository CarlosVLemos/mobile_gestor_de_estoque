# Contexto Rápido

## Estado real agora

- Flutter com Riverpod, go_router, Dio e arquitetura por feature/camada.
- Shell operacional com Painel, Produtos, Vendas e Mais.
- Spec 007 concluída: core de rede, redaction, erros tipados e `Result`.
- Spec 008 concluída e mergeada na `dev`: autenticação Sanctum real, `flutter_secure_storage`, login, logout, `/me`, troca obrigatória de senha, restauração de sessão, `401` global e guards de rota.
- `API_BASE_URL` é configurável por `--dart-define`.
- Dashboard, catálogo, clientes e vendas ainda não formam o fluxo local-first real de produção.

## Próximos gaps estruturais

- 008B: isolamento de contexto por usuário + tenant e lifecycle de recursos locais.
- 009A: Drift/schema/migrações.
- 009B: motor de sync incremental.
- 009C: leituras reais de dashboard, catálogo e clientes.
- 010: outbox + `sale-intents` + confirmação/reconciliação.
- release: INTERNET/configuração de ambiente, VPS/HTTPS, APK e smoke E2E.

## Gap backend conhecido

Venda real exige cliente válido do tenant. Antes de 009C/010, confirmar no backend um contrato mobile para listagem/sync de clientes; não usar fixture como ID remoto.

## Contratos que envelheceram

Não implemente 009A/009B/009C/010 literalmente sem nova auditoria. Já foram identificadas diferenças entre documentação antiga e backend real em tipos de IDs, cursor/checkpoint/tombstones e protocolo de `sale-intents`.

## Arquitetura obrigatória

`Page -> Controller -> UseCase -> Repository -> DAO/API`

- presentation: sem Dio/Drift;
- application: sem Dio/Drift/JSON/widgets;
- domain: sem Flutter/transporte/persistência;
- pending local != confirmed remoto;
- servidor soberano para autorização, estoque e confirmação.

## Regras de produto sensíveis

- multi-tenant e isolamento local obrigatórios;
- `price = null` pode ser restrição válida;
- produto sem estoque continua visível quando o contrato permitir;
- permissão visual não substitui autorização remota;
- contrato planejado não é contrato implementado.

## Bootstrap mínimo do agente

Leia `AGENTS.md`, este arquivo e `.agents/task-routing.md`. Depois leia apenas a documentação indicada para a tarefa.
