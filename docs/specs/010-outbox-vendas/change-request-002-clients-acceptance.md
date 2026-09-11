# Change Request 010-002 — clientes local-first e aceite persistente

Status: `ACCEPTED / FROZEN`
Data: 2026-09-11
Modo: `CRITICAL`
Autorização humana: pedido explícito desta execução
Backend auditado: `CarlosVLemos/gestor_de_estoque dev@f8ff65e036a4ce4527ffe6c36519fbd717b0524b`

## Delta aprovado

- o backend resolveu `BLOCKER-010-CLIENTS` e `BLOCKER-010-CONFIRMATION-RECOVERY`;
- consumir `GET /api/mobile/clients` com cursor opaco tenant-bound, snapshot fixo e reconciliação por ausência somente após snapshot completo;
- evoluir Drift v4 para v5, adicionando `clients` mínima e estado durável de membros do snapshot em andamento;
- conectar produtos/clientes Drift e `RegisterSaleUseCase` à UI, sem fixture/fallback em `normal`;
- persistir `intent`, proposta, token e revisão em `requires_acceptance`;
- exigir aceite humano por CAS; `stock_proposal_changed` substitui proposta/token, incrementa revisão e exige novo aceite;
- tratar replay idêntico `409 requires_confirmation` como recovery funcional;
- absorver a Spec 013D no mesmo schema v5, sem token ou HTTP no demo.

## Contrato remoto congelado

`GET /api/mobile/clients` aceita `cursor` e `per_page` (mobile usa 50). Cada item contém somente `id` inteiro positivo, `name`, `city?` e `state?`. `meta` contém `next_cursor?`, `has_more` e `snapshot_upper_bound_id`. Cursor inválido/adulterado/cross-tenant retorna 422. Não há tombstones; hard delete é reconciliado por ausência no snapshot completo seguinte.

Replay idêntico de uma intent não expirada em `requires_confirmation` retorna 409 com a mesma intent/proposta e novo token. O token anterior é invalidado; tentativas, expiração e proposta permanecem. GET continua read-only e sem token. Replay confirmado permanece 200 somente com `intent.state == confirmed`.

## Timezone

O backend exige nome IANA. Como as dependências atuais não fornecem a timezone IANA do dispositivo, produção exige `--dart-define=APP_TIMEZONE=<IANA>` e falha fechado quando ausente/inválida. Não se usa `DateTime.timeZoneName`, abreviação nem offset como substituto.

## Gates

Migrações fresh/v1/v2/v3/v4→v5, sync multi-page/restart/poda terminal, isolamento, composition normal/demo, persistência/aceite/recovery/proposal changed, testes focados, suíte completa, análise e `git diff --check`.
