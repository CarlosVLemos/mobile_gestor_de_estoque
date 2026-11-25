# Contexto Rápido

Checkpoint documental: 25/11/2026 — base de planejamento `6fec45ed`. Não é resultado de nova execução de QA.

- Specs 007, 008, 008B, 009A/B/C, 010, 012, 013 e 013D: entregues segundo evidência histórica de setembro; suite/analyze históricos, não atestado da revisão atual.
- Spec 014: DONE com restrições; goldens e QA automatizada históricos, TalkBack/foco manual NOT_RUN, DEBT-014-01 (proposta estruturada) pendente.
- App local-first: Drift isolado por user/tenant; venda + outbox atômicas, revisão explícita; sync startup/refresh/resumed; sessão demo isolada. Não confundir pending com confirmed.
- IDs: Product/tombstone inteiro → String numérica; Category UUID → String UUID; category null válido. Não relaxar tipos genericamente.
- Timezone `APP_TIMEZONE`; configuração inválida/ausente deve falhar fechado conforme contrato. Validação real da zona é dívida.
- 19 issues abertas a partir da auditoria estática: riscos e dívidas, não bugs todos reproduzidos. `REFINAMENTO.md` e `docs/specs/roadmap-refinamento-015-023.md` são mapa do novo planejamento.
- Specs 015–023 em DRAFT na base: qualidade/CI, offline, design, vendas, gestão, segurança, release, observabilidade e Flex. Backend Laravel ainda precisa de auditoria dedicada para novos contratos. Não presumir CI, release ou Flex implementados.

## Caminho crítico
1. 015: harness, política de execução e CI aprovado; congelar contrato com decisão humana.
2. 016/017/020: confiabilidade, design e segurança conforme dependências; 018/019: fluxo comercial e gestão.
3. 021: homologação; 022: observabilidade; 023: Flex se exigido para lançamento.

Leia AGENTS.md e `.agents/task-routing.md`; não carregue toda a documentação. Nunca rode validações locais sem autorização explícita atual. A exceção de CI depende de aprovação e implementação da 015.
