# Contexto Operacional Mobile

## Para que serve

Este e o primeiro documento a ser lido por pessoas e agentes antes de trabalhar
no aplicativo. Ele resume o estado atual, as decisoes fixas e indica onde
buscar detalhes sem reler toda a pasta.

## Estado atual

- A fundacao Flutter ja esta materializada em `lib/`, com tema claro/escuro,
  bootstrap, `go_router`, Riverpod e organizacao inicial por feature e camada.
- O app ja usa uma shell operacional com quatro destinos principais:
  dashboard, catalogo, vendas e Mais.
- Existe toggle local de tema, drawer lateral compartilhado e headers
  operacionais consistentes entre as telas principais.
- Dashboard, catalogo e vendas ainda usam fixtures, estado local em memoria ou
  repositorios locais. Eles nao comprovam integracao remota, persistencia local
  definitiva nem sincronizacao.
- A tela de vendas deixou de ser apenas placeholder: hoje ja permite selecionar
  cliente, montar carrinho, respeitar restricao financeira local e registrar
  rascunhos nao persistidos em memoria.
- Existem contratos remotos documentados para perfil, dashboard e produtos.
- Autenticacao mobile por token e vendas offline reais continuam dependentes de
  contratos ainda nao implementados.
- Drift, Dio, armazenamento seguro, sincronizacao incremental e outbox seguem
  como arquitetura aceita, mas ainda nao estao materializados no app.
- As specs `007`, `008`, `008b`, `009a`, `009b`, `009c` e `010` ja foram
  abertas como documentacao de proxima fase, mas nao representam codigo pronto.
- Documentacao descreve intencao e decisoes; somente codigo, testes e
  evidencias de execucao comprovam o que ja existe.

## Situacao do working tree

Fotografia em 18 de junho de 2026:

- branch `main`, alinhada a `origin/main`;
- existem alteracoes nao commitadas em codigo, testes, goldens e documentacao;
- a feature `sales` saiu da condicao de pasta vazia e agora possui entidades,
  repositorio fixture, controllers, pagina e testes;
- ha novas specs em `docs/specs/006-*`, `007-*`, `008-*`, `008b-*`, `009a-*`,
  `009b-*`, `009c-*` e `010-*`;
- ha arquivos novos em `.agents/` com apoio local de contexto e roteamento;
- o retrato anterior de 15 de junho, com staged e unstaged antigos da Spec 005,
  nao descreve mais o estado real atual.

Antes de publicar:

1. revisar artefatos em `test/goldens/failures/`;
2. separar commits por responsabilidade;
3. validar shell, dashboard, catalogo e vendas em largura mobile compacta e com
   `textScaler` alto;
4. nao tratar specs novas de infraestrutura como implementacao.

## Produto

O app e uma extensao operacional mobile do Arara-Gastos.

Prioridades:

1. contexto do usuario e da empresa;
2. dashboard resumido;
3. catalogo de produtos;
4. operacao resiliente com conexao instavel;
5. evolucao para intencoes de venda offline.

## Decisoes fixas

- Flutter para Android e iOS.
- Arquitetura local-first.
- Organizacao por feature e camadas.
- Riverpod para estado e injecao.
- Drift + SQLite como banco operacional local.
- Dio para transporte HTTP.
- `go_router` para navegacao.
- Credenciais em armazenamento seguro.
- Outbox para acoes offline relevantes.
- Servidor remoto soberano para estoque, permissoes e confirmacao de operacoes.
- Foreground como sincronizacao principal; background apenas como apoio.
- Identidade visual azul, analitica e operacional.

Detalhes e status: `06-registro-decisoes.md`.

## Regras que nao podem ser quebradas

- Tela nao acessa Dio ou Drift.
- Camada `application` nao conhece Dio, Drift ou JSON.
- Estado local nao transforma operacao pendente em confirmada.
- Dados de usuarios ou empresas diferentes nao podem ser misturados.
- Preco `null` nao e automaticamente erro.
- Produto sem estoque pode existir no catalogo.
- Feature ou permissao ausente deve alterar a navegacao e os estados da UI.
- Operacao offline precisa de identificador estavel para reenvio.
- Falha de migracao nao autoriza apagar banco, outbox ou operacoes pendentes.
- Contrato planejado nao pode ser consumido como contrato existente.

## Fluxo arquitetural

```text
Page
  -> Controller Riverpod
    -> UseCase
      -> Repository
        -> Local DAO / Remote Data Source
```

A UI observa o estado produzido pela aplicacao. Repositorios escondem a origem
local ou remota. Sincronizacao atualiza o banco e a interface reage aos dados
locais.

## Estados obrigatorios de interface

Telas operacionais devem considerar o subconjunto aplicavel:

- `initial`;
- `loading`;
- `ready`;
- `refreshing`;
- `empty`;
- `offline`;
- `restricted`;
- `syncing`;
- `failure`.

Dados locais podem continuar visiveis durante refresh ou falha remota.

## Como escolher o que ler

### Arquitetura ou dependencias

- `05-arquitetura-mobile.md`;
- `06-registro-decisoes.md`.

### Regra de negocio ou offline

- `04-regras-e-necessidades-mobile.md`;
- se necessario, as secoes de sync e outbox da arquitetura.

### Interface

- `02-definicoes-de-interface.md`;
- `designmobile.md` somente para trabalho visual amplo.

### Integracao

- `03-endpoints-mobile.md`;
- confirmar se o contrato esta marcado como existente ou planejado.

### Processo

- `08-processo-de-trabalho.md`;
- `07-uso-de-mcps.md`.

## Proxima sequencia recomendada

1. Revisar o working tree atual e transformar as mudancas em commits coerentes
   por responsabilidade.
2. Validar manualmente a shell, o dashboard, o catalogo e a tela local de
   vendas nos tamanhos previstos.
3. Revisar e limpar artefatos de falha em `test/goldens/failures/`.
4. Criar contratos compartilhados de erro, resultado e cliente HTTP.
5. Criar banco Drift e estrategia segura de migracao.
6. Implementar sessao e contexto do usuario quando o contrato de autenticacao
   estiver disponivel.
7. Substituir fixtures de dashboard e catalogo por fontes locais/remotas sem
   romper os estados operacionais existentes.
8. Introduzir sincronizacao incremental quando houver contrato confirmado.
9. Implementar outbox somente junto de uma operacao offline real.

Nao antecipar toda a infraestrutura de vendas offline antes de existir um caso
de uso e contrato que a exercite.

## Definicao curta de pronto

Uma entrega esta pronta quando respeita as camadas, trata estados relevantes,
tem testes proporcionais ao risco, passa por analise estatica e nao contradiz
uma decisao aceita.
