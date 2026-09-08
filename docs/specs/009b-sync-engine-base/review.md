# Spec 009B — Revisão de abertura atualizada

## Status

`BLOCKED`

## O que foi corrigido

A spec antiga foi alinhada à 008B: `SyncLifecycle` já existe e será implementado pelo engine real. A exigência de mutex + lock persistido foi mantida porque é decisão da arquitetura mobile, especialmente para concorrência entre foreground/background.

## Dependência

009A precisa estar implementada antes da escrita da 009B.

## Blockers reais

1. política de timeout/falha de `SyncLifecycle.stop()` no logout/expiração;
2. TTL/renovação/takeover do lock persistido.

Nenhum valor foi inventado para fechar esses pontos.

## Gate

FECHADO. `contract.md` permanece DRAFT/BLOCKED até decisão explícita.

## Veredito

`BLOCKED` — escopo e arquitetura estão claros, mas os dois parâmetros de segurança acima precisam de decisão antes de implementação.
