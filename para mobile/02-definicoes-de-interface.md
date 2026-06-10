# Definicoes de Interface

## Direcao visual

Baseado em `para mobile/designmobile.md`, o app mobile deve preservar a assinatura visual atual do sistema:

- identidade operacional, fria e analitica;
- predominio de azul;
- superficies claras;
- cards compactos;
- destaque claro para estados de sucesso, alerta e erro.

## Tokens visuais principais

### Cores

- fundo principal: `hsl(210 33% 98%)`
- texto principal: `hsl(215 34% 15%)`
- superficie card: `hsl(0 0% 100%)`
- cor primaria: `hsl(213 77% 46%)`
- borda: `hsl(214 23% 88%)`
- sucesso: `hsl(152 60% 42%)`
- alerta: `hsl(38 92% 50%)`
- erro: `hsl(348 83% 55%)`

### Tipografia

- fonte base: `Instrument Sans`
- titulos: compactos, `semibold` ou `bold`
- labels: pequenas, com tracking maior, frequentemente em uppercase
- texto auxiliar: `text-sm`, leitura objetiva

## Estrutura minima de telas

### 1. Splash / validacao de sessao

Responsabilidade:

- validar token ou sessao disponivel;
- carregar perfil do usuario;
- decidir se o app entra em dashboard ou pede autenticacao.

Estados:

- carregando;
- sessao valida;
- sessao expirada;
- tenant inativo ou bloqueado.

### 2. Home / Dashboard mobile

Dados esperados:

- KPIs resumidos;
- alertas de estoque;
- movimentos recentes;
- link para abrir dashboard web quando necessario.

Estados:

- carregando;
- sem dados suficientes;
- com restricao financeira;
- erro de rede/autenticacao.

### 3. Catalogo de produtos

Dados esperados por item:

- nome;
- SKU;
- marca;
- status de estoque;
- saldo atual;
- disponibilidade para venda;
- categoria quando existir;
- preco somente quando o usuario puder ver financeiro;
- `updated_at` para sincronizacao.

Estados:

- lista carregando;
- lista vazia;
- filtros sem resultado;
- sem permissao para catalogo;
- feature catalogo desativada.

### 4. Perfil / contexto operacional

Dados esperados:

- usuario autenticado;
- tenant atual;
- features ativas;
- mapa de permissoes relevantes.

Uso:

- liberar ou ocultar modulos no app;
- mostrar contexto da empresa;
- controlar exibicao de precos e acoes de venda.

## Componentes mobile recomendados

### Card de KPI

Deve suportar:

- titulo curto;
- valor principal;
- subtitulo opcional;
- estado restrito quando o dado for sensivel.

### Card de produto

Deve suportar:

- nome e SKU;
- marca;
- badge de estoque: `available`, `low` ou `out`;
- preco opcional;
- imagem opcional;
- acao futura de adicionar a uma venda local.

### Lista de movimentos recentes

Deve suportar:

- produto;
- tipo de movimento;
- quantidade;
- data/hora;
- leitura compacta para uso em campo.

## Estados de erro obrigatorios

O app precisa tratar pelo menos:

- `401`: autenticacao ausente ou expirada;
- `403`: permissao insuficiente ou feature bloqueada;
- `422`: filtros invalidos;
- `429`: excesso de requisicoes;

## Regra de comportamento visual importante

O app mobile nao deve assumir que ausencia de preco e erro de backend.

Quando `price` vier `null`, a interpretacao correta e:

- usuario sem permissao financeira; ou
- dado propositalmente mascarado para esse perfil.
