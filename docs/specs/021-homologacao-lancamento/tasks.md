# Tasks — Spec 021

Estado: `draft` | nenhuma implementação iniciada neste pacote.

## Handoff e caminho crítico
- [ ] Jarvis: confirmar dependências (015, 016, 017, 018, 019, 020; 022 baseline; 023 se Flex for requisito do piloto.); definir ownership e escopo; obter aprovação/FROZEN quando CRITICAL.
- [ ] Maquiavel: auditar contrato remoto onde aplicável; registrar SHA, gaps e decisão de compatibilidade.
- [ ] Auditar branches, infraestrutura e API; definir canal, configuração e assinatura.
- [ ] Implementar build/env validation e pipeline staging/prod protegido; documentar gestão de chaves.
- [ ] Preparar dados sintéticos e executar smoke em aparelhos; testar upgrade e recuperação.
- [ ] Conduzir piloto, registrar feedback e riscos; emitir go/no-go e runbook de incidente/forward-fix.
- [ ] Publicar somente com aprovação humana; registrar SHA, versão, artefatos, checks e janela de suporte.
- [ ] Van Gogh: entregar diff rastreável por REQ e testes, sem executar validações locais sem autorização.
- [ ] Mefisto: revisar diff/contrato, evidência do CI e QA manual aplicável; não reduzir gates para passar.
- [ ] Jarvis: registrar veredito, limitações e aprovação humana; fechar issues apenas quando seus critérios realmente atendidos.

## Sequenciamento
Nenhum trabalho dependente de contrato DRAFT pode alterar schema/API/segurança. Se houver conflito com outra spec, interromper o path compartilhado e registrar Change Request/ownership.
