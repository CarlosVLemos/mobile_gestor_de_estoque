# Contexto Operacional Mobile

## Para que serve

Este é o primeiro documento a ser lido por pessoas e agentes antes de trabalhar
no aplicativo. Ele resume o estado atual, as decisões fixas e indica onde buscar
detalhes sem reler toda a pasta.

## Estado atual

- A fundação Flutter já está materializada em `lib/`, com tema claro/escuro,
  bootstrap, `go_router`, Riverpod e organização inicial por feature e camada.
- O `main` contém uma shell operacional e fluxos locais explícitos para
  dashboard, catálogo, Mais e contexto do usuário.
- Dashboard e catálogo ainda usam fixtures por meio de repositórios. Eles não
  comprovam integração remota, persistência local ou sincronização.
- A Spec 005 foi implementada no working tree e introduz Instrument Sans local,
  iconografia Lucide encapsulada, navegação inferior própria, headers
  operacionais e revisão visual das telas existentes.
- A implementação da Spec 005 passou por formatação, análise estática e 64
  testes automatizados, incluindo seis goldens em `390x844`, claro e escuro.
- A validação visual manual em `360x800`, `390x844` e `412x915`, além da
  aprovação visual do usuário, continua pendente.
- Existem contratos remotos documentados para perfil, dashboard e produtos.
- Autenticação mobile por token e vendas offline continuam dependentes de
  contratos ainda não implementados.
- Drift, Dio, armazenamento seguro, sincronização incremental e outbox fazem
  parte da arquitetura aceita, mas ainda não estão materializados no app.
- Documentação descreve intenção e decisões; somente código, testes e evidências
  de execução comprovam o que já existe.

## Situação do working tree

Fotografia em 15 de junho de 2026:

- branch `main`, sincronizada com `origin/main` no commit `9c956d5`;
- implementação da Spec 005 ainda não commitada;
- alterações amplas já estão staged, incluindo fontes, dependência Lucide,
  componentes, páginas, testes e goldens;
- correções posteriores da revisão permanecem unstaged em arquivos já staged,
  aparecendo como `MM` ou `AM` no `git status`;
- essas correções incluem carregamento obrigatório da fonte Lucide nos goldens,
  encapsulamento do ícone de voltar, testes de escala de texto e ajuste da
  navegação inferior para evitar overflow em escala `2.0`;
- mudanças em `docs/specs/Img/` também estão no status e devem ser preservadas
  como material do usuário.

Antes de criar o próximo commit, revisar e adicionar também as alterações
unstaged para evitar registrar somente a versão anterior da implementação.

## Produto

O app é uma extensão operacional mobile do Arara-Gastos.

Prioridades:

1. contexto do usuário e da empresa;
2. dashboard resumido;
3. catálogo de produtos;
4. operação resiliente com conexão instável;
5. evolução para intenções de venda offline.

## Decisões fixas

- Flutter para Android e iOS.
- Arquitetura local-first.
- Organização por feature e camadas.
- Riverpod para estado e injeção.
- Drift + SQLite como banco operacional local.
- Dio para transporte HTTP.
- `go_router` para navegação.
- Credenciais em armazenamento seguro.
- Outbox para ações offline relevantes.
- Servidor remoto soberano para estoque, permissões e confirmação de operações.
- Foreground como sincronização principal; background apenas como apoio.
- Identidade visual azul, analítica e operacional.

Detalhes e status: `06-registro-decisoes.md`.

## Regras que não podem ser quebradas

- Tela não acessa Dio ou Drift.
- Camada `application` não conhece Dio, Drift ou JSON.
- Estado local não transforma operação pendente em confirmada.
- Dados de usuários ou empresas diferentes não podem ser misturados.
- Preço `null` não é automaticamente erro.
- Produto sem estoque pode existir no catálogo.
- Feature ou permissão ausente deve alterar a navegação e os estados da UI.
- Operação offline precisa de identificador estável para reenvio.
- Falha de migração não autoriza apagar banco, outbox ou operações pendentes.
- Contrato planejado não pode ser consumido como contrato existente.

## Fluxo arquitetural

```text
Page
  -> Controller Riverpod
    -> UseCase
      -> Repository
        -> Local DAO / Remote Data Source
```

A UI observa o estado produzido pela aplicação. Repositórios escondem a origem
local ou remota. Sincronização atualiza o banco e a interface reage aos dados
locais.

## Estados obrigatórios de interface

Telas operacionais devem considerar o subconjunto aplicável:

- `initial`;
- `loading`;
- `ready`;
- `refreshing`;
- `empty`;
- `offline`;
- `restricted`;
- `syncing`;
- `failure`.

Dados locais podem continuar visíveis durante refresh ou falha remota.

## Como escolher o que ler

### Arquitetura ou dependências

- `05-arquitetura-mobile.md`;
- `06-registro-decisoes.md`.

### Regra de negócio ou offline

- `04-regras-e-necessidades-mobile.md`;
- se necessário, as seções de sync e outbox da arquitetura.

### Interface

- `02-definicoes-de-interface.md`;
- `designmobile.md` somente para trabalho visual amplo.

### Integração

- `03-endpoints-mobile.md`;
- confirmar se o contrato está marcado como existente ou planejado.

### Processo

- `08-processo-de-trabalho.md`;
- `07-uso-de-mcps.md`.

## Próxima sequência recomendada

1. Validar manualmente a Spec 005 nos tamanhos previstos e obter aprovação
   visual do usuário.
2. Revisar o escopo staged e unstaged, atualizar o fechamento da Spec 005 e
   criar commits coerentes sem perder as correções posteriores.
3. Criar contratos compartilhados de erro, resultado e cliente HTTP.
4. Criar banco Drift e estratégia segura de migração.
5. Implementar sessão e contexto do usuário quando o contrato de autenticação
   estiver disponível.
6. Substituir fixtures de dashboard e catálogo por fontes locais/remotas sem
   romper os estados operacionais existentes.
7. Introduzir sincronização incremental quando houver contrato confirmado.
8. Implementar outbox somente junto de uma operação offline real.

Não antecipar toda a infraestrutura de vendas offline antes de existir um caso
de uso e contrato que a exercite.

## Definição curta de pronto

Uma entrega está pronta quando respeita as camadas, trata estados relevantes,
tem testes proporcionais ao risco, passa por análise estática e não contradiz
uma decisão aceita.
