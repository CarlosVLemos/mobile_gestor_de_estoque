# Contract — Spec 016

Status: `DRAFT` | Version: 1 | Mode: `CRITICAL` | Human approval: pendente

Execution mode: `SINGLE_WRITER` para schema, contratos, auth/sync/outbox e arquivos compartilhados. `PARALLEL_SAFE` apenas com ownership explícito e até dois writers em paths distintos.

## Objetivo
Permitir trabalho em campo com internet intermitente, preservando cada operação e evitando duplicação ou acesso indevido.

## Remote contract
Contratos existentes: /api/mobile/me, auth/login, auth/logout, me/password e sale-intents create/get/confirm, conforme docs e implementação histórica. Maquiavel deve confirmar dev atual, códigos 401/403/422/429, validade token, perfil/revisão e replay. Não inventar refresh token ou endpoint de lease.

Campos, tipos, IDs, paginação, erros, permissões, tenant scope e idempotência que mudarem precisam de tabela de contrato auditada e SHA do backend antes de FROZEN. Ausência de contrato bloqueia a parte dependente, não autoriza inventar API.

## Local contract
Banco físico por userId+tenantId, secure storage; snapshot mínimo de perfil autorizado com TTL e integridade conforme 020; migration apenas se necessária e não destrutiva. Venda/outbox atômicas, CAS de revisão e checkpoints preservados; estado de processamento recuperável após crash.

## UI states
Banner offline com última atualização; CTA processando; estados aguardando envio/enviando/confirmada/revisão/não confirmada; bloqueio de sessão explicativo com ação de reconectar; nenhum erro bruto.

## Allowed paths (propostos, não autorização de escrita)
- lib/features/auth/**, lib/features/sales/application/**, lib/features/sales/presentation/controllers/**
- lib/core/sync/**, lib/core/config/**, lib/core/database/** (somente migration aprovada), lib/app/composition/** e lifecycle
- test/app/**, test/core/**, test/features/auth/**, test/features/sales/**; coordenação com 018 para controller/UI.

## Acceptance invariants
- **REQ-016-01** — Travar submissão no controller/use case na fronteira da operação e CTA ocupado; snapshot do carrinho e identidade estável por tentativa lógica; duas chamadas concorrentes não geram duas vendas. Retry após falha usa identidade quando resultado é incerto; nova venda deliberada recebe ID novo.
- **REQ-016-02** — Restaurar sessão normal via /me quando possível; offline somente com contexto previamente validado e política de validade aprovada. Nunca permitir primeiro login offline ou reutilizar identidade de outro contexto; não renovar TTL apenas por abrir app; relógio adulterado ou contexto inválido falha fechado.
- **REQ-016-03** — Distinguir offline, conexão sem API, erro transitório, credencial inválida, tenant suspenso e troca obrigatória de senha. Na reconexão revalidar sessão/permissões antes de drenar outbox; revogação bloqueia ações, preserva dados pendentes em quarentena sem envio não autorizado.
- **REQ-016-04** — Foreground reconecta com debounce, single-flight, cooldown/backoff e cancelamento contextual; não tratar Wi-Fi como prova de reachability. Garantir retry futuro com gatilho/timer controlado e sem polling agressivo; background best effort fica fora do gate inicial.
- **REQ-016-05** — Validar zona IANA existente, timezone configurável por operação/empresa conforme contrato; não inferir America/Sao_Paulo para Pará. Guardar timestamps e offset conforme contrato; não alterar datas históricas.
- **REQ-016-06** — Erros humanos sem Text(error) bruto; classificação tipada e mensagem acionável; logs sem PII/segredos. Nunca esconder cache válido por falha transitória nem chamar pendência de venda confirmada.
- **REQ-016-07** — Exercitar jornada de um dia desconectado: login prévio, múltiplas vendas, reinício, retomada e envio; perda zero e duplicação zero no cenário autorizado.

## Invariantes transversais
- Page → Controller → UseCase → Repository → DAO/API; domain sem Flutter, application sem Dio/Drift/JSON, presentation sem transporte/persistência.
- Contexto físico userId+tenantId; preço/estoque/autorização/confirmação remotos soberanos; demo isolado; price=null válido quando restrito.
- Nunca apagar pendências ou tratar intenção local como confirmada. Migration, ownership, rota, protocolo e contrato congelado só mudam via Change Request.
- Sem execução local de testes/analyze/format/build/codegen ou equivalentes sem autorização explícita. CI aprovado executa apenas comandos e gatilhos definidos na 015.

## Freeze checklist
- [ ] TTL offline, escopo de ações, política de dispositivo compartilhado/relógio e recuperação por revogação (proposta: janela limitada configurável; não congelar número sem negócio/segurança).
- [ ] Definir se comprovante offline existe e como rotulá-lo; sem comprovação definitiva até confirmação.
- [ ] Registrar SHA/base, paths definitivos, matriz de testes, riscos, responsável e aprovação humana.
