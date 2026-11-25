# Tasks — Spec 023

Estado: `draft` | nenhuma implementação iniciada neste pacote.

## Handoff e caminho crítico
- [ ] Jarvis: confirmar dependências (015, 016, 017, 018, 019, 020; antes de 021 somente se requisito de lançamento.); definir ownership e escopo; obter aprovação/FROZEN quando CRITICAL.
- [ ] Maquiavel: auditar contrato remoto onde aplicável; registrar SHA, gaps e decisão de compatibilidade.
- [ ] Auditar contexto comercial/backend e referências de mercado; elaborar contrato financeiro e exemplos, aprovar pendências.
- [ ] Implementar ledger, políticas, permissões e transações no backend com testes de concorrência/replay/estorno.
- [ ] Integrar web gerencial e consulta de saldo/extrato; validar eventos de pagamento e conclusão.
- [ ] Implementar mobile online com entradas exatas, carrinho, saldo/revisão e feature flag; depois offline condicionado à política.
- [ ] Executar E2E com concorrência de dispositivos, migração, saldo insuficiente, cancelamento e autorização; gate financeiro antes de release.
- [ ] Van Gogh: entregar diff rastreável por REQ e testes, sem executar validações locais sem autorização.
- [ ] Mefisto: revisar diff/contrato, evidência do CI e QA manual aplicável; não reduzir gates para passar.
- [ ] Jarvis: registrar veredito, limitações e aprovação humana; fechar issues apenas quando seus critérios realmente atendidos.

## Sequenciamento
Nenhum trabalho dependente de contrato DRAFT pode alterar schema/API/segurança. Se houver conflito com outra spec, interromper o path compartilhado e registrar Change Request/ownership.
