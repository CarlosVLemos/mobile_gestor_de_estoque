# Spec 009B: Sync Engine Base

## Status

`blocked` para implementação até duas decisões explícitas serem fechadas no `contract.md`: política de falha de `SyncLifecycle.stop()` e duração/renovação do TTL do lock persistido.

## Dependência

Requer 009A implementada, pois usa `sync_collections` e o `AppDatabase` contextual.

## Objetivo

Implementar um único motor de sincronização por contexto ativo, responsável por concorrência, lifecycle, checkpoints e execução ordenada de coleções. O motor não conhece widgets nem detalhes do Laravel.

## Integração com 008B

Já existe `SyncLifecycle.stop(LocalContext context)`. A 009B deve fornecer a implementação real desse boundary; não cria lifecycle paralelo.

Antes de `DatabaseFactory.closeActive()`:

- novas rodadas daquele contexto devem ser bloqueadas;
- execução ativa deve receber cancelamento/stop;
- o fechamento deve aguardar o término seguro definido pelo contrato;
- nenhuma Future atrasada pode continuar usando Drift após o close.

## Concorrência

A arquitetura canônica exige:

1. mutex em memória para o mesmo isolate;
2. lock persistido para proteger execuções em isolates/processos distintos (ex.: foreground e worker);
3. owner identificável;
4. TTL para recuperar lock abandonado;
5. liberação em `finally`.

A tabela `sync_locks` pertence à 009B e deve ser adicionada por migração posterior à 009A, nunca por reset do banco.

## Execução

O engine executa coleções registradas em ordem. Cada coleção controla seu protocolo remoto, mas o engine fornece:

- exclusão mútua;
- estado global reativo;
- cancelamento/lifecycle;
- leitura/escrita segura de `sync_collections`;
- gatilhos manuais e automáticos;
- cooldown para gatilhos de `resumed` conforme decisão vigente.

## Checkpoint

O engine não promove cursor/checkpoint antes de a coleção confirmar persistência local da página. Falha parcial mantém o último estado seguro.

## Gatilhos

- startup autenticado;
- pull-to-refresh;
- `resumed` com throttling;
- retorno de conectividade quando houver health check real;
- background apenas como auxílio.

## Fora de escopo

- mapping de produtos/dashboard (009C);
- outbox de vendas (010);
- background como garantia de entrega.

## Critérios de aceite

- nunca há duas execuções que alterem checkpoints ao mesmo tempo;
- lock abandonado é recuperável sem apagar dados;
- `stop(context)` impede uso do banco após fechamento;
- lock é liberado em sucesso, falha e cancelamento;
- checkpoint não avança em falha parcial;
- cooldown não impede refresh manual;
- testes cobrem concorrência, stale lock, finally, stop e cancelamento.
