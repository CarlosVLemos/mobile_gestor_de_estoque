# Quality gates e política de agentes

Status: proposta de alteração à governança — depende da aprovação da Spec 015. Não substitui AGENTS.md automaticamente.

## Matriz de execução
| Gatilho | Gate | Evidência |
| --- | --- | --- |
| Push em branch de trabalho/dev/main | Lockfile, format baseline, analyze, unit/architecture | status do commit e logs |
| PR opened/synchronize/reopened/ready_for_review para dev/main | Checks rápidos + suíte completa, widget/goldens, drift codegen, scanner, build Android sem segredo de produção | checks obrigatórios estáveis, relatórios/diffs e SHA |
| Semanal / mudança de lockfile | Dependências, segredos e revisão de risco | achados e exceções aprovadas |
| Homologação autorizada | Build assinado em ambiente protegido, smoke cross-repo e device | SHA, checksum, certificado e QA |
| Tag de release aprovada | Release protegido, sem código não confiável | versão, artefato, aprovação, runbook |

Proposta de comandos a validar no runner (não executados): flutter pub get --enforce-lockfile; dart format --output=none --set-exit-if-changed lib test; flutter analyze --no-pub --fatal-infos; flutter test --coverage; codegen Drift em ambiente isolado + diff; flutter build apk com configuração de teste. Fixar SDK e ações, auditar suporte antes de congelar; ajustes de baseline em PR separado. Evitar job duplicado para o mesmo SHA, mas nunca deixar check obrigatório ausente. Não autoatualizar goldens ou código gerado.

## Política de execução (proposta de texto para AGENTS.md e regras relacionadas)
Agentes podem inspecionar, escrever código/testes e revisar estaticamente dentro de escopo autorizado. É vedado executar localmente comandos de testes, analyze, format, build, codegen, integração, wrappers ou MCPs equivalentes sem autorização explícita, específica e atual do usuário. Não disparar serviços persistentes nem contornar por outro ambiente. Workflows remotos de CI aprovados pelo responsável são autorizados a executar automaticamente os comandos e gatilhos do contrato, em runners isolados; essa autorização não se estende a execução local, escrita remota arbitrária, merge, deploy ou release. Alterar workflow, permissões, gates ou baseline exige revisão humana. Na ausência de evidência, reportar NOT_RUN ou BLOCKED, jamais PASS.

## Julgamento de código
- Jarvis: escopo, ownership, contrato, dependências e fechamento.
- Maquiavel: auditoria real do Laravel, endpoints, permissões, tipos, versionamento e idempotência.
- Van Gogh: implementação e testes de comportamento, respeitando boundaries.
- Mefisto: revisão do diff, evidência CI do SHA, risco, critérios funcionais e veredito; não altera gate para aprovar.

Checklist PR: requisito/issue; contrato/SHA; paths e migrações; concorrência, perda de dados e replay; tenant/auth/financeiro; UX offline e acessibilidade; cobertura focada; resultados CI; risco residual, estratégia de atualização/reversão. Alterações críticas requerem revisão humana. Não adotar percentual global arbitrário de cobertura como substituto de casos críticos. Não aprovar PR vermelho, check ausente, segredo, bypass de TLS, regressão de migração, violação de arquitetura ou vulnerabilidade bloqueante sem tratamento aprovado. Exceções não podem mascarar falha de segurança/integridade.
