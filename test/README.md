# Suite de testes

## Sessão atual da 009

Dart/Flutter ausentes em 8 de setembro de 2026. Novos testes estão escritos,
mas não executados. Antes da validação padrão:

```sh
flutter pub get
dart run build_runner build
dart format lib test
```

Roteiro e limitações em [estado atual](../docs/estado-atual.md).
Testes prioritários: `test/core/database`, `test/core/sync`,
`test/features/catalog`, `test/features/dashboard` e
`test/features/reading_reactivity_test.dart`. Dublê do decoder do painel não
comprova compatibilidade com o backend. AutoDispose é validado por desmontagem,
não por simples troca de aba em IndexedStack.

## Validacao padrao

Execute antes de fechar uma alteracao:

```text
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Para diagnostico rapido sem goldens:

```text
flutter test test/app test/architecture test/features test/shared test/theme
```

## Goldens

Os baselines visuais ficam em `test/goldens/goldens/`.

Execute:

```text
flutter test test/goldens/visual_goldens_test.dart
```

Arquivos em `test/goldens/failures/` sao artefatos temporarios de diagnostico e
nao devem ser versionados.

Atualize baselines somente depois de:

1. confirmar que a mudanca visual era intencional;
2. inspecionar as imagens de teste e diferenca;
3. validar que nao existe overflow ou perda de conteudo;
4. executar os testes de widget relacionados.

Com a revisao concluida:

```text
flutter test --update-goldens test/goldens/visual_goldens_test.dart
```

## Cobertura

Gere o relatorio bruto com:

```text
flutter test --coverage
```

A porcentagem isolada nao substitui cenarios de risco. Priorize cobertura de:

- transicoes de controller;
- estados offline, restrito, vazio e falha;
- preservacao de dados locais durante refresh;
- invariantes de operacoes locais;
- concorrencia entre requisicoes;
- largura compacta e `textScaler` alto.
