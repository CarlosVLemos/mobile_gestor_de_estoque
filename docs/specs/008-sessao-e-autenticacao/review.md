# Spec 008 — Revisão de abertura

## Status

Spec 008 implementada no Flutter, incluindo armazenamento seguro, sessão,
proteção de rotas, troca obrigatória de senha e sinalização global de 401.

O bloqueio histórico foi removido: REQ-046 materializou autenticação mobile
Sanctum no backend Laravel. Esta revisão conferiu a branch `dev`, commit
`cbc073d`, contra `routes/api.php`, requests, controllers, actions e as
evidências `SDD/spec/spec 46` (contrato congelado e validação aprovada).

## Contrato confirmado

- `POST /api/mobile/auth/login` é público, limitado por `mobile-login` e usa
  `access_code`, `password` e `device_name`.
- Login retorna token Bearer, usuário, tenant e `must_change_password`.
- `422 invalid_credentials`, `403 account_inactive`, `403 tenant_inactive`,
  `403 password_change_required` e `422 invalid_current_password` são
  semanticamente distintos e devem permanecer assim no mobile.
- `POST /api/mobile/auth/logout` revoga o token atual e é permitido mesmo na
  troca obrigatória de senha.
- `GET /api/mobile/me` retorna `data` (usuário, tenant, features e
  permissões) e `meta.revision`.
- `PUT /api/mobile/me/password` permanece acessível durante a troca
  obrigatória; sucesso limpa a flag no backend e mantém o token atual.
- Dashboard, produtos e `sale-intents` existem e são bloqueados pelo backend
  enquanto `must_change_password` estiver ativo. Eles não são escopo desta
  spec.

## Diferenças para a Spec anterior

- Removeu a rota de login antiga, o mock e a hipótese de login planejado.
- Substituiu o perfil sem envelope pelo contrato `data/meta.revision` real.
- Adicionou máquina de rota para `must_change_password`.
- Separou `401` de timeout/conectividade/cancelamento, que não invalidam token.
- Substituiu o callback acoplado `ApiClient -> AuthController` por sinalização
  neutra, preservando a direção core <- feature/composição.
- Registrou que a Spec 007 precisa transportar códigos remotos semânticos para
  que a feature não perca as distinções previstas pelo backend.

## Dependências e handoffs

- A dependência externa de login (DEP-001) foi satisfeita pelo REQ-046; não há
  autorização para inventar refresh token, ainda dependente de política.
- 008B recebe isolamento de contexto, banco e cache por usuário/tenant,
  inclusive a limpeza ordenada de recursos no logout.
- 009A recebe schema e persistência local de perfil/dados; esta spec não cria
  Drift nem promete experiência offline autenticada completa.
- A implementação deve confirmar a forma mínima de propagar `code` por cima
  de `NetworkFailureKind`, sem acoplar core a `features/auth`.

## Gate

**LIBERADO PARA IMPLEMENTAÇÃO.** O contrato remoto existe e foi auditado; o
trabalho seguinte deve seguir `tasks.md`, manter o escopo e executar a matriz
de `test.md`. Esta liberação não declara nenhum arquivo Dart como concluído.
