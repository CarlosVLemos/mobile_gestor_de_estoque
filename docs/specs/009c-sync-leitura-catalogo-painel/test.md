# Validação — Spec 009C

## Estado

Testes escritos, nenhum executado nesta sessão sem Dart/Flutter. A compilação
exige primeiro resolução de dependências e geração do schema Drift.

```sh
flutter pub get
dart run build_runner build
dart format lib test
flutter analyze
flutter test test/core/database test/core/sync
flutter test test/features/catalog test/features/dashboard test/features/reading_reactivity_test.dart
flutter test test/app test/architecture test/shared test/theme
flutter test
```

## Cenários automatizados preparados

- Bootstrap paginado de produtos, categorias precedendo produtos, preço nulo,
  upsert idempotente e dados/checkpoint preservados em falha parcial.
- Nova execução repete página 1; não testar retomada por offset estável inexistente.
- Filtro updated_since fixo quando checkpoint confiável é fornecido; sem promoção
  de timestamp máximo/local a watermark remoto.
- Payload inválido aborta página; HTTP 401/403/429/500 preserva banco e classifica falha.
- Catálogo observa alterações do banco e filtra SKU/categoria localmente.
- Painel substitui KPIs/alertas/detalhes e reverte tudo se checkpoint falhar.
- Preço/KPI nulo e bloqueio de snapshot financeiro antigo por perfil restrito.
- Controllers preservam dados durante refresh/falha e descartam resultados atrasados.
- Widgets exibem atualizações de stream, aviso de sync e bloqueio em 401/403.
- Desmontagem cancela assinatura; catálogo preparado para 320px e textScaler 2x.

## Pendências de integração real

O decoder de dashboard no teste é um dublê explícito. Confirmar o contrato do
backend, implementar o decoder real e acrescentar fixtures HTTP fiéis ao contrato.
A composição atual não abre sessão/banco anônimo; validar com injeção de contexto
correto depois de concluir 008/008B.

No dispositivo: reinício offline com cache, perda de rede na página intermediária,
refresh preservando conteúdo, mudança de usuário/tenant, negação de acesso e
revalidação da sessão. Inspecionar painel e catálogo em 320px/texto 2x e goldens.
A shell usa IndexedStack: alternar aba pode preservar widgets montados, portanto
não confundir troca de aba com descarte de assinatura por autoDispose.

Detalhes e evidências disponíveis em [estado atual](../../estado-atual.md).
