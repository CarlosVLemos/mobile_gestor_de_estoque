# Test matrix — Spec 016

Estado: `NOT_RUN` — cenários planejados, não resultados.

| ID | Cenário | Nível | Resultado esperado | Evidência |
| --- | --- | --- | --- | --- |
| QA-016-01 | Dois toques simultâneos, erro e retry | Unit/widget | Uma venda/outbox; carrinho preservado na falha. | NOT_RUN |
| QA-016-02 | Cold start offline após login válido | Integration | Acesso local apenas se TTL/contexto autorizados. | NOT_RUN |
| QA-016-03 | Primeiro login offline ou TTL expirado | Unit/widget | Bloqueio seguro, sem dados de outra conta. | NOT_RUN |
| QA-016-04 | Revogação/tenant suspenso na reconexão | Integration | Não envia operações sem autorização; preserva pendências. | NOT_RUN |
| QA-016-05 | Rede oscila e app resume repetidamente | Unit/integration | Single-flight, backoff e cancelamento corretos. | NOT_RUN |
| QA-016-06 | Timeout após servidor aceitar e retry | Integration | Mesma identidade, sem duplicata. | NOT_RUN |
| QA-016-07 | Timezone inexistente e timestamps históricos | Unit | Rejeita zona inválida, preserva datas. | NOT_RUN |
| QA-016-08 | Dia offline, reinício e reconciliação | Manual E2E | Nenhuma perda ou confirmação fictícia. | NOT_RUN |

## Static checks
Revisar contrato, boundaries, dados restritos, mensagens, migrações e concorrência conforme escopo. CI aprovado: format/analyze/architecture, testes focados e suíte completa no PR; goldens e build quando aplicáveis. Não rodar localmente sem pedido explícito do usuário.

## Integration/manual checks
Usar ambiente e dados sintéticos. QA manual em dispositivo, rede real/simulada ou backend de staging somente mediante gate apropriado; registrar versão, aparelho, condições, resultado e evidência. Golden não substitui usabilidade, TalkBack ou E2E.

## Full-suite gate
CI do SHA a integrar, checks obrigatórios verdes; resultados ausentes não são PASS. Falha exige correção ou restrição documentada e aprovada sem reduzir segurança ou integridade.
