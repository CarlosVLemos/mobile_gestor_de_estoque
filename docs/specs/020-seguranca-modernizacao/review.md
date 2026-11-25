# Review — Spec 020

Status: `draft` | QA verdict: não emitido | Handoff: não iniciado

## Revisão de escopo
Objetivo: Reduzir risco de exposição de dados, abuso de acesso, perda de operações e dependências legadas antes do piloto.
Dependências: 015 para gates; começa junto com 016; bloqueia release 021.

## Pontos de revisão obrigatórios
- [ ] REQs rastreados a diff e testes, sem mudanças fora do contrato.
- [ ] Invariantes local-first, autorização, segurança e dados preservados.
- [ ] CI e checks manuais aplicáveis comprovados no SHA candidato; nenhuma execução local não autorizada.
- [ ] Riscos e decisões residuais explicitados, sem tratar proposta como implementação.
- [ ] Mefisto emite passed/failed/blocked/passed_with_restrictions; Jarvis fecha após aprovação humana.

## Riscos específicos
- MASVS é referência de verificação, não certificação.
- Decisão sobre proteção em repouso depende de requisitos e compatibilidade; não afirmar criptografia atual.
