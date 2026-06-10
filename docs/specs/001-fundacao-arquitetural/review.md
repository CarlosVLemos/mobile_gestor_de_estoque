# Spec 001 - Revisão

## Status

Implementação concluída em 10 de junho de 2026.

## Escopo revisado

- fundação `main -> bootstrap -> AraraApp`;
- Riverpod na raiz;
- router central com `go_router`;
- tema inicial e tela transitória;
- árvore completa de `app`, `core`, `shared` e `features`;
- quatro camadas e subdiretórios em cada feature;
- tokens visuais e textos `pt-BR` centralizados;
- testes de widget, estrutura e fronteiras arquiteturais.

## Checklist de conformidade

- [x] A implementação corresponde ao escopo de `spec.md`.
- [x] Nenhuma feature foi apresentada como pronta sem contrato ou caso de uso.
- [x] Nenhuma infraestrutura fora do escopo foi antecipada.
- [x] As decisões MOB-002, MOB-003, MOB-004, MOB-007, MOB-014 e MOB-016 foram
      respeitadas.
- [x] Toda a árvore canônica foi materializada.
- [x] As oito features possuem a estrutura completa definida na spec.
- [x] `.gitkeep` existe somente em diretórios ainda sem arquivos reais.
- [x] Não foram criadas classes ou interfaces fictícias para preencher pastas.
- [x] Os testes de fronteira cobrem as proibições mínimas.
- [x] Os testes possuem casos negativos e funcionam em Windows e Unix.
- [x] `data`, `core`, `shared` e `app` também têm fronteiras verificadas.
- [x] Os tokens visuais correspondem à definição de interface.
- [x] Nenhuma fonte ausente foi declarada silenciosamente.
- [x] Textos iniciais estão centralizados e limitados a `pt-BR`.
- [x] Nenhum ambiente, URL, token, permissão ou endpoint foi inventado.
- [x] Questões abertas e decisões dependentes permaneceram sem resolução tácita.
- [x] Decisões UI-001 a UI-007 foram preservadas sem antecipar suas features.
- [x] Não foi criado shell, login, bottom navigation ou rota funcional simulada.
- [x] `README.md`, `pubspec.yaml`, `lib/` e `test/` não mantêm resíduos do template.
- [x] Dependências sem uso do template foram removidas.
- [x] Não há segredos, caches ou arquivos gerados no diff.

## Verificações executadas

| Verificação | Resultado | Evidência |
| --- | --- | --- |
| `dart format --output=none --set-exit-if-changed lib test` | Aprovado | 13 arquivos, nenhuma alteração pendente |
| `flutter analyze` | Aprovado | nenhuma issue |
| `flutter test` | Aprovado | suíte completa aprovada |
| Inicialização do app | Aprovado com limitação | `flutter run -d web-server` abriu a porta local sem erro de build |
| Validação visual | Aprovado com limitação | capturas temporárias em 360x800 e 390x844 inspecionadas |
| Árvore arquitetural | Aprovado | teste estrutural e 135 marcadores `.gitkeep` |
| Fronteiras de camada | Aprovado | casos reais, válidos e negativos |
| Busca de segredos/URLs | Aprovado | nenhuma ocorrência em código ou configuração da entrega |
| Busca de resíduos do template | Aprovado | nenhuma ocorrência |

## Ferramentas e ambiente

- Flutter 3.44.1, canal stable;
- Dart 3.12.1;
- Windows 11;
- `flutter_riverpod` 3.3.2;
- `go_router` 17.3.0;
- Context7 usado para confirmar `ProviderScope`, `GoRouter` e
  `MaterialApp.router`;
- Dart/Flutter MCP consultado, mas sem project root registrado para `pub`; o
  fallback foi `flutter pub get`, `flutter analyze` e `flutter test`;
- Browser interno e extensão Chrome indisponíveis na sessão; o fallback visual
  foi o renderizador de widget tests com capturas temporárias;
- GitHub MCP e Connector não foram usados, conforme suspensão do projeto;
- Sequential Thinking não foi necessário porque nenhuma decisão nova surgiu.

## Arquivos principais

- `lib/main.dart`;
- `lib/bootstrap.dart`;
- `lib/app/arara_app.dart`;
- `lib/app/router/`;
- `lib/app/theme/`;
- `lib/app/startup/startup_page.dart`;
- `test/app/arara_app_test.dart`;
- `test/architecture/`.

## Achados

Nenhum bug, regressão ou violação de camada permaneceu após as validações.

## Desvios aprovados

Nenhum.

## Limitações

- Instrument Sans ainda não está empacotada nem configurada; o tema usa a fonte
  padrão da plataforma.
- Ambientes e URLs permanecem pendentes de decisão aceita.
- Autenticação, persistência, rede e sincronização permanecem fora desta spec.
- A sessão não ofereceu navegador automatizável. A composição visual foi
  inspecionada pelo renderizador Flutter, e a inicialização web foi confirmada
  pelo servidor local, sem interação em navegador real.

## Veredito

Aprovado. A fundação atende à spec 001 e está pronta para receber features sem
antecipar contratos ou infraestrutura ainda dependentes.
