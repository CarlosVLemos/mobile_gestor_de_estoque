# Review — Spec 021

Status: `draft` | QA verdict: não emitido | Handoff: não iniciado

## Revisão de escopo
Objetivo: Distribuir Android de forma controlada, com API real e continuidade de dados entre versões, antes de liberar para toda a força de vendas.
Dependências: 015, 016, 017, 018, 019, 020; 022 baseline; 023 se Flex for requisito do piloto.

## Pontos de revisão obrigatórios
- [ ] REQs rastreados a diff e testes, sem mudanças fora do contrato.
- [ ] Invariantes local-first, autorização, segurança e dados preservados.
- [ ] CI e checks manuais aplicáveis comprovados no SHA candidato; nenhuma execução local não autorizada.
- [ ] Riscos e decisões residuais explicitados, sem tratar proposta como implementação.
- [ ] Mefisto emite passed/failed/blocked/passed_with_restrictions; Jarvis fecha após aprovação humana.

## Riscos específicos
- API de homologação e canal de distribuição não confirmados.
- Certificado debug incompatível com assinatura definitiva pode exigir plano específico de transferência/encerramento de pendências.
