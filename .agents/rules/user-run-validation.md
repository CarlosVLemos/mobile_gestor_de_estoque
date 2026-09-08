---
description: Execução de testes e validações depende de autorização explícita do usuário
alwaysApply: true
---

# User-Run Validation Gate

## Regra principal

Agentes não podem executar testes, análise estática, formatação, build ou qualquer comando de validação que lance processo de terminal sem autorização explícita do usuário para aquela execução.

Isso inclui, entre outros:

- `flutter test`;
- `dart test`;
- `flutter analyze`;
- `dart analyze`;
- `dart format`;
- `flutter build ...`;
- testes de integração;
- scripts de validação equivalentes;
- wrappers como `make test`, `just test`, PowerShell/Bash que chamem os comandos acima.

Também não é permitido contornar esta regra disparando a mesma execução por MCP, subprocesso, task runner ou ferramenta equivalente. MCPs podem ser usados para leitura, símbolos, documentação e diagnostics não destrutivos que não executem a suíte/teste/build.

## Autorização

A permissão precisa ser explícita e específica no contexto atual, por exemplo:

- `pode rodar os testes`;
- `pode executar flutter analyze`;
- `rode a suíte completa`;
- `pode validar pelo terminal`.

Não presuma autorização porque:

- o usuário autorizou em outra conversa ou tarefa;
- uma spec diz que testes são obrigatórios;
- a entrega está no gate final;
- Mefisto considera o teste necessário;
- um comando semelhante foi autorizado anteriormente.

A autorização vale somente para o escopo razoavelmente coberto pelo pedido atual. Para ampliar de teste focado para suíte completa, build ou integração, peça nova autorização quando isso não estiver claramente incluído.

## Comportamento sem autorização

Quando chegar ao ponto de validar:

1. identifique o menor conjunto de comandos necessário;
2. não execute;
3. apresente os comandos exatos ao usuário;
4. peça para o usuário rodar e enviar o resumo/saída relevante;
5. continue a revisão usando a evidência fornecida pelo usuário.

Não fique esperando ou fazendo polling do terminal do usuário.

## Escrita de testes

Esta regra não proíbe criar ou corrigir arquivos de teste. Van Gogh/Mefisto podem escrever cobertura normalmente. O bloqueio é sobre executar comandos/processos de validação sem permissão.

## Exceções

Somente uma instrução explícita do usuário no contexto atual pode liberar a execução. Segurança e restrições superiores continuam valendo.
