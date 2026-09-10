# Plano de validação — Spec 009B

## Concorrência

- dois gatilhos simultâneos no mesmo isolate resultam em uma execução efetiva;
- tentativa por segundo executor respeita `sync_locks`;
- lock expirado segue exatamente a política congelada;
- lock sempre é liberado em `finally`.

## Checkpoint

- página persistida com sucesso permite promover estado seguro;
- falha antes do commit mantém checkpoint anterior;
- reprocessar a última página não duplica registros.

## Lifecycle

- `stop(context)` bloqueia novas execuções imediatamente;
- execução ativa segue a política de cancelamento/timeout congelada;
- `DataPurgeService` não fecha o banco enquanto o engine ainda pode usá-lo;
- nenhuma Future atrasada toca no Drift após close;
- múltiplos stops convergem de forma idempotente.

## Gatilhos

- `resumed` respeita cooldown aprovado;
- pull-to-refresh ignora cooldown;
- foreground permanece caminho principal.

Execução registrada em `validation-result.md`: perfil focado do engine com 12 testes e suíte completa com 220 testes, ambos sem falhas.
