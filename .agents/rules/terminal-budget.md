---
description: Política de economia de terminal, latência, tokens e autorização de validação
alwaysApply: true
---

# Terminal Budget

## Regra de autorização

Nenhum agente pode executar testes, análise estática, formatação, build ou comando equivalente de validação sem autorização explícita do usuário no contexto atual.

Isso inclui `flutter test`, `dart test`, `flutter analyze`, `dart analyze`, `dart format`, `flutter build`, testes de integração e wrappers equivalentes, mesmo quando chamados por MCP, task runner, script, subprocesso ou ferramenta indireta.

Sem autorização, prepare os comandos exatos, peça ao usuário para executá-los e use a evidência enviada por ele. Não presuma autorização implícita, anterior ou herdada de outra tarefa.

## Implementação

- Prefira Dart MCP, GitHub MCP e leitura estática ao shell quando suficientes.
- Não inicie `flutter run`, emulator, Docker, watcher, servidor ou processo persistente sem pedido explícito.
- Não faça polling contínuo de processo longo.
- Não repita comando que já produziu evidência válida sem mudança de código ou nova hipótese.
- Agrupe alterações antes de validar.

## Gate

Mefisto escolhe o menor conjunto que prova a mudança, mas não o executa sem autorização explícita. Suíte completa continua sendo o gate recomendado no fechamento/merge, porém deve ser executada pelo usuário até que ele libere deliberadamente a execução pelo agente.

Se a autorização concedida for apenas para um teste focado, não amplie silenciosamente para suíte completa, análise, build ou integração.

Se uma verificação depender de ambiente local, device, WSL, Docker ou VPS, forneça ao usuário o comando exato e use o resultado informado como evidência.

## Hard Budget de Terminal

O terminal é um recurso de último recurso para implementação e validação. O objetivo é minimizar latência, volume de saída e consumo de contexto/tokens.

### Separação de autorizações

Autorização para implementar uma spec, feature ou correção **não constitui autorização para executar comandos de validação**.

Permissão de escrita e permissão de terminal são independentes.

Frases como:

* `implemente a spec`;
* `faça a feature`;
* `corrija o problema`;
* `execute integralmente`;

não autorizam `flutter test`, `flutter analyze`, build, codegen, formatter ou comandos equivalentes.

A execução depende de autorização explícita para terminal/validação.

### Budget quando autorizado

Mesmo quando houver autorização para validar:

1. escolha o menor conjunto possível;
2. execute no máximo **2 comandos de validação** por ciclo de implementação, salvo autorização explícita para ampliar;
3. prefira arquivo de teste específico, grupo específico ou análise focada;
4. não execute suíte completa automaticamente;
5. agrupe todas as alterações antes de validar;
6. não repita uma validação bem-sucedida sem alteração posterior diretamente relacionada.

### Processos demorados

Não acompanhe processos longos por polling.

Depois de iniciar um comando:

* não consulte repetidamente o terminal apenas para observar progresso;
* não mantenha ciclos de espera;
* não faça chamadas sucessivas para obter pequenas parcelas da saída;
* não desperdice contexto reproduzindo logs intermediários.

Se uma validação não concluir prontamente ou for conhecida por ser demorada, interrompa a estratégia de acompanhamento e entregue ao usuário o comando exato para execução local.

A validação deve então ser registrada como pendente até que o usuário forneça o resultado.

### Economia de saída

Prefira modos de saída compactos quando disponíveis.

Não carregue logs extensos para o contexto do agente quando apenas código de saída, resumo de sucesso/falha ou últimas linhas relevantes forem suficientes.

Em caso de falha, inspecione somente a região necessária para identificar a causa.

### Flutter/Dart

Por padrão:

* não execute `flutter test` automaticamente;
* não execute `flutter analyze` automaticamente;
* não execute `flutter build`;
* não execute `dart format` global;
* não execute `build_runner` repetidamente.

Quando autorizado:

* prefira testes focados;
* execute `flutter analyze` no máximo uma vez no gate final, salvo correção diretamente causada pelo resultado;
* execute codegen somente após agrupar alterações que afetem geração;
* nunca use `flutter run`, watchers ou processos persistentes para validação comum.

### Regra de parada

Quando leitura estática, diagnostics do MCP ou inspeção do código já fornecerem evidência suficiente para continuar implementando, não use terminal.

Terminal serve para confirmar hipóteses, não para substituir raciocínio ou inspeção estática.
