# Tasks — Spec 022

Estado: `draft` | nenhuma implementação iniciada neste pacote.

## Handoff e caminho crítico
- [ ] Jarvis: confirmar dependências (015, 016 e 020; métricas comerciais da 019; baseline antes de 021, evolução pós-piloto.); definir ownership e escopo; obter aprovação/FROZEN quando CRITICAL.
- [ ] Maquiavel: auditar contrato remoto onde aplicável; registrar SHA, gaps e decisão de compatibilidade.
- [ ] Definir dicionário de métricas, origem, privacidade, cardinalidade e orçamento.
- [ ] Instrumentar localmente e medir baseline sintético/piloto sem coletar PII.
- [ ] Aprovar destino e contrato; implementar envio em lote se necessário e testes de falha.
- [ ] Criar painel técnico e runbook de alertas com limiares baseados em evidência; revisar após piloto.
- [ ] Van Gogh: entregar diff rastreável por REQ e testes, sem executar validações locais sem autorização.
- [ ] Mefisto: revisar diff/contrato, evidência do CI e QA manual aplicável; não reduzir gates para passar.
- [ ] Jarvis: registrar veredito, limitações e aprovação humana; fechar issues apenas quando seus critérios realmente atendidos.

## Sequenciamento
Nenhum trabalho dependente de contrato DRAFT pode alterar schema/API/segurança. Se houver conflito com outra spec, interromper o path compartilhado e registrar Change Request/ownership.
