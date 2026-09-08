# Spec 008: Sessão e Autenticação

## Problema

O app ainda entra na shell por bootstrap local e perfil fixture. A API mobile
Laravel já oferece sessão Sanctum real, mas o cliente não possui persistência
segura do token, resolução de perfil, proteção de rotas nem o fluxo obrigatório
de troca de senha.

## Objetivo

Implementar sessão mobile usando o contrato existente da API: login com
`access_code`, token Sanctum, logout, perfil em `/api/mobile/me`, troca de
senha e redirecionamento reativo. O servidor continua soberano para token,
conta, tenant, permissões, features e bloqueio operacional.

## Escopo

- `POST /api/mobile/auth/login`, `POST /api/mobile/auth/logout`,
  `GET /api/mobile/me` e `PUT /api/mobile/me/password`;
- persistência exclusiva do token no `flutter_secure_storage`;
- estado de sessão, bootstrap, tela de login, troca obrigatória de senha e
  proteção declarativa de rotas;
- sinalização desacoplada de `401` para encerrar a sessão;
- testes de contrato, unidade, widget e rotas.

## Fora de Escopo

- refresh token ou renovação automática: não existe nesse contrato Sanctum;
- Drift, persistência de perfil, isolamento de banco/cache, sync e outbox;
- implementação ou mudança de `sale-intents`;
- recuperação de senha, cadastro e alteração de regras do backend.

## Contrato remoto auditado

Fonte: backend `CarlosVLemos/gestor_de_estoque`, branch `dev`, commit
`cbc073d`; `routes/api.php`, controladores e REQ-046. Prefixo: `/api/mobile`.

### Login — `POST /api/mobile/auth/login`

Rota pública com `throttle:mobile-login`. Envia:

```json
{
  "access_code": "AR-CBN-0142-7K4M",
  "password": "segredo",
  "device_name": "Dispositivo Vendas 1"
}
```

Todos os campos são obrigatórios; `access_code` e `device_name` têm máximo de
100 caracteres e `password`, 1024. Sucesso (`200`):

```json
{
  "token": "plain-text-token-once",
  "token_type": "Bearer",
  "must_change_password": false,
  "user": { "id": "uuid", "name": "João", "access_code": "AR-CBN-0142-7K4M" },
  "tenant": { "id": "uuid", "slug": "cbnmotos", "name": "CBN Motos" }
}
```

`422` pode conter validação de campos ou `code: invalid_credentials`. `403`
preserva os códigos `account_inactive` e `tenant_inactive`. `429` decorre do
limiter de login. A camada de dados deve preservar o `code` remoto para que a
aplicação apresente estados acionáveis, sem reduzir esses casos a uma mensagem
genérica.

### Logout — `POST /api/mobile/auth/logout`

Exige `Authorization: Bearer <token>`, `auth:sanctum` e conta válida. Revoga o
token atual e retorna `200` com `message`. É permitido durante
`must_change_password`. Depois de uma resposta, inclusive uma resposta local
de sessão inválida, o cliente remove o token seguro; falha de rede no logout
não prova que a revogação ocorreu e precisa de estado explícito.

### Perfil — `GET /api/mobile/me`

Exige Sanctum, conta e tenant válidos. Retorna o envelope real:

```json
{
  "data": {
    "user": { "id": "uuid", "name": "João", "email": "joao@empresa.test" },
    "tenant": { "id": "uuid", "name": "CBN Motos", "slug": "cbnmotos" },
    "features": ["catalog", "sales"],
    "permissions": {
      "products_view": true,
      "sales_create": true,
      "reports_view": false,
      "view_financial_metrics": false
    }
  },
  "meta": { "revision": "profile_<hash-estavel>" }
}
```

`revision` identifica de forma estável o conteúdo do perfil. Nesta spec ele é
consumido no modelo de sessão; cache/persistência de perfil e estratégia de
reconciliação pertencem às Specs 008B/009A e posteriores.

### Senha — `PUT /api/mobile/me/password`

Exige token, conta e tenant válidos. Envia `current_password`, `password` e
`password_confirmation` (as regras de senha são as do backend). Retorna `200`
com mensagem; senha atual incorreta retorna `422` com
`code: invalid_current_password`. O backend limpa `must_change_password` e
revoga os outros tokens ativos, preservando o token atual.

### Troca obrigatória de senha

O login informa `must_change_password`. Quando verdadeiro, o usuário está
autenticado, mas o backend bloqueia dashboard, produtos e `sale-intents` com
`403` e `code: password_change_required`. `/me`, logout e alteração da própria
senha continuam permitidos. O fluxo obrigatório no app é:

```text
sem token -> login
token existente ou login concluído -> resolver /me
must_change_password?
  sim -> /change-password (logout e troca de senha permitidos)
  não -> shell operacional
```

A UI não pode ignorar a flag; o redirecionamento local é proteção de UX e não
substitui o middleware remoto.

## Segurança e fronteiras

- Token Sanctum apenas em `flutter_secure_storage`; nunca em
  SharedPreferences, logs, estado de widget ou fixtures de produção.
- Chamadas autenticadas recebem `Authorization: Bearer <token>` na camada de
  dados. Não há refresh token a inventar.
- `presentation` não conhece Dio ou secure storage; `application` não conhece
  Dio, JSON nem storage concreto; `domain` expõe entidades e contratos.
- Estrutura esperada: `domain` (sessão/repositório), `application` (casos de
  uso), `data` (DTOs, fonte remota, storage e repositório) e `presentation`
  (controller, estado e páginas).
- O core de rede não importa `features/auth`. Um contrato/notifier neutro de
  sessão inválida é emitido pelo limite de rede e observado/comandado pela
  composição da aplicação; o controller executa logout local. A dependência é
  aplicação/feature -> core, nunca core -> presentation.

## Bootstrap, 401 e conectividade

No startup, a ausência de token leva a `/login`. Com token, o app restaura a
sessão e consulta `/me`. `401` significa token inválido/expirado: remover token
seguro, invalidar estado de sessão e redirecionar para login. Timeout,
conectividade ou cancelamento não provam token inválido e não podem provocar
logout automático.

Sem persistência de perfil/contexto, a experiência offline autenticada completa
não entra nesta spec. O controller deve expor indisponibilidade recuperável e
preservar o token até prova de `401`; a decisão de quais dados locais podem ser
exibidos fica para 008B/009A, sem introduzir Drift aqui.

## Critérios de aceite

- O contrato acima é usado sem mock de autenticação de produção.
- Login preserva os códigos semânticos documentados e armazena apenas o token
  em storage seguro.
- `/me` interpreta `data`, `meta.revision`, features e permissões reais.
- Rotas públicas, shell e `/change-password` obedecem à máquina de sessão e à
  flag `must_change_password`.
- `401` global encerra sessão por mecanismo desacoplado; falha de rede não.
- Logout, troca obrigatória de senha, tokens e redaction possuem testes
  proporcionais ao risco.
- Nenhuma camada viola MOB-002, MOB-003, MOB-006, MOB-007 ou MOB-008.
