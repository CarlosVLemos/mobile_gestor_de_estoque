# Test matrix — Spec 020

Estado: `NOT_RUN` — cenários planejados, não resultados.

| ID | Cenário | Nível | Resultado esperado | Evidência |
| --- | --- | --- | --- | --- |
| QA-020-01 | Token/PII em logs e APK | Static/security | Ausência de segredos e dados indevidos. | NOT_RUN |
| QA-020-02 | TLS inválido/HTTP release | Integration | Conexão recusada; sem bypass. | NOT_RUN |
| QA-020-03 | Troca tenant e usuário, backup/restore | Integration/manual | Isolamento e recuperação segura. | NOT_RUN |
| QA-020-04 | Token revogado e operação pendente | Integration | Envio negado e operação preservada. | NOT_RUN |
| QA-020-05 | Upgrade de SQLite/Drift | Integration | DB/outbox intactos e compatíveis. | NOT_RUN |
| QA-020-06 | Dependência vulnerável explorável | CI/review | Gate bloqueia ou exceção aprovada e datada. | NOT_RUN |

## Static checks
Revisar contrato, boundaries, dados restritos, mensagens, migrações e concorrência conforme escopo. CI aprovado: format/analyze/architecture, testes focados e suíte completa no PR; goldens e build quando aplicáveis. Não rodar localmente sem pedido explícito do usuário.

## Integration/manual checks
Usar ambiente e dados sintéticos. QA manual em dispositivo, rede real/simulada ou backend de staging somente mediante gate apropriado; registrar versão, aparelho, condições, resultado e evidência. Golden não substitui usabilidade, TalkBack ou E2E.

## Full-suite gate
CI do SHA a integrar, checks obrigatórios verdes; resultados ausentes não são PASS. Falha exige correção ou restrição documentada e aprovada sem reduzir segurança ou integridade.
