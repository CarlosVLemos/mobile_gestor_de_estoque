# Spec 021 — Homologação, distribuição e lançamento

Estado: `draft` | Classificação: `CRITICAL` | Data: 2026-11-25

## Objetivo
Distribuir Android de forma controlada, com API real e continuidade de dados entre versões, antes de liberar para toda a força de vendas.

## Dependências e rastreabilidade
015, 016, 017, 018, 019, 020; 022 baseline; 023 se Flex for requisito do piloto.

Issues existentes relacionadas: 4, 17. A relação é temática e muitos-para-muitos, não equivale a fechamento de issue.

## Escopo
- Staging na VPS, ambientes, assinatura, CI/CD release, artefatos, piloto, runbook e critérios go/no-go.
- Reconciliação main/dev, versionamento e testes E2E em aparelho real.

## Fora de escopo
- Deploy produção sem aprovação; iOS no primeiro piloto sem decisão; S3 obrigatório; usar assinatura debug como definitiva.

## Requisitos e critérios de aceite
- **REQ-021-01** — Definir staging e produção com URLs HTTPS, APP_MODE e APP_TIMEZONE por build; demo isolado e explicitamente marcado, nunca fallback normal; impedir release normal com config ausente/inválida. Usar API Laravel homologada e contas sintéticas.
- **REQ-021-02** — Reconciliar main/dev por comparação atualizada, preservar ícone/identidade válida e validar diff; sem merge automático. Definir dev como integração, main como release e tags imutáveis após aprovação.
- **REQ-021-03** — Assinatura Android definitiva ou identidade de homologação separada, segredos no ambiente protegido do CI, não no repo; planejar migração de APK debug existente sem perder outbox (não desinstalar enquanto pendente). Definir applicationId, versionCode crescente, APK piloto/AAB se canal exigir, checksum e metadados do SHA.
- **REQ-021-04** — Staging release em merge autorizado dev ou dispatch aprovado; produção apenas tag/ambiente protegido/aprovação humana; release não usa artefato de PR não confiável. Manter credenciais separadas e revogáveis.
- **REQ-021-05** — Smoke: instalação limpa, login/troca senha, cold start online/offline autorizado, sync clientes/produtos, 5 itens e quantidade 100, rascunho, pendência, reconexão, proposta e aceite, histórico, atualização preservando dados, troca de contexto e logout. Flex somente se incluído no escopo.
- **REQ-021-06** — Piloto limitado a grupo de vendedores/gerentes com suporte, canal de feedback, matriz de aparelhos/Android e rede instável; observar erros e tarefas, não usar dados reais em fixtures.
- **REQ-021-07** — Go/no-go: CI verde no SHA, segurança sem bloqueantes, testes de migração e E2E aprovados, pendências de acessibilidade críticas resolvidas, política offline definida, rollback e atendimento prontos. Reversão Android exige plano forward-fix e compatibilidade de schema, não downgrade destrutivo.

## Decisões antes do freeze
- [ ] Canal de distribuição (APK privado, Play interno/fechado), público do piloto, ambiente de staging e inclusão de Flex no primeiro release.
- [ ] Escolher identidade de assinatura antes da distribuição; definir estratégia de migração dos APKs debug existentes e suporte.

## Fechamento
Contrato aprovado; tarefas e critérios atendidos; evidência de CI do SHA candidato, checks manuais quando aplicáveis e veredito de Mefisto. Jarvis registra fechamento somente após gate humano. Nenhum teste local sem autorização explícita atual.
