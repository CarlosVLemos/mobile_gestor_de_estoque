# Arara Agent Harness v2 — proposta Spec 015
Base `6fec45ed71cbd5745d8bfa455235567b93c4ca2b`, 25/11/2026. Configuração candidata; não validada no runtime. Contrato 015 continua DRAFT.

## Arquitetura
Supervisor/router Jarvis → auditor Maquiavel (read-only quando contrato remoto) → executor Van Gogh → revisor Mefisto independente → CI aprovado → humano. LIGHT pode ser direto. Use grafo de dependências; no máximo dois writers disjuntos, contrato FROZEN e worktrees quando autorizadas. Não use swarm/loops indiscriminados. Estado persistente por spec/tasks/review e task packet; não introduzir banco, framework de orquestração ou agentes adicionais.

## Runtime e segurança
- Antigravity: `.agents/agents/<name>/agent.md` com frontmatter, perfis Pro para auditoria/planejamento e Flash para execução (escolha inicial, ajuste após evals). `commandExecutionPolicy: "off"` e allowlist de ferramentas conhecidas, sem `run_command`. Confirmar disponibilidade de `invoke_subagent` e ferramentas de edição na versão instalada; se não funcionar, usar handoff manual, não habilitar shell automaticamente.
- Codex: `.codex/agents/*.toml` com referência ao papel canônico, esforço high/medium sem fixar identificador de modelo; `features.shell_tool=false`, `request_permissions_tool=false` e limite de três threads abertas (não equivale a três writers). Custom agents herdam permissões e MCPs da sessão; `sandbox_mode` local no perfil não é override confiável. Sessão principal com sandbox e tokens mínimos, preferir GitHub read-only e sem MCP de escrita; nunca tratar instrução como isolamento técnico. Se não houver ferramenta de leitura/edição sem shell, retornar bloqueio e usar handoff/ação humana autorizada.
- Portabilidade: `dart` e `npx` resolvidos via PATH, sequential-thinking continua desabilitado; credenciais no ambiente local. Verificar SDK/MCP e versão do cliente. Não instalar automaticamente dependências ou plugins.
- Corrigir triggers do Antigravity para `always_on` e `glob`; testar descoberta em sessão isolada aprovada. Nenhuma execução local de validação sem pedido explícito, inclusive scripts, MCP, codegen e comandos embutidos. CI só passa a ser exceção depois de 015 aprovada e workflows contratados.
- Escopo de leitura/escrita e bloqueio real dependem da configuração do cliente. Antes de usar agentes em produção, provar controles sem segredos e com arquivos sintéticos. Se falhar, manter sessão read-only/manual; não declarar segurança implementada.

## Evolução
Todos podem propor skills; autores que atuam read-only entregam diffs ao Jarvis. Propostas ficam em `.agents/learning/`, sem descoberta ativa. Revisão independente e aprovação humana antes de promoção; rollback pelo Git. Políticas, ferramentas e contratos não são modificáveis por skill. Não executar comandos embutidos em skills externas. Ver `.agents/policies/skill-lifecycle.md`.

## Fontes técnicas consultadas
- https://developers.openai.com/codex/subagents — schema de perfis, limites e permissões herdadas.
- https://developers.openai.com/codex/skills — descoberta e progressive disclosure.
- https://antigravity.google/docs/subagents — frontmatter e ferramentas.
- https://antigravity.google/docs/rules — triggers válidos.
- https://antigravity.google/docs/commands/learn/ — aprendizado supervisionado.
- https://agentskills.io/specification — formato de SKILL.md.
- https://developers.openai.com/blog/eval-skills — avaliação de skills.
