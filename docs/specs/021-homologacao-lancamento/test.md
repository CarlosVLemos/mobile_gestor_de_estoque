# Test matrix — Spec 021

Estado: `NOT_RUN` — cenários planejados, não resultados.

| ID | Cenário | Nível | Resultado esperado | Evidência |
| --- | --- | --- | --- | --- |
| QA-021-01 | Build normal sem URL/timezone | CI | Falha de configuração; não usa demo como fallback. | NOT_RUN |
| QA-021-02 | APK release e certificado | CI/manual | Assinatura e applicationId corretos; nenhum segredo exposto. | NOT_RUN |
| QA-021-03 | Upgrade da versão anterior com outbox | Integration/manual | Instalação válida e nenhuma perda de pendências. | NOT_RUN |
| QA-021-04 | Ciclo completo em staging | E2E | Login, sync, offline, venda e reconciliação comprovados. | NOT_RUN |
| QA-021-05 | Tag sem aprovação de produção | CI | Publicação não ocorre. | NOT_RUN |
| QA-021-06 | Incidente após piloto | Tabletop | Suporte/forward-fix e recuperação documentados. | NOT_RUN |

## Static checks
Revisar contrato, boundaries, dados restritos, mensagens, migrações e concorrência conforme escopo. CI aprovado: format/analyze/architecture, testes focados e suíte completa no PR; goldens e build quando aplicáveis. Não rodar localmente sem pedido explícito do usuário.

## Integration/manual checks
Usar ambiente e dados sintéticos. QA manual em dispositivo, rede real/simulada ou backend de staging somente mediante gate apropriado; registrar versão, aparelho, condições, resultado e evidência. Golden não substitui usabilidade, TalkBack ou E2E.

## Full-suite gate
CI do SHA a integrar, checks obrigatórios verdes; resultados ausentes não são PASS. Falha exige correção ou restrição documentada e aprovada sem reduzir segurança ou integridade.
