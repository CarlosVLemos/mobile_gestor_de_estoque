# Tasks — Spec 018

Estado: `draft` | nenhuma implementação iniciada neste pacote.

## Handoff e caminho crítico
- [ ] Jarvis: confirmar dependências (015, 016 (registro), 017 (componentes); 023 para preço negociado/Flex.); definir ownership e escopo; obter aprovação/FROZEN quando CRITICAL.
- [ ] Maquiavel: auditar contrato remoto onde aplicável; registrar SHA, gaps e decisão de compatibilidade.
- [ ] Mapear jornada atual e observar vendedores; congelar UX, rotas e limites comerciais.
- [ ] Implementar repositórios paginados e índice/normalização; benchmark com dataset sintético 10 mil+.
- [ ] Enriquecer referências de estoque e componente de carrinho/quantidade; decompor SalesPage.
- [ ] Implementar rascunho persistente e conversão atômica; integrar Central de trabalho.
- [ ] Validar jornada em CI e dispositivo; medir tempo, busca e retomada.
- [ ] Van Gogh: entregar diff rastreável por REQ e testes, sem executar validações locais sem autorização.
- [ ] Mefisto: revisar diff/contrato, evidência do CI e QA manual aplicável; não reduzir gates para passar.
- [ ] Jarvis: registrar veredito, limitações e aprovação humana; fechar issues apenas quando seus critérios realmente atendidos.

## Sequenciamento
Nenhum trabalho dependente de contrato DRAFT pode alterar schema/API/segurança. Se houver conflito com outra spec, interromper o path compartilhado e registrar Change Request/ownership.
