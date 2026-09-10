# Test Plan — Spec 013D

Status: `READY`

- parser e default normal;
- demo sem `API_BASE_URL`;
- sessão/contexto demo;
- paths de banco distintos;
- seed idempotente;
- catálogo e dashboard Drift;
- Settings a partir da sessão demo;
- venda/outbox/identidade/replay sem HTTP;
- teardown demo sem tocar contexto normal;
- bootstrap normal sem providers demo;
- banner do runtime.

Gates:

```bash
flutter test --no-pub test/core/config test/app/demo test/features/sales/demo
flutter test --no-pub
flutter analyze --no-pub
```
