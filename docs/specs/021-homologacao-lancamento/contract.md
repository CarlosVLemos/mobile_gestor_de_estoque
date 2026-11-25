# Contract — Spec 021

Status: `DRAFT` | Version: 1 | Mode: `CRITICAL` | Human approval: pendente

Execution mode: `SINGLE_WRITER` para schema, contratos, auth/sync/outbox e arquivos compartilhados. `PARALLEL_SAFE` apenas com ownership explícito e até dois writers em paths distintos.

## Objetivo
Distribuir Android de forma controlada, com API real e continuidade de dados entre versões, antes de liberar para toda a força de vendas.

## Remote contract
Confirmar endpoint real, prefixo, TLS, contrato backend por SHA e saúde de staging; não presumir VPS/API pronta ou S3. Smoke cross-repo com fixtures de homologação, sem dados reais.

Campos, tipos, IDs, paginação, erros, permissões, tenant scope e idempotência que mudarem precisam de tabela de contrato auditada e SHA do backend antes de FROZEN. Ausência de contrato bloqueia a parte dependente, não autoriza inventar API.

## Local contract
Preservar DB/outbox em upgrades; migration test por versão suportada. Segredos de assinatura em CI protegido; configuração por ambiente validada; artefatos vinculados ao SHA.

## UI states
Identidade e versão visíveis em suporte/Conta; estados de ambiente claros; mensagens de atualização sem exigir desinstalação destrutiva; demo distinguível.

## Allowed paths (propostos, não autorização de escrita)
- android/**, pubspec.yaml/lock, lib/core/config/**, .github/workflows/** (coordenação 015)
- docs/release/**, integration_test/** e testes de migração; operações de VPS/backend somente mediante autorização separada.

## Acceptance invariants
- **REQ-021-01** — Definir staging e produção com URLs HTTPS, APP_MODE e APP_TIMEZONE por build; demo isolado e explicitamente marcado, nunca fallback normal; impedir release normal com config ausente/inválida. Usar API Laravel homologada e contas sintéticas.
- **REQ-021-02** — Reconciliar main/dev por comparação atualizada, preservar ícone/identidade válida e validar diff; sem merge automático. Definir dev como integração, main como release e tags imutáveis após aprovação.
- **REQ-021-03** — Assinatura Android definitiva ou identidade de homologação separada, segredos no ambiente protegido do CI, não no repo; planejar migração de APK debug existente sem perder outbox (não desinstalar enquanto pendente). Definir applicationId, versionCode crescente, APK piloto/AAB se canal exigir, checksum e metadados do SHA.
- **REQ-021-04** — Staging release em merge autorizado dev ou dispatch aprovado; produção apenas tag/ambiente protegido/aprovação humana; release não usa artefato de PR não confiável. Manter credenciais separadas e revogáveis.
- **REQ-021-05** — Smoke: instalação limpa, login/troca senha, cold start online/offline autorizado, sync clientes/produtos, 5 itens e quantidade 100, rascunho, pendência, reconexão, proposta e aceite, histórico, atualização preservando dados, troca de contexto e logout. Flex somente se incluído no escopo.
- **REQ-021-06** — Piloto limitado a grupo de vendedores/gerentes com suporte, canal de feedback, matriz de aparelhos/Android e rede instável; observar erros e tarefas, não usar dados reais em fixtures.
- **REQ-021-07** — Go/no-go: CI verde no SHA, segurança sem bloqueantes, testes de migração e E2E aprovados, pendências de acessibilidade críticas resolvidas, política offline definida, rollback e atendimento prontos. Reversão Android exige plano forward-fix e compatibilidade de schema, não downgrade destrutivo.

## Invariantes transversais
- Page → Controller → UseCase → Repository → DAO/API; domain sem Flutter, application sem Dio/Drift/JSON, presentation sem transporte/persistência.
- Contexto físico userId+tenantId; preço/estoque/autorização/confirmação remotos soberanos; demo isolado; price=null válido quando restrito.
- Nunca apagar pendências ou tratar intenção local como confirmada. Migration, ownership, rota, protocolo e contrato congelado só mudam via Change Request.
- Sem execução local de testes/analyze/format/build/codegen ou equivalentes sem autorização explícita. CI aprovado executa apenas comandos e gatilhos definidos na 015.

## Freeze checklist
- [ ] Canal de distribuição (APK privado, Play interno/fechado), público do piloto, ambiente de staging e inclusão de Flex no primeiro release.
- [ ] Escolher identidade de assinatura antes da distribuição; definir estratégia de migração dos APKs debug existentes e suporte.
- [ ] Registrar SHA/base, paths definitivos, matriz de testes, riscos, responsável e aprovação humana.
