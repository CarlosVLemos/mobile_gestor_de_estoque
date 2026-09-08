# Regras para testes

Mefisto é o owner do gate final, mas Van Gogh adiciona cobertura focada junto da implementação.

## Política

- teste unitário para regra/mapeamento/use case/controller relevante;
- widget/router para fluxo visual e redirects;
- integração somente quando atravessar boundaries que unit/widget não provam;
- migrations precisam de teste de upgrade e preservação;
- sync precisa de bootstrap, incremental, tombstone, falha parcial e retry aplicáveis;
- outbox precisa de idempotência, timeout/reconciliação e estados pending/confirmed/failed.

## Execução — gate explícito do usuário

Nenhum agente pode executar testes ou qualquer validação de terminal sem autorização explícita do usuário no contexto atual.

Sem autorização:

1. Mefisto identifica o menor conjunto de comandos necessário;
2. não executa os comandos;
3. apresenta os comandos exatos ao usuário;
4. pede que o usuário rode e forneça o resumo/saída relevante;
5. registra o resultado informado como evidência.

A permissão para executar um teste focado não implica permissão para suíte completa, `flutter analyze`, `dart format`, build ou integração.

Quando autorizado:

- teste afetado primeiro;
- `flutter analyze` apenas se incluído na autorização;
- suíte completa apenas no fechamento/merge e apenas se explicitamente autorizada;
- não repetir sem mudança relevante ou nova hipótese.

## Evidência

Nomeie testes pelo comportamento real. Evite testes que afirmem “401” sem disparar o fluxo de 401, por exemplo.
