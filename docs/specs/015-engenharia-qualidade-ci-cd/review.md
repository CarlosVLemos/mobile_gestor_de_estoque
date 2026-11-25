# Review — Spec 015

Status: `draft` | QA verdict: não emitido | Handoff: não iniciado

## Revisão de escopo
Objetivo: Instituir uma cadeia de validação reproduzível, que permita agentes implementar e revisar sem executar comandos de validação localmente sem autorização.
Dependências: Nenhuma; habilita os gates das demais specs.

## Pontos de revisão obrigatórios
- [ ] REQs rastreados a diff e testes, sem mudanças fora do contrato.
- [ ] Invariantes local-first, autorização, segurança e dados preservados.
- [ ] CI e checks manuais aplicáveis comprovados no SHA candidato; nenhuma execução local não autorizada.
- [ ] Riscos e decisões residuais explicitados, sem tratar proposta como implementação.
- [ ] Mefisto emite passed/failed/blocked/passed_with_restrictions; Jarvis fecha após aprovação humana.

## Riscos específicos
- Runner Linux pode divergir da referência Windows; baseline precisa aprovação visual.
- Proteção de branch pode depender do plano; não declarar ativada sem evidência.
- Dependências de ações e scanner precisam verificação na implementação.
