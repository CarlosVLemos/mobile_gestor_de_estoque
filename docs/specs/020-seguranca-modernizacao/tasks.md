# Tasks — Spec 020

Estado: `draft` | nenhuma implementação iniciada neste pacote.

## Handoff e caminho crítico
- [ ] Jarvis: confirmar dependências (015 para gates; começa junto com 016; bloqueia release 021.); definir ownership e escopo; obter aprovação/FROZEN quando CRITICAL.
- [ ] Maquiavel: auditar contrato remoto onde aplicável; registrar SHA, gaps e decisão de compatibilidade.
- [ ] Inventariar dados, dependências, trust boundaries e ameaças; registrar matriz MASVS e riscos.
- [ ] Revisar sessão, tenant, secure storage, backups, TLS, logs e manifest; implementar correções priorizadas.
- [ ] Auditar EOL e atualizar dependências isoladamente com validação de migrações/build.
- [ ] Revisar APK de homologação, casos de abuso e pipeline; registrar exceções e evidências.
- [ ] Van Gogh: entregar diff rastreável por REQ e testes, sem executar validações locais sem autorização.
- [ ] Mefisto: revisar diff/contrato, evidência do CI e QA manual aplicável; não reduzir gates para passar.
- [ ] Jarvis: registrar veredito, limitações e aprovação humana; fechar issues apenas quando seus critérios realmente atendidos.

## Sequenciamento
Nenhum trabalho dependente de contrato DRAFT pode alterar schema/API/segurança. Se houver conflito com outra spec, interromper o path compartilhado e registrar Change Request/ownership.
