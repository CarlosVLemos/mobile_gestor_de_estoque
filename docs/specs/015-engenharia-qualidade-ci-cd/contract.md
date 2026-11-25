# Contract — Spec 015

Status: `DRAFT` | Version: 1 | Mode: `CRITICAL` | Human approval: pendente

Execution mode: `SINGLE_WRITER` para schema, contratos, auth/sync/outbox e arquivos compartilhados. `PARALLEL_SAFE` apenas com ownership explícito e até dois writers em paths distintos.

## Objetivo
Instituir uma cadeia de validação reproduzível, que permita agentes implementar e revisar sem executar comandos de validação localmente sem autorização.

## Remote contract
Nenhuma alteração de API. O CI usa fixtures isoladas e nunca dados/clientes reais; E2E com backend apenas em ambiente de homologação dedicado (021).

Campos, tipos, IDs, paginação, erros, permissões, tenant scope e idempotência que mudarem precisam de tabela de contrato auditada e SHA do backend antes de FROZEN. Ausência de contrato bloqueia a parte dependente, não autoriza inventar API.

## Local contract
Nenhuma mudança em schema ou runtime. Codegen é check reprodutível, não alteração automática; baseline de lint/formatação pode demandar PR isolado após medição.

## UI states
PR exibe resultado dos jobs, logs redigidos, relatório de testes e cobertura, diffs golden e artefatos de build sem segredos. Checks pendentes não equivalem a PASS.

## Allowed paths (propostos, não autorização de escrita)
- .github/workflows/**, .github/dependabot.yml, .github/pull_request_template.md (propostos)
- .agents/rules/**, AGENTS.md, test/AGENTS.md, docs/specs/AGENTS.md, docs/engineering/**
- test/architecture/** e scripts de CI apenas conforme contrato; mudanças de runtime fora do escopo.

## Acceptance invariants
- **REQ-015-01** — Push: branches de trabalho, dev e main; gate rápido de lockfile, formatação definida, analyze e testes unitários/arquitetura. PR para dev/main: opened, synchronize, reopened, ready_for_review; suíte completa, widget/goldens, codegen e build Android sem credenciais de produção. Evitar duplicação de runs sem deixar checks obrigatórios ausentes.
- **REQ-015-02** — Fixar Flutter inicialmente em 3.44.1/Dart 3.12.1 conforme última evidência histórica; comprovar disponibilidade e runner antes de freeze. Fixar ações por SHA completo e revisar mudanças. Usar pubspec.lock; cache por SO/SDK/hash do lockfile, nunca tokens.
- **REQ-015-03** — Goldens: estabelecer baseline determinístico no runner (fontes versionadas, resolução, locale, tema, relógio); não regenerar automaticamente no CI; diferenças como artefato e aprovação humana. Drift: gerar em runner isolado e falhar por diff inesperado; não commitar arquivos automaticamente.
- **REQ-015-04** — CI read-only por padrão (`contents: read`), nenhum segredo em PR de fork; evitar pull_request_target para executar código de PR. Workflows de release separados; permissões mínimas por job; timeout e concurrency cancel-in-progress para PR obsoleto.
- **REQ-015-05** — Revisão de código por risco: arquitetura, concorrência, perda de dados, segurança, UX, contrato, testes e migrações; alterações em workflows/gates exigem revisão humana. Proibir enfraquecer asserções, ignorar falhas, atualizar baseline sem justificativa ou usar continue-on-error em gate obrigatório.
- **REQ-015-06** — Proteção dev/main: PR, checks estáveis obrigatórios, revisão humana de alterações críticas, checks do SHA a integrar e sem bypass cotidiano. Confirmar recursos disponíveis no plano; se indisponíveis, registrar limitação e gate manual.
- **REQ-015-07** — Dependências: varredura de pubspec.lock com scanner que suporte Dart, segredos e revisão de versões; bloquear vulnerabilidades críticas/altas exploráveis sem exceção documentada com validade; verificar suporte real antes de ativar.
- **REQ-015-08** — Agentes podem ler, editar e escrever testes em escopo aprovado; executar flutter test/analyze/build/dart format/codegen local ou via wrapper/MCP apenas com autorização explícita atual. CI remoto aprovado é exceção permanente para gatilhos e comandos congelados; push/PR/merge continuam sujeitos à política de escrita e autorização.

## Invariantes transversais
- Page → Controller → UseCase → Repository → DAO/API; domain sem Flutter, application sem Dio/Drift/JSON, presentation sem transporte/persistência.
- Contexto físico userId+tenantId; preço/estoque/autorização/confirmação remotos soberanos; demo isolado; price=null válido quando restrito.
- Nunca apagar pendências ou tratar intenção local como confirmada. Migration, ownership, rota, protocolo e contrato congelado só mudam via Change Request.
- Sem execução local de testes/analyze/format/build/codegen ou equivalentes sem autorização explícita. CI aprovado executa apenas comandos e gatilhos definidos na 015.

## Freeze checklist
- [ ] Aprovar política de branches e gatilhos, runner, baseline de formatação inicial e checks obrigatórios.
- [ ] Aprovar a exceção de CI no AGENTS.md e nas regras de terminal/teste; não presumir autorização para comandos locais.
- [ ] Registrar SHA/base, paths definitivos, matriz de testes, riscos, responsável e aprovação humana.

## Extensão proposta — Harness v2 (015A/B/D)
- **REQ-015-09** — Quatro agentes canônicos, adaptadores nativos Codex/Antigravity, contextos e handoffs por tarefa, revisão independente; máximo de dois writers disjuntos, sem delegação recursiva; teto inicial de duas rodadas de rework.
- **REQ-015-10** — Evolução supervisionada de skills: autoria por qualquer papel, propostas não ativas, fonte/evidência, revisão independente, gate de ativação humano, rollback e registro. Nenhuma skill altera permissões ou contratos; scripts e ferramentas exigem análise separada.
- **REQ-015-11** — Shell desabilitado por padrão nos perfis suportados; sessão principal, MCPs, sandbox e tokens com privilégio mínimo; não presumir que instruções textuais ou allowlist isolada sejam controle completo. Provar descoberta e comportamento nas versões reais; nenhum comando local de validação sem autorização.
- **REQ-015-12** — Evals em fixtures sintéticas, comparando baseline/candidato no mesmo ambiente e modelo; verificar resultado, ações e violações, não só resposta. Zero violações de política crítica em cenários de referência; resultado ausente é NOT_RUN. Métricas de sucesso, rework e custo são observacionais, sem meta inventada.

### Paths adicionais propostos (não autorizam execução)
`.agents/agents/**`, `.agents/skills/**`, `.agents/policies/**`, `.agents/templates/**`, `.agents/learning/**`, `.agents/task-routing.md`, `.agents/subagents.md`, `.agents/quick-context.md`, `.agents/README.md`, `.codex/agents/**`, `.codex/config.toml`, `docs/engineering/agent-*.md`.

### Freeze adicional
- [ ] Validar versões Codex/Antigravity, descoberta, permissões herdadas, ferramentas disponíveis e bloqueio local; aprovar modelo/effort e mecanismo de ativação de skills.
- [ ] Aprovar extensão e artefatos; registrar SHA e responsável. Até lá não executar gates automaticamente nem ativar novas permissões.
