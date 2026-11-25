# Review — Spec 023

Status: `draft` | QA verdict: não emitido | Handoff: não iniciado

## Revisão de escopo
Objetivo: Permitir negociação de preços com crédito individual do vendedor, sem comprometer controle financeiro, auditoria, isolamento e operação offline.
Dependências: 015, 016, 017, 018, 019, 020; antes de 021 somente se requisito de lançamento.

## Pontos de revisão obrigatórios
- [ ] REQs rastreados a diff e testes, sem mudanças fora do contrato.
- [ ] Invariantes local-first, autorização, segurança e dados preservados.
- [ ] CI e checks manuais aplicáveis comprovados no SHA candidato; nenhuma execução local não autorizada.
- [ ] Riscos e decisões residuais explicitados, sem tratar proposta como implementação.
- [ ] Mefisto emite passed/failed/blocked/passed_with_restrictions; Jarvis fecha após aprovação humana.

## Riscos específicos
- Regra histórica do Flex relatada em conversa não foi corroborada por documentação backend nesta rodada.
- Política financeira e de pagamento não congelada; não implementar por inferência.
- Offline não pode garantir disponibilidade global sem reserva antecipada; vendedor precisa informar condição ao cliente.
