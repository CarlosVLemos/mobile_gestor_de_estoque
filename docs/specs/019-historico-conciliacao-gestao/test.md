# Test matrix — Spec 019

Estado: `NOT_RUN` — cenários planejados, não resultados.

| ID | Cenário | Nível | Resultado esperado | Evidência |
| --- | --- | --- | --- | --- |
| QA-019-01 | Proposta muda estoque/preço e revisão | Unit/widget | Diferenças claras; somente revisão atual pode ser aceita. | NOT_RUN |
| QA-019-02 | Proposta incompleta | Widget | Não permite aceite cego; orienta resolução. | NOT_RUN |
| QA-019-03 | Reenvio/timeout após confirmação | Integration | Total final e identidade coerentes, sem duplicação. | NOT_RUN |
| QA-019-04 | 0,1 + 0,2 e arredondamento por item | Unit | Resultado exato conforme contrato, sem double como autoridade. | NOT_RUN |
| QA-019-05 | Upgrade de banco e outbox antiga | Integration | Valores e operações preservados; nenhuma perda. | NOT_RUN |
| QA-019-06 | Filtros, paginação, permissões | Unit/widget | Dados corretos sem leak; preço null restrito. | NOT_RUN |
| QA-019-07 | Dashboard desconectado e gerente/vendedor | Widget/integration | Escopo e freshness visíveis; métricas não inventadas. | NOT_RUN |

## Static checks
Revisar contrato, boundaries, dados restritos, mensagens, migrações e concorrência conforme escopo. CI aprovado: format/analyze/architecture, testes focados e suíte completa no PR; goldens e build quando aplicáveis. Não rodar localmente sem pedido explícito do usuário.

## Integration/manual checks
Usar ambiente e dados sintéticos. QA manual em dispositivo, rede real/simulada ou backend de staging somente mediante gate apropriado; registrar versão, aparelho, condições, resultado e evidência. Golden não substitui usabilidade, TalkBack ou E2E.

## Full-suite gate
CI do SHA a integrar, checks obrigatórios verdes; resultados ausentes não são PASS. Falha exige correção ou restrição documentada e aprovada sem reduzir segurança ou integridade.
