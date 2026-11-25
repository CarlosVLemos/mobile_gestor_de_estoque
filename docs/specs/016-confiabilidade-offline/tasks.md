# Tasks — Spec 016

Estado: `draft` | nenhuma implementação iniciada neste pacote.

## Handoff e caminho crítico
- [ ] Jarvis: confirmar dependências (015 para merge; 020 para política de segurança; contrato Laravel para sessão/reconciliação.); definir ownership e escopo; obter aprovação/FROZEN quando CRITICAL.
- [ ] Maquiavel: auditar contrato remoto onde aplicável; registrar SHA, gaps e decisão de compatibilidade.
- [ ] Reproduzir dupla submissão, cold start offline e falhas de conexão; congelar política de sessão e protocolo de retry.
- [ ] Implementar guarda de registro e mapeamento de erros; preservar identidade e carrinho quando falhar.
- [ ] Implementar sessão offline limitada e revalidação na reconexão com integração contextual.
- [ ] Ligar trigger connectivity, backoff e estado operacional; corrigir validação timezone.
- [ ] Executar QA via CI e smoke manual de rede/dispositivo sob autorização; registrar riscos e restrições.
- [ ] Van Gogh: entregar diff rastreável por REQ e testes, sem executar validações locais sem autorização.
- [ ] Mefisto: revisar diff/contrato, evidência do CI e QA manual aplicável; não reduzir gates para passar.
- [ ] Jarvis: registrar veredito, limitações e aprovação humana; fechar issues apenas quando seus critérios realmente atendidos.

## Sequenciamento
Nenhum trabalho dependente de contrato DRAFT pode alterar schema/API/segurança. Se houver conflito com outra spec, interromper o path compartilhado e registrar Change Request/ownership.
