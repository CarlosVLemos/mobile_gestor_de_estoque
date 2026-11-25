# Tasks — Spec 017

Estado: `draft` | nenhuma implementação iniciada neste pacote.

## Handoff e caminho crítico
- [ ] Jarvis: confirmar dependências (015; contrato 018 para integração de campos; 016 para semântica offline.); definir ownership e escopo; obter aprovação/FROZEN quando CRITICAL.
- [ ] Maquiavel: auditar contrato remoto onde aplicável; registrar SHA, gaps e decisão de compatibilidade.
- [ ] Inventariar padrões atuais e componentes com consumidores reais; definir tokens e critérios de interação.
- [ ] Prototipar e implementar quantity/money/search e estados reutilizáveis com testes focados.
- [ ] Persistir tema; integrar superfícies prioritárias sem alterar regra comercial.
- [ ] Revisar 320dp/200%, dark/light, contraste, foco, TalkBack e goldens; avaliar tarefas com usuários.
- [ ] Registrar feedback, ajustar e atualizar guidelines permanentes.
- [ ] Van Gogh: entregar diff rastreável por REQ e testes, sem executar validações locais sem autorização.
- [ ] Mefisto: revisar diff/contrato, evidência do CI e QA manual aplicável; não reduzir gates para passar.
- [ ] Jarvis: registrar veredito, limitações e aprovação humana; fechar issues apenas quando seus critérios realmente atendidos.

## Sequenciamento
Nenhum trabalho dependente de contrato DRAFT pode alterar schema/API/segurança. Se houver conflito com outra spec, interromper o path compartilhado e registrar Change Request/ownership.
