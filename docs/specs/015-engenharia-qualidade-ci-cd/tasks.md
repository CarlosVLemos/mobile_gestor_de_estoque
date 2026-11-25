# Tasks — Spec 015

Estado: `draft` | nenhuma implementação iniciada neste pacote.

## Handoff e caminho crítico
- [ ] Jarvis: confirmar dependências (Nenhuma; habilita os gates das demais specs.); definir ownership e escopo; obter aprovação/FROZEN quando CRITICAL.
- [ ] Maquiavel: auditar contrato remoto onde aplicável; registrar SHA, gaps e decisão de compatibilidade.
- [ ] Inventariar workflows, ações, regras existentes e capacidade de proteção de branches; fixar baseline e orçamento de jobs.
- [ ] Desenhar matriz push/PR e checks estáveis; aprovar exceção de CI e regras de escrita remota.
- [ ] Implementar workflow rápido e completo com jobs isolados, lockfile, analyze, testes e build de verificação.
- [ ] Estabilizar goldens/codegen no runner; publicar evidências e configurar segurança, branch rules e template de revisão.
- [ ] Provar PR que passa e PR que falha sem bypass; documentar operação e rollback de workflow.
- [ ] Van Gogh: entregar diff rastreável por REQ e testes, sem executar validações locais sem autorização.
- [ ] Mefisto: revisar diff/contrato, evidência do CI e QA manual aplicável; não reduzir gates para passar.
- [ ] Jarvis: registrar veredito, limitações e aprovação humana; fechar issues apenas quando seus critérios realmente atendidos.

## Sequenciamento
Nenhum trabalho dependente de contrato DRAFT pode alterar schema/API/segurança. Se houver conflito com outra spec, interromper o path compartilhado e registrar Change Request/ownership.

## Extensão 015A/B/D — DRAFT
- [ ] Jarvis: revisar proposta harness v2, alinhar task packets, ownership e estados; obter aprovação humana do contrato.
- [ ] Van Gogh: integrar adaptadores nativos, regras de descoberta e portabilidade MCP; não alterar runtime do app.
- [ ] Jarvis/Mefisto: aprovar matriz de permissões, sessão principal e credenciais; validar perfis sem execução local não autorizada.
- [ ] Todos: propor melhorias de skills com evidência; Mefisto (ou revisor independente se autor) revisa; Jarvis coordena ativação humana.
- [ ] Mefisto: executar evals apenas em ambiente aprovado, coletar traces redigidos, comparar baseline e candidato; registrar NOT_RUN até evidência.
- [ ] Jarvis: verificar 015C CI e manter veredito pendente até gates comprovados.
