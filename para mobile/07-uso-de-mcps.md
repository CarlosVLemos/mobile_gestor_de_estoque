# Uso de MCPs

## Objetivo

MCPs devem reduzir leitura repetida, melhorar precisão e deixar verificações
reproduzíveis. Eles não substituem as decisões canônicas deste repositório.

Antes de usar um MCP:

1. verificar se está disponível na sessão;
2. confirmar que é adequado à tarefa;
3. preferir fonte oficial ou dados estruturados;
4. usar o fallback quando estiver ausente;
5. registrar limitações relevantes no fechamento.

Não consultar todos os MCPs em toda tarefa.

## 1. Dart/Flutter MCP oficial

Usar para tarefas diretamente relacionadas ao projeto Dart/Flutter:

- entender configuração do workspace;
- obter diagnósticos;
- executar ou orientar análise e testes;
- consultar informações específicas do SDK e ferramentas;
- reduzir comandos manuais repetitivos.

Fallback:

- `flutter analyze`;
- `flutter test`;
- `dart format`;
- documentação oficial do Flutter/Dart.

O resultado do MCP não substitui os testes relevantes do projeto.

## 2. Context7

Usar quando a tarefa depender de documentação atual de bibliotecas:

- Riverpod;
- Drift;
- Dio;
- `go_router`;
- Freezed;
- Workmanager;
- demais packages adotados.

Fluxo:

1. identificar biblioteca e versão em `pubspec.lock`;
2. consultar somente o tópico necessário;
3. aplicar o padrão compatível com a versão do projeto;
4. evitar exemplos que contradigam a arquitetura local.

Fallback:

- documentação oficial da biblioteca;
- código e testes presentes no repositório.

Context7 responde como a biblioteca funciona. Este repositório decide como ela
deve ser usada no produto.

## 3. GitHub MCP

Status temporário: não usar o GitHub MCP nem o GitHub Connector até nova
orientação. As regras abaixo ficam preservadas para quando forem reativados.

Usar para contexto remoto estruturado:

- metadados do repositório;
- issues;
- pull requests;
- comentários e reviews;
- labels;
- estado de colaboração.

Preferir GitHub MCP para leituras e mutações cobertas pelo conector.

Usar Git local ou CLI para:

- status e diff da árvore de trabalho;
- branch local;
- commits ainda não enviados;
- operações dependentes do checkout;
- logs de GitHub Actions não fornecidos pelo conector.

Regras:

- confirmar repositório e alvo antes de escrita remota;
- não criar issue, comentário, PR ou label sem pedido explícito;
- manter contexto remoto alinhado à branch local.

Repositório atual validado pelo MCP:

```text
CarlosVLemos/mobile_gestor_de_estoque
branch padrão: main
```

## 4. Sequential Thinking MCP

Usar em problemas com decisões encadeadas e impacto relevante:

- desenho de sincronização;
- migração de schema;
- conflito entre offline e remoto;
- mudança arquitetural;
- investigação com múltiplas hipóteses;
- planejamento de refactor amplo.

Não usar para:

- renome simples;
- ajuste visual pequeno;
- leitura de arquivo;
- execução direta de teste;
- decisão já registrada.

Saída esperada:

- hipóteses;
- restrições;
- opções;
- trade-offs;
- decisão recomendada;
- pontos que precisam entrar em `06-registro-decisoes.md`.

Fallback:

- plano curto explícito;
- investigação por etapas;
- registro da decisão no documento canônico.

## Configuração local atual

Configuração realizada em 10 de junho de 2026:

- Dart/Flutter MCP oficial: configurado por STDIO;
- Context7: configurado pelo endpoint HTTP oficial;
- GitHub MCP remoto: desabilitado temporariamente;
- Sequential Thinking: configurado por STDIO via NPX;
- GitHub Connector do Codex: disponível, mas suspenso por decisão do projeto;
- Antigravity: recebeu os mesmos quatro servidores;
- VS Code MCP nativo: configurado em `.vscode/mcp.json`.

Arquivos locais:

```text
.codex/config.toml
.vscode/mcp.json
%USERPROFILE%\.codex\.env
%USERPROFILE%\.codex\config.toml
%USERPROFILE%\.gemini\config\mcp_config.json
```

Backups criados:

```text
%USERPROFILE%\.codex\config.toml.pre-mcp-backup
%USERPROFILE%\.gemini\config\mcp_config.pre-arara-mobile-backup.json
```

O Context7 usa `CONTEXT7_API_KEY` a partir do ambiente. Para o Codex App e a
extensão, a chave local fica em `%USERPROFILE%\.codex\.env`, que não deve ser
versionado.

Não use o GitHub MCP remoto nem o GitHub Connector até nova orientação.

Após alterar configuração ou variáveis, recarregue a janela do editor e abra
uma nova sessão para atualizar a lista de ferramentas.

## Atalhos

| Tarefa | MCP preferido | Leitura local |
| --- | --- | --- |
| Erro de build/teste Flutter | Dart/Flutter | contexto + arquivos afetados |
| API de package | Context7 | arquitetura + `pubspec.lock` |
| Issue ou PR | GitHub | diff local + spec relacionada |
| Decisão arquitetural complexa | Sequential Thinking | arquitetura + decisões |
| Ajuste visual | Nenhum obrigatório | interface + trecho do design |
| Regra de negócio | Nenhum obrigatório | regras + contrato relacionado |
