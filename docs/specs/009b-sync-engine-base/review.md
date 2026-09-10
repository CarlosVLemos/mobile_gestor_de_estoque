# Spec 009B — Revisão de abertura atualizada

## Status

`DONE`

## O que foi corrigido

A spec antiga foi alinhada à 008B: `SyncLifecycle` já existe e será implementado pelo engine real. A exigência de mutex + lock persistido foi mantida porque é decisão da arquitetura mobile, especialmente para concorrência entre foreground/background.

## Dependência

009A foi implementada antes da 009B.

## Decisões implementadas

1. `SyncLifecycle.stop()` usa timeout seguro de 10 segundos e mantém o contexto recuperável quando não pode terminar;
2. lock persistido usa TTL de 2 minutos, heartbeat de 30 segundos e takeover condicionado à expiração/ownership.

## Gate

ABERTO, executado e validado. `contract.md` está `FROZEN`.

## Veredito

`passed` — implementação e gatilhos de foreground cobertos; consulte `validation-result.md`.
