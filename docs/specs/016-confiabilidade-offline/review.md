# Review — Spec 016

Status: `draft` | QA verdict: não emitido | Handoff: não iniciado

## Revisão de escopo
Objetivo: Permitir trabalho em campo com internet intermitente, preservando cada operação e evitando duplicação ou acesso indevido.
Dependências: 015 para merge; 020 para política de segurança; contrato Laravel para sessão/reconciliação.

## Pontos de revisão obrigatórios
- [ ] REQs rastreados a diff e testes, sem mudanças fora do contrato.
- [ ] Invariantes local-first, autorização, segurança e dados preservados.
- [ ] CI e checks manuais aplicáveis comprovados no SHA candidato; nenhuma execução local não autorizada.
- [ ] Riscos e decisões residuais explicitados, sem tratar proposta como implementação.
- [ ] Mefisto emite passed/failed/blocked/passed_with_restrictions; Jarvis fecha após aprovação humana.

## Riscos específicos
- TTL e autorização offline são decisões de segurança não congeladas.
- Revogação enquanto desconectado não pode ser detectada instantaneamente; risco residual precisa aceite.
