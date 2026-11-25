# Review — Spec 018

Status: `draft` | QA verdict: não emitido | Handoff: não iniciado

## Revisão de escopo
Objetivo: Reduzir esforço de vendas presenciais, com busca rápida, carrinho editável e retomada de trabalho em regiões remotas.
Dependências: 015, 016 (registro), 017 (componentes); 023 para preço negociado/Flex.

## Pontos de revisão obrigatórios
- [ ] REQs rastreados a diff e testes, sem mudanças fora do contrato.
- [ ] Invariantes local-first, autorização, segurança e dados preservados.
- [ ] CI e checks manuais aplicáveis comprovados no SHA candidato; nenhuma execução local não autorizada.
- [ ] Riscos e decisões residuais explicitados, sem tratar proposta como implementação.
- [ ] Mefisto emite passed/failed/blocked/passed_with_restrictions; Jarvis fecha após aprovação humana.

## Riscos específicos
- Migração e controller competem com 016/019/023: SINGLE_WRITER no schema e arquivos compartilhados.
- Busca rápida depende do aparelho e volume; meta não é evidência de performance.
