# Contexto Rapido

## O que este projeto e hoje

- App Flutter mobile do Arara-Gastos.
- Base arquitetural ja existe em `lib/`.
- Shell principal pronta com `Painel`, `Produtos`, `Vendas` e `Mais`.
- Estado e injecao via Riverpod.
- Navegacao via `go_router`.
- Tema claro/escuro, tokens visuais e toggle local de tema.
- Drawer lateral operacional compartilhado.
- Dashboard, catalogo e vendas ainda usam fixtures ou estado local em memoria.

## O que ainda nao existe de verdade

- autenticacao mobile por token;
- cliente Dio materializado;
- banco Drift materializado;
- armazenamento seguro para sessao;
- sync incremental real;
- outbox persistente real;
- vendas offline reais com integracao remota;
- isolamento definitivo de dados por usuario/tenant no banco local.

Nao assumir que esses itens existem so porque aparecem na arquitetura ou nas
novas specs.

## Fluxo arquitetural obrigatorio

`Page -> Controller -> UseCase -> Repository -> DAO/API`

Restricoes:

- `presentation` nao acessa Dio ou Drift;
- `application` nao conhece Dio, Drift, JSON ou widgets;
- `domain` nao conhece Flutter, persistencia ou transporte;
- UI nao transforma pendencia offline em confirmacao remota.

## Features reais no codigo hoje

- `dashboard`
- `catalog`
- `sales`
- `settings` com contexto operacional e area `Mais`

## Regras de produto que pegam facil

- multi-tenant obrigatorio;
- permissao visual nao substitui autorizacao remota;
- `price = null` pode ser restricao valida;
- produto sem estoque continua podendo aparecer no catalogo;
- contrato planejado nao pode ser tratado como implementado.

## Armadilhas de UI que nao podem voltar

- evitar overflow horizontal em mobile;
- cards com conteudo principal e trailing precisam de `Expanded`/`Flexible` ou
  reflow vertical;
- validar componentes compactos com `textScaler` alto;
- em largura estreita, prefira quebrar para baixo a comprimir tudo na mesma
  linha.

## Evidencias fortes do projeto

- estrutura por feature e camada;
- shell operacional reutilizavel;
- testes de widget e goldens;
- cuidado explicito com responsividade mobile;
- tela de vendas local ja exercitada por teste.

## Leitura canonicamente obrigatoria antes de implementar

- `AGENTS.md`
- `para mobile/00-contexto-operacional.md`
