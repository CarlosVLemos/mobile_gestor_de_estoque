# Test matrix — Spec 022

Estado: `NOT_RUN` — cenários planejados, não resultados.

| ID | Cenário | Nível | Resultado esperado | Evidência |
| --- | --- | --- | --- | --- |
| QA-022-01 | Telemetria indisponível/offline | Unit/integration | Venda/sync comercial continuam; fila limitada. | NOT_RUN |
| QA-022-02 | Evento contém PII ou token | Unit/security | Redação/rejeição; sem envio sensível. | NOT_RUN |
| QA-022-03 | Busca e venda em dataset de referência | Performance/manual | Baseline p50/p95 e duração documentados. | NOT_RUN |
| QA-022-04 | Contagem de operações sem envio | Unit/review | Dados desconhecidos não são zero nem contagem global. | NOT_RUN |
| QA-022-05 | Alerta recorrente | Manual | Dono, ação, janela e limiar documentados. | NOT_RUN |

## Static checks
Revisar contrato, boundaries, dados restritos, mensagens, migrações e concorrência conforme escopo. CI aprovado: format/analyze/architecture, testes focados e suíte completa no PR; goldens e build quando aplicáveis. Não rodar localmente sem pedido explícito do usuário.

## Integration/manual checks
Usar ambiente e dados sintéticos. QA manual em dispositivo, rede real/simulada ou backend de staging somente mediante gate apropriado; registrar versão, aparelho, condições, resultado e evidência. Golden não substitui usabilidade, TalkBack ou E2E.

## Full-suite gate
CI do SHA a integrar, checks obrigatórios verdes; resultados ausentes não são PASS. Falha exige correção ou restrição documentada e aprovada sem reduzir segurança ou integridade.
