# Suite de testes

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
