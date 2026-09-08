# Roteamento de leitura e skills

Use este arquivo para carregar o menor contexto necessário.

## Sempre

- `AGENTS.md`
- `.agents/quick-context.md`
- `para mobile/00-contexto-operacional.md`

Não leia toda a pasta `para mobile/` nem todas as skills.

## Arquitetura, dependência ou estrutura

Leia:

- `para mobile/05-arquitetura-mobile.md`
- `para mobile/06-registro-decisoes.md`
- `lib/AGENTS.md`

Skills úteis: `jarvis-orchestrator`, `van-gogh-flutter`.

## Integração remota / contrato backend

Leia:

- `para mobile/03-endpoints-mobile.md`
- contrato/spec backend correspondente quando existir;
- código Laravel real se houver dúvida.

Ative `maquiavel-api-contract`. O contrato real vence exemplos antigos do mobile.

## Offline, sync, outbox ou isolamento

Leia:

- `para mobile/04-regras-e-necessidades-mobile.md`
- seções relevantes de `05-arquitetura-mobile.md`
- decisão correspondente em `06-registro-decisoes.md`.

Skills: `local-first-sync`; para schema, também `drift-migrations`.

## Tela / componente / UX

Leia:

- `para mobile/02-definicoes-de-interface.md`
- `designmobile.md` apenas se a mudança visual for ampla.

Ative `van-gogh-flutter`. Trate largura compacta, textScaler alto, loading, empty, restricted, offline e failure conforme aplicável.

## Teste / revisão / pré-merge

Leia:

- `test/AGENTS.md`
- testes afetados;
- spec/contrato da entrega.

Ative `mefisto-flutter-qa`.

## Release / APK / VPS

Ative `mobile-release` e leia apenas configuração Android, ambiente e documentação de deploy necessária.

## Spec / processo / handoff

Leia:

- `para mobile/08-processo-de-trabalho.md`
- `docs/specs/AGENTS.md`.

Ative `jarvis-orchestrator`.

## Ferramentas

Leia `para mobile/07-uso-de-mcps.md` somente quando a tarefa exigir MCP/configuração externa.

## Evitar

- pesquisar terminalmente algo já disponível por MCP;
- reabrir decisão aceita sem evidência nova;
- inventar endpoint, tipo, permissão ou paginação;
- usar fixture como prova de contrato remoto;
- executar suíte completa durante cada iteração de implementação.
