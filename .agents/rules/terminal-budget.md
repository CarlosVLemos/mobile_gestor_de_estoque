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
