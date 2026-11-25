# Spec 020 — Segurança e modernização tecnológica

Estado: `draft` | Classificação: `CRITICAL` | Data: 2026-11-25

## Objetivo
Reduzir risco de exposição de dados, abuso de acesso, perda de operações e dependências legadas antes do piloto.

## Dependências e rastreabilidade
015 para gates; começa junto com 016; bloqueia release 021.

Issues existentes relacionadas: 19; segurança transversal às demais. A relação é temática e muitos-para-muitos, não equivale a fechamento de issue.

## Escopo
- Threat model MASVS adaptado ao negócio, armazenamento/auth/transporte/privacidade, Android hardening, dependências e atualização controlada.
- Classificar achados por explorabilidade/impacto; critérios de release e exceções com prazo.

## Fora de escopo
- Criptografia improvisada, pinning obrigatório sem estratégia de rotação, atualização indiscriminada, coleta de PII para telemetria.

## Requisitos e critérios de aceite
- **REQ-020-01** — Modelar ameaças: aparelho perdido/compartilhado, backup/restauração indevida, tenant cruzado, token roubado, replay, alteração de preço/Flex, logs e build comprometido. Mapear controles MASVS STORAGE/AUTH/NETWORK/PLATFORM/CODE/PRIVACY conforme aplicabilidade.
- **REQ-020-02** — Auditar secure storage, token expiry/revogação, limpeza/logout e dados locais; separar contas fisicamente, testar acesso e preservar outbox sob quarentena. Avaliar necessidade de criptografia SQLite em repouso e gerenciamento de chaves via Keystore; app sandbox não equivale a criptografia; se adiada, risco e mitigação documentados.
- **REQ-020-03** — HTTPS com validação normal de certificado; release sem cleartext ou bypass de TLS, sem URL de produção hardcoded incorreta; segredos fora de código/APK/logs. Redigir headers/PII e tratar erros tipados.
- **REQ-020-04** — Android: verificar manifest, exported components, backups/extraction rules e permissões mínimas; considerar comportamento de restore e secure storage. Revisar update/rollback, versão e signing em 021.
- **REQ-020-05** — Auditar sqlite3_flutter_libs EOL e sqlite3/Drift; verificar documentação oficial e compatibilidade antes de remover/substituir. Atualizar em PRs pequenos, lockfile e migrations; evitar major upgrades simultâneos.
- **REQ-020-06** — Configurar Dependabot/scanner em 015; analisar CVEs de Flutter/Dart/Gradle e ações conforme suporte real. MobSF ou revisão de APK como complemento, não prova absoluta de segurança.
- **REQ-020-07** — LGPD: inventário de dados mínimos, retenção, acesso, exclusão/atendimento pelo backend; preservar registros que tenham obrigação legal; sem telemetria com nome, token, payload ou preços individualizados desnecessários.

## Decisões antes do freeze
- [ ] Política de TTL e armazenamento offline com 016; critérios para criptografia em repouso e retenção; aprovar risco residual.
- [ ] Definir matriz de vulnerabilidades bloqueantes e processo de exceção com responsável, mitigação e prazo.

## Fechamento
Contrato aprovado; tarefas e critérios atendidos; evidência de CI do SHA candidato, checks manuais quando aplicáveis e veredito de Mefisto. Jarvis registra fechamento somente após gate humano. Nenhum teste local sem autorização explícita atual.
