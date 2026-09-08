# Uso de MCPs

## Princípio

MCP existe para reduzir shell, releitura e adivinhação. Não consultar todos em toda tarefa.

## Ordem preferida

### 1. Dart/Flutter MCP

Primeira escolha para workspace, diagnostics, símbolos, testes e runtime Dart/Flutter. Quando ele consegue responder, prefira-o ao shell.

Fallback: comandos Flutter/Dart executados no gate, não em loop durante implementação.

### 2. Developer Knowledge MCP

Fonte preferida para documentação oficial Flutter, Dart e ecossistema Google suportado. Use para APIs/boas práticas atuais do SDK.

Configuração requer `GOOGLE_DEVELOPER_KNOWLEDGE_API_KEY` local; nunca versione a chave.

### 3. Context7

Use para packages de terceiros, especialmente Riverpod, Drift, Dio, go_router, shadcn_ui e flutter_secure_storage. Consulte somente o tópico necessário e respeite a versão do projeto.

### 4. GitHub MCP / Connector

Reativado para leitura por padrão.

Use para:

- comparar branches/commits;
- revisar PR/diff;
- auditar o backend `CarlosVLemos/gestor_de_estoque`;
- confirmar contratos cross-repo;
- consultar issues/reviews quando relevante.

Escrita remota, commits, branches, PRs, comentários ou merge exigem pedido explícito do usuário.

### Sequential Thinking

Desativado por padrão. O projeto usa Jarvis + skills + subagentes para decomposição. Só reative se uma investigação concreta demonstrar ganho.

## Terminal budget

- não iniciar `flutter run`, emulator, Docker, watcher ou servidor automaticamente;
- não fazer polling repetitivo;
- não rodar `flutter test`/`flutter analyze` a cada edição;
- agrupar alterações e deixar Mefisto validar no gate;
- repetir comando apenas após mudança relevante ou hipótese nova.

Regra canônica: `.agents/rules/terminal-budget.md`.

## Configuração versionada

- Codex: `.codex/config.toml`
- Antigravity: `.agents/mcp_config.json` contém o Dart MCP portátil; MCPs remotos com segredo devem ser configurados localmente/globalmente.

Variáveis locais esperadas quando aplicáveis:

```text
CONTEXT7_API_KEY
GITHUB_PAT_TOKEN
GOOGLE_DEVELOPER_KNOWLEDGE_API_KEY
```

Após mudar MCP/variável, recarregue a ferramenta e abra nova sessão.

## Skills oficiais Flutter/Dart

As skills oficiais podem ser instaladas manualmente sem duplicá-las no repositório:

```text
npx skills add flutter/agent-plugins --skill '*' --agent universal --yes
npx skills add dart-lang/skills --skill '*' --agent universal --yes
```

As skills locais do Arara continuam em `.agents/skills/` e têm precedência arquitetural sobre exemplos genéricos.
