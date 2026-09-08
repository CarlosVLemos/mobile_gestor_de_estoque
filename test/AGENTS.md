# Regras para testes

Mefisto é o owner do gate final, mas Van Gogh adiciona cobertura focada junto da implementação.

## Política

- teste unitário para regra/mapeamento/use case/controller relevante;
- widget/router para fluxo visual e redirects;
- integração somente quando atravessar boundaries que unit/widget não provam;
- migrations precisam de teste de upgrade e preservação;
- sync precisa de bootstrap, incremental, tombstone, falha parcial e retry aplicáveis;
- outbox precisa de idempotência, timeout/reconciliação e estados pending/confirmed/failed.

## Execução

- não rodar suíte inteira a cada mudança;
- teste afetado primeiro;
- `flutter analyze` no gate;
- suíte completa antes de merge/fechamento, salvo instrução contrária explícita;
- não repetir sem mudança relevante.

## Evidência

Nomeie testes pelo comportamento real. Evite testes que afirmem “401” sem disparar o fluxo de 401, por exemplo.
