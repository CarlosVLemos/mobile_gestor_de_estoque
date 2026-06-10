# Spec 001 - Plano de Testes

## Objetivo

Validar que a fundação inicia corretamente, preserva as fronteiras
arquiteturais e não introduz infraestrutura ou comportamento fora do escopo.

## Ambiente de referência

Registrar durante a implementação:

```text
Flutter: 3.44.1
Dart: 3.12.1
Plataforma: Windows 11
Dispositivo ou navegador: Flutter web-server e renderizador de widget tests
```

## Testes automatizados

### T-000 - Árvore arquitetural

**Tipo:** estrutura

**Passos:**

1. Percorrer os diretórios de `lib/`.
2. Comparar a árvore encontrada com a estrutura obrigatória de `spec.md`.
3. Verificar as oito features e suas quatro camadas.

**Resultado esperado:**

- todos os diretórios de `app`, `core` e `shared` existem;
- `auth`, `catalog`, `clients`, `dashboard`, `inventory`, `reports`, `sales` e
  `settings` existem;
- cada feature contém todos os subdiretórios de `domain`, `application`, `data`
  e `presentation`;
- diretórios sem código contêm `.gitkeep`;
- diretórios com arquivos reais não mantêm `.gitkeep`;
- não existem arquivos Dart fictícios usados apenas como marcadores.
- a comparação funciona com paths usando `/` e `\`.

### T-001 - Inicialização do aplicativo

**Tipo:** widget

**Pré-condição:** dependências resolvidas.

**Passos:**

1. Construir o aplicativo pelo mesmo widget raiz usado no bootstrap.
2. Aguardar a estabilização da primeira rota.

**Resultado esperado:**

- o app é construído sem exceções;
- a rota inicial é exibida;
- o texto essencial do Arara-Gastos está presente;
- nenhum elemento do contador padrão está presente.

### T-002 - Router central

**Tipo:** widget ou unidade

**Passos:**

1. Obter o router pela composição oficial.
2. Abrir a localização inicial.

**Resultado esperado:**

- a localização inicial é reconhecida;
- `StartupPage` é renderizada;
- não há dependência de `BuildContext` global.
- não existem rotas de login, shell ou features ainda não implementadas.

### T-003 - Tema central

**Tipo:** widget

**Passos:**

1. Construir `AraraApp`.
2. Ler o tema disponível na tela inicial.

**Resultado esperado:**

- Material 3 está habilitado;
- a cor primária vem da configuração central;
- a tela não define um `ThemeData` próprio.
- os tokens de fundo, texto, superfície, borda e estados semânticos correspondem
  a `02-definicoes-de-interface.md`;
- nenhuma família de fonte ausente é declarada.

### T-004 - Fronteiras de `presentation`

**Tipo:** arquitetura

**Resultado esperado:**

O teste falha se um arquivo em `presentation/` importar:

- Dio;
- Drift;
- DAO ou fonte remota;
- caminho interno de `data/`.
- DAO ou fonte remota por import relativo ou de package.

### T-005 - Fronteiras de `application`

**Tipo:** arquitetura

**Resultado esperado:**

O teste falha se um arquivo em `application/` importar:

- Flutter ou widgets;
- Dio;
- Drift;
- DTO ou implementação concreta de `data/`.

### T-006 - Fronteiras de `domain`

**Tipo:** arquitetura

**Resultado esperado:**

O teste falha se um arquivo em `domain/` importar:

- Flutter;
- Dio ou Drift;
- JSON ou DTOs;
- persistência ou transporte.

### T-007 - Isolamento entre features

**Tipo:** arquitetura

**Resultado esperado:**

O teste falha quando uma feature importa um arquivo interno de outra feature.
Contratos compartilhados futuros devem estar em uma API pública explícita ou em
uma área compartilhada aprovada.

### T-008 - Fronteiras de `data`, `core`, `shared` e `app`

**Tipo:** arquitetura

**Resultado esperado:**

O teste falha quando:

- `data` importa páginas, widgets, controllers ou estado visual;
- `core` importa uma feature;
- `shared` importa detalhes internos de uma feature;
- `app` importa DTO, DAO ou fonte remota;
- uma página instancia diretamente repository concreto, DAO ou cliente remoto.

### T-009 - Casos negativos do validador

**Tipo:** unidade

**Resultado esperado:**

- cada regra proibida possui ao menos uma amostra que falha;
- imports permitidos possuem amostras que passam;
- mensagens indicam arquivo, camada e regra violada;
- os testes não dependem de as features já possuírem código real.

### T-010 - Dependências da fundação

**Tipo:** revisão automatizada ou manual

**Resultado esperado:**

- `flutter_riverpod` e `go_router` estão presentes;
- nenhuma outra dependência de runtime foi adicionada por esta entrega;
- Dio, Drift, Freezed, Workmanager e demais itens fora do escopo permanecem
  ausentes.

### T-011 - Marcadores estruturais

**Tipo:** estrutura

**Resultado esperado:**

- `.gitkeep` aparece apenas em diretórios sem arquivos reais;
- nenhum marcador é interpretado como implementação;
- a remoção futura de um marcador não exige mudança arquitetural.

### T-012 - Configuração, contratos e segredos

**Tipo:** revisão automatizada

**Resultado esperado:**

- não existem URLs de API ou ambientes inventados;
- não existem tokens, senhas ou chaves no diff;
- não existem DTOs ou chamadas para endpoints existentes ou planejados;
- `core/config`, `core/network`, `core/database`, `core/security` e `core/sync`
  permanecem sem implementação funcional.

### T-013 - Localização inicial

**Tipo:** widget ou unidade

**Resultado esperado:**

- textos da tela transitória vêm de uma fonte central;
- o conteúdo inicial é `pt-BR`;
- nenhum idioma adicional é declarado;
- não existe configuração parcial de geração de localização.

### T-014 - Resíduos do template

**Tipo:** revisão automatizada

**Resultado esperado:**

- `lib/`, `test/`, `README.md` e `pubspec.yaml` não contêm `Flutter Demo`,
  `MyApp`, `MyHomePage`, contador ou descrição `A new Flutter project`;
- o teste de contador não existe;
- `cupertino_icons` não permanece sem uso;
- arquivos de plataforma não foram alterados sem necessidade.

## Verificações estáticas

Executar:

```text
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

Todos os comandos devem terminar com código zero.

## Validação visual

Abrir o aplicativo em um alvo disponível e verificar:

- inicialização sem tela vermelha;
- identidade azul inicial;
- nome Arara-Gastos legível;
- ausência de contador, botão de incremento ou conteúdo demonstrativo;
- layout utilizável em largura mobile comum;
- ausência de dashboard ou dados falsos.
- contraste e legibilidade básicos em fundo claro;
- comportamento aceitável em pelo menos uma largura mobile estreita e uma
  largura mobile comum.

## Regressão

- o projeto continua inicializando pelos comandos Flutter convencionais;
- nenhuma plataforma nativa foi alterada sem necessidade;
- `pubspec.lock` corresponde às dependências declaradas;
- não existem arquivos gerados ou caches adicionados ao Git.
- a árvore implementada corresponde integralmente à seção de estrutura da spec.
- nenhum item dependente ou planejado foi tratado como implementado.
- nenhuma regra exige conectividade, persistência ou autorização nesta entrega.
- não existe bottom navigation, shell autenticado ou módulo funcional simulado.
- não existe tratamento fictício para `401`, `403`, `422` ou `429`.

## Evidências

Registrar em `review.md`:

- comandos executados e resultados;
- plataforma usada na validação visual;
- testes adicionados;
- desvios da spec;
- limitações encontradas.
- resultado da busca por segredos, URLs e configurações de máquina.
