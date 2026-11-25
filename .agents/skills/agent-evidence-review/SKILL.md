---
name: agent-evidence-review
description: Use ao revisar entrega de agente, pull request, mudança de skill, qualidade de testes, evidência CI ou gate de spec. Não use para autoaprovar implementação ou executar validação local sem autorização.
---
# Revisão independente
1. Fixe base/head SHA e contrato, leia REQs, paths e diff. Se não houver SHA/contrato, registre limitação.
2. Inspecione estados e casos de erro; priorize integridade financeira, tenant, offline, concorrência, autorização, migração e experiência de vendedores. Verifique que testes provam comportamento e não foram enfraquecidos.
3. Registre achados com gravidade, arquivo/símbolo/linha, impacto, evidência e correção mínima; diferencie risco de reprodução.
4. Consulte CI do SHA e gates obrigatórios aprovados. Se ausência, pendência ou falha, use NOT_RUN/BLOCKED/FAIL conforme caso. Nunca invente output, não execute comandos por MCP/wrapper.
5. Se mudança de skill, avalie trigger positivo/negativo, fonte, escopo, injeção, custo e regressão; compare baseline/candidato quando autorizado. Autor não é revisor.
6. Entregue resultado conforme `.agents/templates/agent-result.yaml`; veredito não é autorização de merge. Não altere o código enquanto atua como avaliador read-only.
