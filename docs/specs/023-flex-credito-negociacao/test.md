# Test matrix — Spec 023

Estado: `NOT_RUN` — cenários planejados, não resultados.

| ID | Cenário | Nível | Resultado esperado | Evidência |
| --- | --- | --- | --- | --- |
| QA-023-01 | Base 100, venda 130, 10 itens | Unit/backend | Provisão 300 sob hipótese 100%; disponível só após condição aprovada. | NOT_RUN |
| QA-023-02 | Saldo 300, dois dispositivos tentam 200 | Concurrency E2E | Somente compromissos autorizados; sem overspend; outro pede revisão. | NOT_RUN |
| QA-023-03 | Acréscimos e descontos no mesmo pedido | Unit/backend | Delta líquido correto, respeitando limites por item. | NOT_RUN |
| QA-023-04 | Replay de venda/confirm/pagamento | Integration | Nenhum lançamento duplicado. | NOT_RUN |
| QA-023-05 | Cancelamento após consumir crédito | Integration | Estorno compensatório auditável; bloqueio de novos descontos se devedor. | NOT_RUN |
| QA-023-06 | Preço mínimo e permissão/tenant | Security/unit | Servidor rejeita negociação inválida/fora do escopo. | NOT_RUN |
| QA-023-07 | Offline com saldo desatualizado | E2E | Intenção pendente, revisão explícita, preço não alterado silenciosamente. | NOT_RUN |
| QA-023-08 | Cliente antigo sem Flex e migração | Integration | Compatibilidade e outbox preservadas. | NOT_RUN |
| QA-023-09 | Pagamento parcial e arredondamento | Unit/backend | Comportamento conforme política congelada; soma exata. | NOT_RUN |

## Static checks
Revisar contrato, boundaries, dados restritos, mensagens, migrações e concorrência conforme escopo. CI aprovado: format/analyze/architecture, testes focados e suíte completa no PR; goldens e build quando aplicáveis. Não rodar localmente sem pedido explícito do usuário.

## Integration/manual checks
Usar ambiente e dados sintéticos. QA manual em dispositivo, rede real/simulada ou backend de staging somente mediante gate apropriado; registrar versão, aparelho, condições, resultado e evidência. Golden não substitui usabilidade, TalkBack ou E2E.

## Full-suite gate
CI do SHA a integrar, checks obrigatórios verdes; resultados ausentes não são PASS. Falha exige correção ou restrição documentada e aprovada sem reduzir segurança ou integridade.
