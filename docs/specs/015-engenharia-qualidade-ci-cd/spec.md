# Spec 015 — Engenharia de qualidade, CI/CD e governança de IA

Estado: `draft` | Classificação: `CRITICAL` | Data: 2026-11-25

## Objetivo
Instituir uma cadeia de validação reproduzível, que permita agentes implementar e revisar sem executar comandos de validação localmente sem autorização.

## Dependências e rastreabilidade
Nenhuma; habilita os gates das demais specs.

Issues existentes relacionadas: 16, 17 (reconciliação de branches em conjunto com 021). A relação é temática e muitos-para-muitos, não equivale a fechamento de issue.

## Escopo
- GitHub Actions para push e pull_request; revisão, segurança, artefatos e evidências.
- Política de agentes, baseline Flutter/Dart, goldens, Drift codegen, proteção de branches e estratégia de atualização.

## Fora de escopo
- Deploy automático em produção; merge automático; reformatação geral misturada a mudanças funcionais.

## Requisitos e critérios de aceite
- **REQ-015-01** — Push: branches de trabalho, dev e main; gate rápido de lockfile, formatação definida, analyze e testes unitários/arquitetura. PR para dev/main: opened, synchronize, reopened, ready_for_review; suíte completa, widget/goldens, codegen e build Android sem credenciais de produção. Evitar duplicação de runs sem deixar checks obrigatórios ausentes.
- **REQ-015-02** — Fixar Flutter inicialmente em 3.44.1/Dart 3.12.1 conforme última evidência histórica; comprovar disponibilidade e runner antes de freeze. Fixar ações por SHA completo e revisar mudanças. Usar pubspec.lock; cache por SO/SDK/hash do lockfile, nunca tokens.
- **REQ-015-03** — Goldens: estabelecer baseline determinístico no runner (fontes versionadas, resolução, locale, tema, relógio); não regenerar automaticamente no CI; diferenças como artefato e aprovação humana. Drift: gerar em runner isolado e falhar por diff inesperado; não commitar arquivos automaticamente.
- **REQ-015-04** — CI read-only por padrão (`contents: read`), nenhum segredo em PR de fork; evitar pull_request_target para executar código de PR. Workflows de release separados; permissões mínimas por job; timeout e concurrency cancel-in-progress para PR obsoleto.
- **REQ-015-05** — Revisão de código por risco: arquitetura, concorrência, perda de dados, segurança, UX, contrato, testes e migrações; alterações em workflows/gates exigem revisão humana. Proibir enfraquecer asserções, ignorar falhas, atualizar baseline sem justificativa ou usar continue-on-error em gate obrigatório.
- **REQ-015-06** — Proteção dev/main: PR, checks estáveis obrigatórios, revisão humana de alterações críticas, checks do SHA a integrar e sem bypass cotidiano. Confirmar recursos disponíveis no plano; se indisponíveis, registrar limitação e gate manual.
- **REQ-015-07** — Dependências: varredura de pubspec.lock com scanner que suporte Dart, segredos e revisão de versões; bloquear vulnerabilidades críticas/altas exploráveis sem exceção documentada com validade; verificar suporte real antes de ativar.
- **REQ-015-08** — Agentes podem ler, editar e escrever testes em escopo aprovado; executar flutter test/analyze/build/dart format/codegen local ou via wrapper/MCP apenas com autorização explícita atual. CI remoto aprovado é exceção permanente para gatilhos e comandos congelados; push/PR/merge continuam sujeitos à política de escrita e autorização.

## Decisões antes do freeze
- [ ] Aprovar política de branches e gatilhos, runner, baseline de formatação inicial e checks obrigatórios.
- [ ] Aprovar a exceção de CI no AGENTS.md e nas regras de terminal/teste; não presumir autorização para comandos locais.

## Fechamento
Contrato aprovado; tarefas e critérios atendidos; evidência de CI do SHA candidato, checks manuais quando aplicáveis e veredito de Mefisto. Jarvis registra fechamento somente após gate humano. Nenhum teste local sem autorização explícita atual.
