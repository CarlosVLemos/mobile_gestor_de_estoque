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

Não são copiadas automaticamente para evitar duplicação. Consulte os repositórios oficiais Flutter/Dart, revise versão, licença, conteúdo, dependências e skills específicas. Instale somente com autorização explícita; não use instalação em massa ou autoaceite.

Essas skills usam o mesmo padrão `.agents/skills/` e são carregadas por progressive disclosure.

## Segurança

- nunca versione PAT, API key, `.env` ou credenciais;
- MCP remoto deve ler segredo do ambiente/configuração local;
- GitHub write só com pedido explícito;
- agentes de implementação não devem iniciar Docker, emulator, `flutter run` ou watchers sem solicitação explícita.

## Harness v2 (proposta integrada à 015)
- Antigravity lê os agentes com frontmatter e regras `trigger`; Codex usa `.codex/agents/*.toml` como adaptadores finos para os mesmos papéis. Não duplique conteúdo canônico.
- Perfis nativos desabilitam shell por padrão; se uma versão não oferecer edição/leitura suficiente sem shell, supervisor faz handoff por ferramenta segura ou pede autorização específica. Verifique a descoberta e restrições antes de delegar; nunca desabilite sandbox para contornar.
- `.agents/learning/` contém propostas não ativas; skills aprovadas ficam em `.agents/skills/`. Não instale skills externas sem revisão e autorização. Veja `docs/engineering/agent-harness-v2.md`.
- Paths dos MCPs devem ser resolvidos por PATH local; configure Dart/npx e credenciais fora do Git. Use credencial GitHub read-only na sessão comum; operações de escrita exigem sessão/escopo autorizado. Não presuma que perfil nativo limita MCP herdado.
