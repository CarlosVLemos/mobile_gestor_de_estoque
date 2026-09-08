# Contexto Operacional Mobile

## Para que serve

Este e o primeiro documento a ser lido por pessoas e agentes antes de trabalhar
no aplicativo. Ele resume o estado atual, as decisoes fixas e indica onde
buscar detalhes sem reler toda a pasta.

## Estado atual — 8 de setembro de 2026

- Base Flutter com shell `Painel`, `Produtos`, `Vendas`, `Mais`, tema e drawer.
- Dio, ApiClient, erros e Result possuem código; auditoria antiga da 007 não
  comprova a árvore atual.
- 009A: schema Drift v1 de categorias, produtos, KPIs, alertas, snapshot local,
  checkpoints e locks escrito, ainda sem geração/execução neste ambiente.
- 009B: engine, lease com TTL, transações, cooldown e estado reativo escritos.
- 009C: coleções de leitura, repositórios Drift, streams autoDispose, controllers,
  refresh, avisos e composição condicional de bootstrap/lifecycle escritos.
- O catálogo respeita `per_page <= 50`. Repete a janela a partir da página 1 em
  nova execução; não inventa cursor estável, watermark ou tombstones.
- O painel ainda precisa do decoder real: faltam campos internos do contrato.
- Sem banco autenticado injetado, o startup segue demonstrativo, sem abrir banco
  anônimo. Sessão, arquivo isolado e logout (008/008B) continuam pendentes.
- Vendas continuam rascunhos em memória. Não há outbox nem venda remota real.
- Dart/Flutter ausentes por restrição desta execução: geração, formatação,
  análise, testes e validação visual pendentes. Não declarar 009A/B/C prontas.

Detalhes, limites, evidências e comandos da próxima sessão:
[Estado e validação](../docs/estado-atual.md).

## Situação do working tree

Branch local `main`; esta execução contém mudanças não commitadas em código,
testes e documentação da 009. Não foi verificado alinhamento remoto.
Use `git status --short` e `git diff` antes de preparar commits. Fotografias de
junho nos registros antigos não representam staging nem validação atuais.

Antes de publicar, gerar o schema, resolver o lockfile, executar as verificações
e inspecionar UI/goldens. Não tratar código escrito como aceite aprovado.

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

## Próxima sequência recomendada

1. Executar o roteiro com SDK em `docs/estado-atual.md` e corrigir falhas.
2. Confirmar o contrato interno do dashboard e implementar seu decoder.
3. Concluir sessão/isolamento 008/008B antes de habilitar dados reais.
4. Validar bootstrap, offline, permissões, reinício e teardown no aparelho.
5. Confirmar cursor/watermark/tombstones antes de promover delta com avanço.
6. Revisar/publicar a entrega validada; outbox depende de operação e contrato reais.

## Definicao curta de pronto

Uma entrega esta pronta quando respeita as camadas, trata estados relevantes,
tem testes proporcionais ao risco, passa por analise estatica e nao contradiz
uma decisao aceita.
