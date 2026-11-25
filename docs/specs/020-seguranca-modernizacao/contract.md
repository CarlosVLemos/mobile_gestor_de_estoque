# Contract — Spec 020

Status: `DRAFT` | Version: 1 | Mode: `CRITICAL` | Human approval: pendente

Execution mode: `SINGLE_WRITER` para schema, contratos, auth/sync/outbox e arquivos compartilhados. `PARALLEL_SAFE` apenas com ownership explícito e até dois writers em paths distintos.

## Objetivo
Reduzir risco de exposição de dados, abuso de acesso, perda de operações e dependências legadas antes do piloto.

## Remote contract
Backend continua autoridade de acesso, preços e tenant. Auditar autenticação, rate limits, revogação e autorização de objeto com Maquiavel; nenhuma alteração de endpoint presumida.

Campos, tipos, IDs, paginação, erros, permissões, tenant scope e idempotência que mudarem precisam de tabela de contrato auditada e SHA do backend antes de FROZEN. Ausência de contrato bloqueia a parte dependente, não autoriza inventar API.

## Local contract
Mudança de storage/crypto ou migration exige plano de upgrade, recuperação e compatibilidade; não apagar DB/outbox como reparo. Segredos via armazenamento seguro, chaves fora do repo.

## UI states
Mensagens claras de sessão/conta, sem detalhes técnicos; segurança com menor atrito compatível com risco; configurações administrativas complexas permanecem web.

## Allowed paths (propostos, não autorização de escrita)
- lib/core/network/**, lib/core/database/**, lib/features/auth/**, android/**, pubspec.yaml/lock
- test/core/**, test/features/auth/**, .github/** em coordenação 015, docs/security/**; backend mediante autorização separada.

## Acceptance invariants
- **REQ-020-01** — Modelar ameaças: aparelho perdido/compartilhado, backup/restauração indevida, tenant cruzado, token roubado, replay, alteração de preço/Flex, logs e build comprometido. Mapear controles MASVS STORAGE/AUTH/NETWORK/PLATFORM/CODE/PRIVACY conforme aplicabilidade.
- **REQ-020-02** — Auditar secure storage, token expiry/revogação, limpeza/logout e dados locais; separar contas fisicamente, testar acesso e preservar outbox sob quarentena. Avaliar necessidade de criptografia SQLite em repouso e gerenciamento de chaves via Keystore; app sandbox não equivale a criptografia; se adiada, risco e mitigação documentados.
- **REQ-020-03** — HTTPS com validação normal de certificado; release sem cleartext ou bypass de TLS, sem URL de produção hardcoded incorreta; segredos fora de código/APK/logs. Redigir headers/PII e tratar erros tipados.
- **REQ-020-04** — Android: verificar manifest, exported components, backups/extraction rules e permissões mínimas; considerar comportamento de restore e secure storage. Revisar update/rollback, versão e signing em 021.
- **REQ-020-05** — Auditar sqlite3_flutter_libs EOL e sqlite3/Drift; verificar documentação oficial e compatibilidade antes de remover/substituir. Atualizar em PRs pequenos, lockfile e migrations; evitar major upgrades simultâneos.
- **REQ-020-06** — Configurar Dependabot/scanner em 015; analisar CVEs de Flutter/Dart/Gradle e ações conforme suporte real. MobSF ou revisão de APK como complemento, não prova absoluta de segurança.
- **REQ-020-07** — LGPD: inventário de dados mínimos, retenção, acesso, exclusão/atendimento pelo backend; preservar registros que tenham obrigação legal; sem telemetria com nome, token, payload ou preços individualizados desnecessários.

## Invariantes transversais
- Page → Controller → UseCase → Repository → DAO/API; domain sem Flutter, application sem Dio/Drift/JSON, presentation sem transporte/persistência.
- Contexto físico userId+tenantId; preço/estoque/autorização/confirmação remotos soberanos; demo isolado; price=null válido quando restrito.
- Nunca apagar pendências ou tratar intenção local como confirmada. Migration, ownership, rota, protocolo e contrato congelado só mudam via Change Request.
- Sem execução local de testes/analyze/format/build/codegen ou equivalentes sem autorização explícita. CI aprovado executa apenas comandos e gatilhos definidos na 015.

## Freeze checklist
- [ ] Política de TTL e armazenamento offline com 016; critérios para criptografia em repouso e retenção; aprovar risco residual.
- [ ] Definir matriz de vulnerabilidades bloqueantes e processo de exceção com responsável, mitigação e prazo.
- [ ] Registrar SHA/base, paths definitivos, matriz de testes, riscos, responsável e aprovação humana.
