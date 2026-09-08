---
description: Política de economia de terminal, latência e tokens
alwaysApply: true
---

# Terminal Budget

## Implementação

- Prefira Dart MCP, GitHub MCP e leitura estática ao shell quando suficientes.
- Não rode `flutter test` após cada edição.
- Não rode `flutter analyze` repetidamente sem novo lote relevante.
- Não inicie `flutter run`, emulator, Docker, watcher, servidor ou processo persistente sem pedido explícito.
- Não faça polling contínuo de processo longo.
- Não repita comando que já produziu evidência válida sem mudança de código ou nova hipótese.
- Agrupe alterações antes de validar.

## Gate

Mefisto escolhe o menor conjunto que prova a mudança. Suíte completa apenas no fechamento/merge ou quando uma mudança transversal justificar.

Se uma verificação depender de ambiente local, device, WSL, Docker ou VPS, forneça ao usuário o comando exato e use o resultado informado como evidência.
