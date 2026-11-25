# Test matrix — Spec 015

Estado: `NOT_RUN` — cenários planejados, não resultados.

| ID | Cenário | Nível | Resultado esperado | Evidência |
| --- | --- | --- | --- | --- |
| QA-015-01 | Push com lint/teste falhando | CI | Check vermelho; sem ocultar erro. | NOT_RUN |
| QA-015-02 | PR aberto/atualizado/reaberto | CI | Gate completo executado para revisão correta. | NOT_RUN |
| QA-015-03 | Golden alterado sem aprovação | CI | Falha e diff disponível, sem regravação. | NOT_RUN |
| QA-015-04 | Codegen desatualizado | CI | Diff detectado, gate falha. | NOT_RUN |
| QA-015-05 | PR de fork tenta ler segredo | CI/segurança | Nenhum segredo ou permissão de escrita fornecido. | NOT_RUN |
| QA-015-06 | Tentativa de merge com check falho | Manual/CI | Bloqueado conforme regra disponível. | NOT_RUN |
| QA-015-07 | Agente sem autorização local | Review | Não executa comandos; usa evidência do CI ou solicita autorização. | NOT_RUN |

## Static checks
Revisar contrato, boundaries, dados restritos, mensagens, migrações e concorrência conforme escopo. CI aprovado: format/analyze/architecture, testes focados e suíte completa no PR; goldens e build quando aplicáveis. Não rodar localmente sem pedido explícito do usuário.

## Integration/manual checks
Usar ambiente e dados sintéticos. QA manual em dispositivo, rede real/simulada ou backend de staging somente mediante gate apropriado; registrar versão, aparelho, condições, resultado e evidência. Golden não substitui usabilidade, TalkBack ou E2E.

## Full-suite gate
CI do SHA a integrar, checks obrigatórios verdes; resultados ausentes não são PASS. Falha exige correção ou restrição documentada e aprovada sem reduzir segurança ou integridade.
