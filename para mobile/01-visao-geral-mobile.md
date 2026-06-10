# Visao Geral Mobile

## Objetivo

O mobile deve funcionar como uma extensao operacional do monolito Laravel atual, sem backend paralelo.

Ele precisa cobrir, no minimo:

- leitura rapida do contexto do usuario autenticado;
- dashboard resumido;
- catalogo de produtos para consulta em campo;
- preparo para futuras vendas offline com sincronizacao segura.

## O que ja existe hoje

### Endpoints ativos

- `GET /api/mobile/me`
- `GET /api/mobile/dashboard`
- `GET /api/mobile/products`

### Dependencias de acesso

Todos os endpoints mobile atuais exigem:

- autenticacao;
- tenancy inicializada pelo usuario;
- acesso ao tenant do usuario;
- tenant ativo;
- throttle `60` requisicoes por minuto.

### Restricoes atuais

- Ainda nao existe login mobile com token Sanctum implementado.
- Ainda nao existe endpoint de criacao/sincronizacao de vendas mobile.
- Ainda nao existe camada mobile para relatorios.

## O que o app mobile deve assumir

### Fonte de verdade

- O servidor e a fonte de verdade para tenant, permissoes, features, estoque e dados financeiros.
- O app nao deve inferir permissao por tela escondida.
- O app nao deve assumir que todo usuario pode ver preco ou indicadores financeiros.

### Experiencia esperada

- fluxo operacional rapido;
- leitura compacta de estoque, disponibilidade e alertas;
- navegacao simples, com foco em dashboard e catalogo;
- capacidade futura de sincronizacao offline sem corromper estoque.

## Direcao de evolucao ja planejada

A `Spec 22` define como proximo passo:

- login mobile com Sanctum;
- sincronizacao incremental de catalogo;
- relatorios simples;
- venda offline via intencao de venda;
- proposta ajustada quando faltar estoque;
- confirmacao explicita antes de criar venda ajustada.
