# Test matrix — Spec 017

Estado: `NOT_RUN` — cenários planejados, não resultados.

| ID | Cenário | Nível | Resultado esperado | Evidência |
| --- | --- | --- | --- | --- |
| QA-017-01 | Alterar 1→100 por digitação | Widget/manual | Campo editável, sem cliques repetidos; inteiro válido. | NOT_RUN |
| QA-017-02 | Campo vazio/zero/decimal/colagem inválida | Widget | Não envia valor inválido; mensagem clara. | NOT_RUN |
| QA-017-03 | Preço 1.234,56 e percentual | Widget/unit | Formato pt-BR e round-trip exato conforme contrato. | NOT_RUN |
| QA-017-04 | 320dp, escala 2.0 e teclado | Widget | Sem overflow e CTA alcançável. | NOT_RUN |
| QA-017-05 | Tema após reinício | Unit/widget | Preferência restaurada; sistema acompanha SO. | NOT_RUN |
| QA-017-06 | TalkBack, foco e contraste | Manual/widget | Ordem lógica e rótulos claros; QA-014-16 registrado. | NOT_RUN |
| QA-017-07 | Vendedores completam tarefas | Manual | Medir conclusão sem ajuda e dificuldades; metas revisadas com evidência. | NOT_RUN |

## Static checks
Revisar contrato, boundaries, dados restritos, mensagens, migrações e concorrência conforme escopo. CI aprovado: format/analyze/architecture, testes focados e suíte completa no PR; goldens e build quando aplicáveis. Não rodar localmente sem pedido explícito do usuário.

## Integration/manual checks
Usar ambiente e dados sintéticos. QA manual em dispositivo, rede real/simulada ou backend de staging somente mediante gate apropriado; registrar versão, aparelho, condições, resultado e evidência. Golden não substitui usabilidade, TalkBack ou E2E.

## Full-suite gate
CI do SHA a integrar, checks obrigatórios verdes; resultados ausentes não são PASS. Falha exige correção ou restrição documentada e aprovada sem reduzir segurança ou integridade.
