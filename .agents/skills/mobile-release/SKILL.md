---
name: mobile-release
description: Use para preparar APK/release, ambientes, API_BASE_URL, Android permissions, HTTPS/VPS e smoke end-to-end do Arara-Gastos Mobile.
---

# Mobile Release

## Checklist de readiness

- `API_BASE_URL` configurável por ambiente;
- INTERNET no manifest aplicável ao release;
- cleartext somente em dev se realmente necessário;
- HTTPS em staging/produção;
- nenhum segredo/token embutido no APK;
- assinatura/applicationId tratados conforme objetivo do build;
- versão/build number definidos;
- logging/redaction seguros;
- login, cold start, sync, offline/online e venda exercitados no endpoint implantado.

## Smoke mínimo

```text
instalação limpa
→ login
→ fechar/reabrir
→ restauração da sessão
→ sync inicial
→ abrir dados offline
→ reconectar
→ registrar operação crítica
→ reconciliar
```

Build/deploy e processos persistentes dependentes de ambiente local só devem ser executados com pedido explícito do usuário.
