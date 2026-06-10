# Contexto Operacional Mobile

## Para que serve

Este é o primeiro documento a ser lido por pessoas e agentes antes de trabalhar
no aplicativo. Ele resume o estado atual, as decisões fixas e indica onde buscar
detalhes sem reler toda a pasta.

## Estado atual

- O repositório Flutter ainda está próximo do projeto inicial.
- A arquitetura alvo está definida, mas ainda não foi materializada em `lib/`.
- Existem contratos remotos documentados para perfil, dashboard e produtos.
- Autenticação mobile por token e vendas offline continuam dependentes de
  contratos ainda não implementados.
- A pasta `para mobile` contém especificação e contexto, não comprovação de que
  cada item já existe no aplicativo.

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

1. Corrigir a fundação do projeto e remover o contador padrão.
2. Criar bootstrap, tema, router e configuração de ambientes.
3. Criar contratos de erro, resultado e cliente HTTP.
4. Criar banco Drift e estratégia de migração.
5. Implementar sessão e contexto do usuário quando o contrato de autenticação
   estiver disponível.
6. Implementar dashboard e catálogo lendo por repositórios.
7. Introduzir sincronização incremental.
8. Implementar outbox somente junto de uma operação offline real.

Não antecipar toda a infraestrutura de vendas offline antes de existir um caso
de uso e contrato que a exercite.

## Definição curta de pronto

Uma entrega está pronta quando respeita as camadas, trata estados relevantes,
tem testes proporcionais ao risco, passa por análise estática e não contradiz
uma decisão aceita.
