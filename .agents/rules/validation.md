---
description: Regras de validação e QA
trigger: glob
globs: "test/**, integration_test/**, docs/specs/**"
---

- Teste deve provar comportamento, não apenas executar caminho feliz.
- Nome do teste precisa corresponder ao que ele realmente exercita.
- Prefira fake/override em Riverpod para router/controller quando a API real não é o objeto do teste.
- Auth, tenant isolation, migração, sync e outbox exigem cenários de erro.
- Não remova teste antigo só porque a arquitetura mudou; migre a premissa quando o comportamento válido mudou.
- Suíte completa é gate final, não loop de implementação.

- Evidência de CI deve corresponder ao SHA candidato; nenhum teste ausente é PASS.
- Alteração de skill não pode reduzir critérios de aceite nem alterar baseline sem aprovação.
