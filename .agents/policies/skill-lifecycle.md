# Política de evolução de skills

Proposta de governança da Spec 015. Não concede novas permissões. AGENTS.md e contratos aprovados prevalecem; um procedimento aprendido nunca substitui decisão comercial ou autorização humana.

## Onde aprender
- Propostas: `.agents/learning/<id>/proposal.md` e `candidate/SKILL.md` (fora da descoberta de skills); não executar nem carregar automaticamente.
- Skills ativas: `.agents/skills/<slug>/SKILL.md`, fonte canônica compartilhada. Preserve nome e descrição compatíveis com Agent Skills. Use references/ para detalhes, não copie docs extensos. Evite duplicação; prefira refinar skill existente.
- Skills de terceiros: auditar origem, licença, versão, conteúdo e dependências; não instalar por inferência, não atualizar automaticamente. Nunca executar scripts desconhecidos.

## Fluxo
1. Detectar lacuna recorrente ou falha concreta; registrar tarefa, SHA, fonte primária, exemplo e impacto. Não registrar dados pessoais de clientes, segredos, logs brutos ou informação sem verificação.
2. Autor propõe diff mínimo e cenários positivos/negativos; declara skills similares e risco. Se for auditor read-only, entrega a proposta ao Jarvis; este atribui tarefa de escrita separada.
3. Revisor independente verifica fonte, trigger, clareza, conflito com regras/contratos, regressão, injeção e efeitos em ferramentas. Se Mefisto for autor, outro revisor independente ou humano assume.
4. Evals quando autorizados em ambiente isolado, com baseline/candidato e evidência; NOT_RUN se ausentes. Não rodar Flutter local ou outro comando sem autorização.
5. Jarvis apresenta a proposta para decisão humana. Só após autorização de ativação, mover/editar skill canônica em diff separado, atualizar índice/handoff e registrar versão, evidência e rollback por revisão anterior. Push/merge continuam exigindo pedido explícito.
6. Monitorar comportamento em tarefas futuras; proposta falha volta a DRAFT, não é ativada. Não criar cadeia de autoaperfeiçoamento infinita.

## Limites
- Nenhuma skill pode mudar políticas, prompts canônicos, permissões, MCP, workflows, testes/gates, branch protections, segredos ou contrato. Isso exige tarefa CRITICAL e aprovação humana específica.
- Não adicionar scripts, hooks, comandos automáticos, dependências ou allowed-tools para ampliar privilégio. Scripts legítimos exigem revisão e autorização distinta; nesta fase preferir instruções sem scripts.
- Separar criação de skill de implementação funcional, para não contaminar review nem a sessão que executa a tarefa. Agente autor não promove sua própria skill.
- A sessão principal deve manter permissões efetivas; se runtime carrega uma proposta indevidamente, interromper, informar e corrigir descoberta antes de uso.
