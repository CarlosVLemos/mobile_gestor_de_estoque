# Review — Spec 017

Status: `draft` | QA verdict: não emitido | Handoff: não iniciado

## Revisão de escopo
Objetivo: Fazer o aplicativo legível, previsível e rápido para profissionais acima de 40 anos, sem pressupor baixa capacidade técnica.
Dependências: 015; contrato 018 para integração de campos; 016 para semântica offline.

## Pontos de revisão obrigatórios
- [ ] REQs rastreados a diff e testes, sem mudanças fora do contrato.
- [ ] Invariantes local-first, autorização, segurança e dados preservados.
- [ ] CI e checks manuais aplicáveis comprovados no SHA candidato; nenhuma execução local não autorizada.
- [ ] Riscos e decisões residuais explicitados, sem tratar proposta como implementação.
- [ ] Mefisto emite passed/failed/blocked/passed_with_restrictions; Jarvis fecha após aprovação humana.

## Riscos específicos
- QA manual não substituído por goldens.
- Amostra pequena não comprova representatividade estatística.
