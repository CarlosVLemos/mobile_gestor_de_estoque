---
description: Regras de validação e QA
paths:
  - "test/**"
  - "integration_test/**"
  - "docs/specs/**"
---

- Teste deve provar comportamento, não apenas executar caminho feliz.
- Nome do teste precisa corresponder ao que ele realmente exercita.
- Prefira fake/override em Riverpod para router/controller quando a API real não é o objeto do teste.
- Auth, tenant isolation, migração, sync e outbox exigem cenários de erro.
- Não remova teste antigo só porque a arquitetura mudou; migre a premissa quando o comportamento válido mudou.
- Suíte completa é gate final, não loop de implementação.
