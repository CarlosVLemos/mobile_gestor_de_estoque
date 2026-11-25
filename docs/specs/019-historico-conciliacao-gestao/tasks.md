# Tasks — Spec 019

Estado: `draft` | nenhuma implementação iniciada neste pacote.

## Handoff e caminho crítico
- [ ] Jarvis: confirmar dependências (015, 016, 018 para jornada; 020 para dados financeiros; 023 para extrato Flex.); definir ownership e escopo; obter aprovação/FROZEN quando CRITICAL.
- [ ] Maquiavel: auditar contrato remoto onde aplicável; registrar SHA, gaps e decisão de compatibilidade.
- [ ] Maquiavel audita contrato real e congela semântica de proposta, moeda, histórico e KPI.
- [ ] Criar projeções e migration monetária compatível; manter replay antigo e testes de conversão.
- [ ] Implementar histórico paginado/detalhes e reconciliação de totais; proposta estruturada e aceite CAS.
- [ ] Aprimorar painel gerencial e permissões; histórico remoto apenas se disponível.
- [ ] Validar fixtures de ajuste, concorrência, migração, restrição e E2E; registrar critérios ainda bloqueados.
- [ ] Van Gogh: entregar diff rastreável por REQ e testes, sem executar validações locais sem autorização.
- [ ] Mefisto: revisar diff/contrato, evidência do CI e QA manual aplicável; não reduzir gates para passar.
- [ ] Jarvis: registrar veredito, limitações e aprovação humana; fechar issues apenas quando seus critérios realmente atendidos.

## Sequenciamento
Nenhum trabalho dependente de contrato DRAFT pode alterar schema/API/segurança. Se houver conflito com outra spec, interromper o path compartilhado e registrar Change Request/ownership.
