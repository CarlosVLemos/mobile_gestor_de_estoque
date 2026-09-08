# Arara-Gastos Mobile — Instruções para Agentes

Estas regras valem para Codex, Antigravity e qualquer agente que trabalhe neste repositório. Instruções explícitas do usuário têm prioridade sobre estas diretrizes, salvo conflito com segurança ou impossibilidade técnica.

## Bootstrap mínimo

Antes de alterar código:

1. leia `para mobile/00-contexto-operacional.md`;
2. use `.agents/task-routing.md` para escolher somente a leitura adicional necessária;
3. ative a skill relevante em `.agents/skills/` quando a tarefa se encaixar nela;
4. não leia toda a documentação por padrão.

## Fontes canônicas

Em caso de conflito, use esta ordem:

1. decisão aceita em `para mobile/06-registro-decisoes.md`;
2. arquitetura em `para mobile/05-arquitetura-mobile.md`;
3. regras em `para mobile/04-regras-e-necessidades-mobile.md`;
4. interface em `para mobile/02-definicoes-de-interface.md`;
5. contrato remoto implementado e auditado;
6. `para mobile/03-endpoints-mobile.md`;
7. código legado, fixtures e comentários.

Nunca trate `planejado`, `proposto` ou `dependente` como implementado.

## Arquitetura obrigatória

Fluxo padrão:

`Page -> Controller -> UseCase -> Repository -> DAO/API`

- `presentation` não acessa Dio ou Drift.
- `application` não conhece Dio, Drift, JSON ou widgets.
- `domain` não conhece Flutter, transporte ou persistência.
- UI consome estado de aplicação; servidor continua soberano para autorização, estoque e confirmação remota.
- operação offline pendente nunca é apresentada como confirmada.
- dados de usuários/tenants diferentes nunca podem compartilhar contexto local indevidamente.

Regras mais específicas para `lib/` estão em `lib/AGENTS.md`.

## Agentes canônicos

Os únicos nomes permanentes são:

- **Jarvis** — escopo, spec, dependências, contrato, handoffs e fechamento.
- **Maquiavel** — auditoria do contrato da API/backend e gaps cross-repo.
- **Van Gogh** — implementação Flutter, UI e integração seguindo o contrato congelado.
- **Mefisto** — testes, regressão, análise estática e veredito técnico.

Detalhes: `.agents/subagents.md` e `.agents/agents/`.

## Modos de trabalho

- `LIGHT`: correção pequena, texto, ícone ou mudança local de baixo risco. Sem spec formal por padrão.
- `STANDARD`: feature normal ou integração com contrato já conhecido. Spec curta quando houver múltiplas camadas.
- `CRITICAL`: auth, tenancy, isolamento, Drift/migração, sync, outbox/vendas, mudança de contrato, segurança ou release. Exige contrato explícito e gate de validação.

Jarvis escolhe o modo antes de uma tarefa relevante.

## Orçamento de terminal

Durante implementação, priorize leitura estática e MCPs. Não execute repetidamente `flutter test`, `flutter analyze`, `dart format`, builds, `flutter run`, Docker, emulator, watchers ou polling de terminal.

Por padrão:

- Jarvis, Maquiavel e Van Gogh não fazem validação pesada de ambiente;
- Mefisto executa a validação no gate, usando o menor conjunto relevante;
- suíte completa ocorre no fechamento/merge, não após cada alteração;
- não repita comando sem mudança de código ou nova hipótese que justifique a repetição;
- processos persistentes ou interativos só devem ser iniciados por solicitação explícita do usuário.

Detalhes: `.agents/rules/terminal-budget.md`.

## Ferramentas

Preferência:

1. Dart/Flutter MCP para diagnostics, símbolos, testes e runtime Flutter;
2. Developer Knowledge MCP para documentação oficial Flutter/Dart/Google;
3. Context7 para bibliotecas de terceiros;
4. GitHub MCP/Connector para leitura cross-repo, branches, diffs e contratos.

GitHub pode ser lido por padrão. Escritas remotas, commits, branches, PRs ou merges exigem pedido explícito do usuário.

Não use Sequential Thinking por padrão; a complexidade deve ser tratada por Jarvis, skills e subagentes quando realmente necessário.

## Backend relacionado

O backend canônico é `CarlosVLemos/gestor_de_estoque`. Quando o mobile depender de endpoint, payload, ID, paginação, erro, permissão ou tenant scope, Maquiavel deve confirmar o contrato real antes de Van Gogh consumir a API. Não invente endpoint ausente.

## Qualidade

Toda entrega precisa de validação proporcional ao risco. `test/AGENTS.md` define a política de testes e `docs/specs/AGENTS.md` governa specs novas.
