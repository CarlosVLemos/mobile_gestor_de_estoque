# `.agents/` — camada compartilhada de agentes

Esta pasta é a camada canônica de governança para Codex e Antigravity. O objetivo é manter uma única fonte de regras/skills e evitar versões divergentes por ferramenta.

## Estrutura

```text
.agents/
├── agents/       # agentes customizados do Antigravity
├── skills/       # skills portáveis, carregadas sob demanda
├── rules/        # regras workspace do Antigravity
├── templates/    # templates de contrato/spec/QA
├── mcp_config.json
├── quick-context.md
├── task-routing.md
└── subagents.md
```

`AGENTS.md` continua sendo a entrada global do Codex. O Antigravity usa `.agents/rules/`, `.agents/skills/` e `.agents/agents/` diretamente.

## Agentes canônicos

- Jarvis: coordenação e lifecycle.
- Maquiavel: contrato API/backend.
- Van Gogh: Flutter/UX/implementação.
- Mefisto: QA e gate.

Não crie novos nomes permanentes. Um papel temporário deve ser mapeado para um desses quatro.

## Setup manual recomendado

### Antigravity

1. Abra o repositório e recarregue as customizações.
2. Em Rules, deixe `project.md` e `terminal-budget.md` como **Always On**.
3. Use `flutter-architecture.md` para trabalho em `lib/**/*.dart` e `validation.md` para QA/testes.
4. `.agents/mcp_config.json` já configura o Dart MCP sem segredos.
5. Configure globalmente, quando desejar, Developer Knowledge, Context7 e GitHub MCP com suas credenciais locais.

### Codex

`.codex/config.toml` configura os MCPs do projeto. Defina localmente, sem versionar valores secretos:

- `CONTEXT7_API_KEY`
- `GITHUB_PAT_TOKEN`
- `GOOGLE_DEVELOPER_KNOWLEDGE_API_KEY`

Opcionalmente instale o plugin oficial Flutter/Dart do Codex, se sua versão suportar plugins.

### Skills oficiais Flutter/Dart

Não são copiadas para este repositório para evitar duplicação. Instale-as manualmente na raiz quando quiser atualizar o conjunto oficial:

```text
npx skills add flutter/agent-plugins --skill '*' --agent universal --yes
npx skills add dart-lang/skills --skill '*' --agent universal --yes
```

Essas skills usam o mesmo padrão `.agents/skills/` e são carregadas por progressive disclosure.

## Segurança

- nunca versione PAT, API key, `.env` ou credenciais;
- MCP remoto deve ler segredo do ambiente/configuração local;
- GitHub write só com pedido explícito;
- agentes de implementação não devem iniciar Docker, emulator, `flutter run` ou watchers sem solicitação explícita.
