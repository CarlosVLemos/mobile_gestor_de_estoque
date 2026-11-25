# Review — Spec 022

Status: `draft` | QA verdict: não emitido | Handoff: não iniciado

## Revisão de escopo
Objetivo: Medir saúde operacional, adoção e desempenho com dados úteis e mínimos, sem transformar telemetria em vigilância ou sobrecarregar a rede.
Dependências: 015, 016 e 020; métricas comerciais da 019; baseline antes de 021, evolução pós-piloto.

## Pontos de revisão obrigatórios
- [ ] REQs rastreados a diff e testes, sem mudanças fora do contrato.
- [ ] Invariantes local-first, autorização, segurança e dados preservados.
- [ ] CI e checks manuais aplicáveis comprovados no SHA candidato; nenhuma execução local não autorizada.
- [ ] Riscos e decisões residuais explicitados, sem tratar proposta como implementação.
- [ ] Mefisto emite passed/failed/blocked/passed_with_restrictions; Jarvis fecha após aprovação humana.

## Riscos específicos
- Métricas de campo podem ter viés de conectividade; não inferir desempenho individual.
- Destino e custo de telemetria ainda não definidos.
