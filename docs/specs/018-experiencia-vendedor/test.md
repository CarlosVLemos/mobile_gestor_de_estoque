# Test matrix — Spec 018

Estado: `NOT_RUN` — cenários planejados, não resultados.

| ID | Cenário | Nível | Resultado esperado | Evidência |
| --- | --- | --- | --- | --- |
| QA-018-01 | Busca com 10 mil produtos, acentos e SKU | Performance/unit | Paginação correta e p95 medido, sem materialização integral. | NOT_RUN |
| QA-018-02 | Produto sem estoque e cache antigo | Widget | Status e data claros; autoridade do servidor preservada. | NOT_RUN |
| QA-018-03 | Quantidade 100, edição, remoção | Widget/unit | Carrinho e subtotal estimado coerentes, sem perda de foco. | NOT_RUN |
| QA-018-04 | Reinício durante rascunho | Integration | Rascunho retomado no contexto correto. | NOT_RUN |
| QA-018-05 | Falha na conversão rascunho→outbox | Unit/integration | Rollback sem perda nem duplicata. | NOT_RUN |
| QA-018-06 | Troca usuário/empresa | Integration | Nenhum vazamento de rascunhos/recentes. | NOT_RUN |
| QA-018-07 | Venda com cinco itens | Manual | Medir tempo e conclusão sem ajuda; registrar baseline. | NOT_RUN |

## Static checks
Revisar contrato, boundaries, dados restritos, mensagens, migrações e concorrência conforme escopo. CI aprovado: format/analyze/architecture, testes focados e suíte completa no PR; goldens e build quando aplicáveis. Não rodar localmente sem pedido explícito do usuário.

## Integration/manual checks
Usar ambiente e dados sintéticos. QA manual em dispositivo, rede real/simulada ou backend de staging somente mediante gate apropriado; registrar versão, aparelho, condições, resultado e evidência. Golden não substitui usabilidade, TalkBack ou E2E.

## Full-suite gate
CI do SHA a integrar, checks obrigatórios verdes; resultados ausentes não são PASS. Falha exige correção ou restrição documentada e aprovada sem reduzir segurança ou integridade.
