# Spec 001 - Fundação Arquitetural

## Status

Implementada em 10 de junho de 2026.

## Classificação

- arquitetura;
- estrutura;
- dependências;
- interface de fundação;
- documentação;
- refactor do template inicial.

## Fontes e hierarquia

Esta spec é governada pelo `AGENTS.md` da raiz e usa
`para mobile/00-contexto-operacional.md` como ponto de entrada.

Esta spec segue, nesta ordem:

1. decisões aceitas em `para mobile/06-registro-decisoes.md`;
2. arquitetura em `para mobile/05-arquitetura-mobile.md`;
3. regras em `para mobile/04-regras-e-necessidades-mobile.md`;
4. interface em `para mobile/02-definicoes-de-interface.md`;
5. contratos implementados em `para mobile/03-endpoints-mobile.md`;
6. processo em `para mobile/08-processo-de-trabalho.md`;
7. uso de ferramentas em `para mobile/07-uso-de-mcps.md`;
8. código atual do template Flutter.

Itens dependentes, planejados ou abertos são registrados como restrição e não
como implementação disponível.

`designmobile.md` não é leitura obrigatória desta spec porque não há trabalho
visual amplo. Os tokens necessários já estão definidos em
`02-definicoes-de-interface.md`.

## Problema

O aplicativo ainda preserva a estrutura e o contador do template inicial do
Flutter. Toda a aplicação está concentrada em `lib/main.dart`, não existe
bootstrap explícito, navegação central, tema do produto ou separação suficiente
para receber features por camada.

Sem uma fundação executável, as próximas entregas podem introduzir dependências
e responsabilidades em locais incorretos, contrariando as decisões já aceitas.

## Objetivo

Substituir o template inicial por uma fundação mínima e executável que:

- estabeleça o fluxo `main -> bootstrap -> AraraApp`;
- use Riverpod como raiz de estado e injeção;
- centralize a navegação com `go_router`;
- centralize o tema inicial do produto;
- apresente uma tela transitória de inicialização, sem simular feature pronta;
- materialize a árvore canônica de `app`, `core`, `shared` e `features`;
- organize todas as features previstas nas quatro camadas arquiteturais;
- proteja as principais fronteiras arquiteturais com testes automatizados.

## Decisões aplicáveis

### Materializadas nesta entrega

| Decisão | Aplicação |
| --- | --- |
| MOB-002 | Árvore por feature e camada |
| MOB-003 | Testes impedem detalhes técnicos em `application` |
| MOB-004 | `ProviderScope` na raiz do aplicativo |
| MOB-007 | Navegação central com `go_router` |
| MOB-014 | Tema inicial azul e operacional |
| MOB-016 | Diretórios não são apresentados como features implementadas |

### Preservadas, mas ainda não implementadas

| Decisão | Restrição nesta spec |
| --- | --- |
| MOB-001 | A estrutura reserva responsabilidades local-first, sem persistência |
| MOB-005 | `core/database` existe, mas Drift não é instalado nem configurado |
| MOB-006 | `core/network` existe, mas Dio não é instalado nem configurado |
| MOB-008 | `core/security` existe, sem token ou armazenamento seguro |
| MOB-009 | `core/sync` existe, sem outbox ou intenção offline |
| MOB-010 | Nenhuma informação local é tratada como confirmação remota |
| MOB-011 | Nenhum trabalho foreground ou background é implementado |
| MOB-012 | Nenhum schema ou migração é criado |
| MOB-013 | `core/images` existe, sem cache ou armazenamento de imagens |
| MOB-015 | Nenhuma permissão visual ou autorização simulada é criada |

Esta spec materializa decisões já aceitas. Ela não cria uma nova decisão
arquitetural e, portanto, não exige alteração em
`para mobile/06-registro-decisoes.md`.

### Decisões de interface preservadas

| Decisão | Tratamento nesta spec |
| --- | --- |
| UI-001 | Bottom navigation e shell autenticado não são criados ainda |
| UI-002 | Não existem tabelas ou listas de negócio nesta entrega |
| UI-003 | Dashboard e hero escuro permanecem fora de escopo |
| UI-004 | Cores semânticas são centralizadas no tema |
| UI-005 | Não há refresh ou dados operacionais nesta entrega |
| UI-006 | Nenhum preço é exibido ou simulado |
| UI-007 | Nenhum conflito de sincronização é criado ou ocultado |

## Escopo

### Estrutura canônica

```text
lib/
  main.dart
  bootstrap.dart

  app/
    arara_app.dart
    router/
    theme/
    localization/

  core/
    auth/
    background/
    config/
    database/
    errors/
    images/
    logging/
    network/
    result/
    security/
    sync/

  shared/
    formatters/
    ui_states/
    validators/
    widgets/

  features/
    auth/
    catalog/
    clients/
    dashboard/
    inventory/
    reports/
    sales/
    settings/
```

Cada diretório listado deve existir ao final da implementação.

### Estrutura obrigatória das features

As oito features previstas devem receber a mesma separação inicial:

```text
features/<feature>/
  domain/
    entities/
    failures/
    repositories/
    value_objects/

  application/
    services/
    use_cases/

  data/
    dto/
    local/
    mappers/
    remote/
    repositories/

  presentation/
    controllers/
    pages/
    state/
    widgets/
```

O modelo deve ser aplicado a:

- `auth`;
- `catalog`;
- `clients`;
- `dashboard`;
- `inventory`;
- `reports`;
- `sales`;
- `settings`.

Como o Git não versiona diretórios vazios, diretórios ainda sem implementação
devem conter `.gitkeep`. O marcador:

- existe apenas para materializar a arquitetura;
- não significa que a feature ou infraestrutura está implementada;
- deve ser removido quando o primeiro arquivo real entrar no diretório;
- não pode ser substituído por classes, interfaces ou serviços fictícios.

### Responsabilidade das áreas

| Área | Responsabilidade nesta fundação |
| --- | --- |
| `app` | composição, navegação, tema, localização e inicialização visual |
| `core` | reservar infraestrutura transversal prevista pela arquitetura |
| `shared` | reservar utilitários e UI reutilizável sem regra de feature |
| `features` | separar capacidades de negócio por camada |
| `test/architecture` | validar estrutura e dependências permitidas |

Distinções obrigatórias:

- `core/auth` será infraestrutura transversal de sessão e credenciais;
- `features/auth` será o fluxo funcional de autenticação quando houver contrato;
- `shared` não pode concentrar regras de negócio específicas;
- `core` não pode depender de uma feature;
- uma feature não pode acessar detalhes internos de outra feature;
- `app` faz composição, mas não contém regra de negócio.

### Arquivos executáveis iniciais

Além da árvore canônica, esta entrega deve criar:

```text
lib/app/router/app_router.dart
lib/app/router/app_routes.dart
lib/app/startup/startup_page.dart
lib/app/localization/app_strings.dart
lib/app/theme/app_colors.dart
lib/app/theme/app_theme.dart
```

`app/startup/` é uma área transitória de composição da aplicação. Ela não é uma
feature de negócio e será removida quando uma feature real assumir a rota
inicial.

### Estrutura inicial de testes

```text
test/
  app/
    arara_app_test.dart
  architecture/
    layer_boundaries_test.dart
    project_structure_test.dart
```

O teste legado do contador deve ser removido ou substituído, não mantido em
paralelo.

### Dependências

Adicionar somente as dependências necessárias para a fundação:

- `flutter_riverpod`;
- `go_router`.

As versões devem ser resolvidas no momento da implementação, compatíveis com o
Flutter e o Dart fixados no projeto.

Dependências herdadas do template devem ser revisadas. `cupertino_icons` deve
ser removida se permanecer sem uso após a nova fundação.

### Inicialização

- `main.dart` deve conter apenas a entrada do processo e delegar ao bootstrap;
- `WidgetsFlutterBinding.ensureInitialized()` deve ficar no bootstrap se alguma
  inicialização Flutter exigir binding antes de `runApp`;
- `bootstrap.dart` deve executar inicializações obrigatórias e criar o
  `ProviderScope`;
- o bootstrap não pode capturar silenciosamente erros ou registrar segredos;
- `AraraApp` deve construir o `MaterialApp.router`;
- o router deve ser criado fora de widgets de página;
- a rota inicial deve abrir `StartupPage`;
- somente o fluxo de inicialização deve existir nesta entrega;
- shell autenticado, login, bottom navigation e rotas de features não podem ser
  criados antes de sessão, features e permissões reais;
- erros de bootstrap ainda não exigem fluxo remoto ou persistência.

### Tela transitória

`StartupPage` deve:

- usar o tema central;
- identificar o aplicativo como Arara-Gastos;
- informar que a fundação mobile está pronta para receber as features;
- não exibir dados falsos, dashboard simulado, autenticação simulada ou
  operações ainda dependentes de contrato.

Essa tela será substituída quando uma feature funcional assumir a rota inicial.

### Tema

O tema inicial deve:

- usar Material 3;
- centralizar cores e construção de `ThemeData`;
- usar os tokens iniciais documentados:
  - fundo principal: `hsl(210 33% 98%)`;
  - texto principal: `hsl(215 34% 15%)`;
  - superfície: `hsl(0 0% 100%)`;
  - primária: `hsl(213 77% 46%)`;
  - borda: `hsl(214 23% 88%)`;
  - sucesso: `hsl(152 60% 42%)`;
  - alerta: `hsl(38 92% 50%)`;
  - erro: `hsl(348 83% 55%)`;
- definir comportamento visual suficiente para a tela transitória;
- evitar um design system amplo antes das telas reais.

`Instrument Sans` permanece a tipografia alvo documentada. Esta spec não deve
declarar uma fonte ausente nem baixar assets implicitamente. Até existir uma
decisão de empacotamento ou dependência, deve ser usado o fallback padrão da
plataforma e a limitação deve constar em `review.md`.

### Localização

- `app/localization/` deve ser materializado;
- textos da tela transitória devem ficar centralizados e preparados para futura
  localização, sem espalhar literais por widgets;
- `pt-BR` é o conteúdo inicial;
- não definir idiomas adicionais enquanto a questão de localização permanecer
  aberta;
- não adicionar geração de localização ou pacote extra sem necessidade
  comprovada nesta entrega.

### Configuração de ambientes

`core/config/` deve existir, mas esta spec não pode inventar ambientes, URLs ou
chaves. A lista de ambientes e suas URLs continua como questão aberta em
`06-registro-decisoes.md`.

Qualquer tentativa de criar `development`, `staging`, `production`, base URL ou
leitura por `dart-define` exige primeiro uma decisão aceita. Nesta entrega,
`core/config/` permanece somente como responsabilidade arquitetural
materializada.

### Política de ferramentas

Durante a implementação:

- usar o Dart/Flutter MCP para workspace, dependências e diagnósticos quando
  disponível;
- usar Context7 para confirmar as APIs e versões compatíveis de Riverpod e
  `go_router`, após verificar `pubspec.lock`;
- usar Sequential Thinking somente se surgir uma decisão arquitetural nova;
- não usar GitHub MCP nem GitHub Connector enquanto estiverem suspensos;
- executar `dart format`, `flutter analyze` e `flutter test` mesmo quando o MCP
  fornecer diagnósticos;
- registrar em `review.md` qualquer MCP ausente e o fallback utilizado.

### Limpeza do template

- substituir a descrição genérica em `pubspec.yaml`;
- substituir o conteúdo inicial genérico de `README.md` por uma orientação
  curta do Arara-Gastos Mobile e links para o contexto e as specs;
- remover contador, `MyApp`, `MyHomePage`, comentários didáticos e testes do
  template;
- remover dependências do template que não tenham uso;
- não alterar metadados nativos ou web nesta spec, salvo se forem necessários
  para o aplicativo compilar ou inicializar.

### Fronteiras arquiteturais

Criar uma verificação automatizada que percorra os arquivos Dart de `lib/` e
falhe quando encontrar, no mínimo:

- `presentation` importando Dio, Drift ou caminhos internos de `data`;
- `application` importando Flutter, widgets, Dio, Drift ou DTOs;
- `domain` importando Flutter, JSON, transporte ou persistência;
- `data` importando páginas, widgets, controllers ou estado visual;
- `core` importando qualquer caminho de `features`;
- `shared` importando detalhes internos de uma feature;
- `app` contendo ou importando diretamente DTO, DAO ou fonte remota;
- uma feature importando caminho interno de outra feature;
- páginas acessando fontes remotas ou DAOs diretamente.

A verificação pode começar simples, baseada nos imports e caminhos existentes,
desde que seja determinística, legível e fácil de ampliar. O mecanismo de
validação deve ser testado com casos válidos e inválidos; a ausência inicial de
arquivos nas features não é evidência suficiente de que a regra funciona.

### Fluxo de dependências

```text
Page
  -> Controller Riverpod
    -> UseCase
      -> Repository (contrato)
        -> Repository concreto
          -> DAO / Remote Data Source
```

Regras:

- `presentation` depende de `application` e tipos de `domain`;
- `application` depende de contratos e tipos puros de `domain`;
- `domain` não depende das demais camadas;
- `data` implementa contratos e conhece transporte/persistência;
- composição de implementações ocorre em providers fora de páginas;
- DTO remoto nunca é estado visual;
- widgets não decidem sincronização ou autorização.

## Fora de escopo

- implementar autenticação ou sessão;
- implementar dashboard, catálogo ou qualquer feature de negócio;
- criar cliente Dio, interceptors ou contratos remotos;
- criar banco Drift, tabelas, DAOs ou migrações;
- implementar sync, outbox, background ou cache de imagens;
- adicionar Freezed, serialização ou geração de código;
- definir ambientes e URLs remotas;
- implementar localização além da centralização inicial de textos;
- empacotar ou baixar a fonte Instrument Sans;
- preencher `core/`, `shared/` ou `features/` com implementações fictícias;
- alterar código nativo Android, iOS, web ou desktop sem necessidade técnica.

## Regras de negócio

Esta entrega não implementa regra de negócio. Mesmo assim, deve preservar as
restrições do projeto:

- não representar contrato planejado como disponível;
- não criar dados ou permissões simuladas;
- não introduzir estado local que pareça confirmação remota;
- não preparar venda offline antes de existir caso de uso e contrato.
- não enviar ou modelar `tenant_id` como verdade de domínio;
- não assumir preço disponível, estoque vendável ou permissão concedida;
- não consumir login, logout, relatórios ou venda offline planejados.

## Contrato consumido

Nenhum contrato remoto é consumido nesta spec.

Os contratos existentes de perfil, dashboard e produtos não são usados. Os
endpoints planejados de login, logout, relatórios e venda offline permanecem
fora de escopo.

Como não existe transporte HTTP nesta entrega, não devem ser criados handlers,
mappers ou telas fictícias para `401`, `403`, `422` ou `429`. Esses estados
serão tratados junto da camada remota e das features que os exercitarem.

## Estados de interface

A tela transitória precisa apenas do estado estático `ready`.

Estados operacionais como `loading`, `offline`, `restricted`, `syncing` e
`failure` serão introduzidos pelas features que realmente os exercitarem.

O conjunto canônico preservado para telas futuras é:

- `initial`;
- `loading`;
- `ready`;
- `refreshing`;
- `empty`;
- `offline`;
- `restricted`;
- `syncing`;
- `failure`.

Somente `ready` é aplicável à tela transitória desta spec.

## Dados locais

Nenhum dado operacional será persistido. Esta spec não cria schema, cache,
preferências ou armazenamento seguro.

## Permissões e segurança

- nenhuma permissão é inferida ou fixada localmente;
- nenhuma rota funcional é liberada por feature flag simulada;
- nenhum token, segredo, payload ou dado pessoal entra no código ou em logs;
- autorização remota continua soberana quando as features forem implementadas.

## Questões abertas e dependências

Esta spec não resolve:

- banco único ou separado por usuário/empresa;
- política de expiração e renovação de sessão;
- coleções da primeira sincronização;
- limite de cache de imagens;
- idiomas além de `pt-BR`;
- ambientes e URLs do primeiro release;
- DEP-001: login mobile;
- DEP-002: renovação de sessão;
- DEP-003: venda offline;
- DEP-004: cursor de sincronização;
- DEP-005: relatórios mobile;
- DEP-006: área administrativa mobile.

Se alguma dessas respostas se tornar necessária durante a implementação, o
trabalho deve parar nesse ponto e a decisão deve ser registrada em
`06-registro-decisoes.md` antes de continuar.

## Riscos

- criar abstrações sem uso e aumentar o custo de manutenção;
- tratar a presença dos diretórios como prova de funcionalidade implementada;
- deixar `.gitkeep` junto de arquivos reais após a evolução de um diretório;
- confundir a tela transitória com uma feature implementada;
- instalar toda a stack prevista antes de haver casos de uso;
- concentrar novamente composição, tema e rotas em um único arquivo;
- criar teste arquitetural frágil ou excessivamente acoplado a nomes;
- deixar diferenças de comportamento entre testes e a inicialização real;
- normalizar paths de forma incorreta entre Windows e ambientes Unix;
- codificar configurações de máquina, caminhos absolutos ou credenciais;
- duplicar regras canônicas dentro da implementação.

## Critérios de aceite

1. O contador e todo o código demonstrativo do template foram removidos.
2. `main.dart` delega a inicialização para `bootstrap.dart`.
3. O widget raiz está em `app/arara_app.dart`.
4. A aplicação inicia dentro de um `ProviderScope`.
5. A navegação usa `MaterialApp.router` e `go_router`.
6. Tema e cores estão centralizados em `app/theme/`.
7. A rota inicial renderiza uma tela transitória sem dados de negócio falsos.
8. Todos os diretórios canônicos de `app`, `core` e `shared` existem.
9. As oito features previstas existem.
10. Cada feature contém `domain`, `application`, `data` e `presentation` com
    todos os subdiretórios definidos nesta spec.
11. Diretórios sem implementação são versionados somente com `.gitkeep`.
12. Nenhuma classe, interface ou serviço fictício foi criado para preencher a
    estrutura.
13. As únicas novas dependências de runtime são Riverpod e `go_router`.
14. O teste de widget valida a inicialização e o conteúdo essencial da tela.
15. O teste estrutural valida a presença de toda a árvore canônica.
16. O teste estrutural funciona com separadores de caminho Windows e Unix.
17. O teste arquitetural possui casos negativos que provam suas proibições.
18. As fronteiras de `presentation`, `application`, `domain`, `data`, `core`,
    `shared`, `app` e entre features são validadas.
19. Os tokens visuais iniciais estão centralizados no tema.
20. Textos da tela transitória estão centralizados para futura localização.
21. Nenhuma URL, ambiente, token, permissão ou contrato pendente foi inventado.
22. A limitação da fonte Instrument Sans está registrada na revisão.
23. `dart format`, `flutter analyze` e `flutter test` passam.
24. A aplicação é inicializada e validada visualmente em alvo disponível.
25. `review.md` registra comandos, resultados, limitações e veredito.
26. Nenhum shell, login, bottom navigation ou rota de feature foi antecipado.
27. As ferramentas e fallbacks usados foram registrados conforme
    `07-uso-de-mcps.md`.
28. `README.md` e a descrição do `pubspec.yaml` não contêm texto do template.
29. Classes, comentários, testes e dependências sem uso do contador foram
    removidos.

## Resultado esperado

Ao final, o repositório deixa de ser um template Flutter e passa a ter uma
fundação pequena, navegável, testada e coerente com a arquitetura local-first,
com a árvore arquitetural integralmente materializada, sem afirmar que
infraestrutura ou features futuras já funcionam.
