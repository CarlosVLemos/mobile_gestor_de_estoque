---
name: local-first-sync
description: Use em isolamento local, sync incremental, offline, checkpoint, tombstones, retry e outbox do Arara-Gastos Mobile.
---

# Local-first Sync

## Invariantes

- UI lê estado local; sync atualiza o banco.
- servidor é soberano para confirmação e estoque.
- pending local nunca vira confirmed sem resposta/reconciliação remota.
- timeout não prova rejeição nem confirmação.
- operação offline precisa de ID estável/idempotente.
- tenant/user context nunca pode misturar dados.
- tombstones devem remover/invalidar localmente sem ressuscitar registro antigo.
- checkpoint só avança quando a coleção correspondente foi aplicada com segurança.

## Planejamento obrigatório

Defina:

- source of truth;
- chave de isolamento;
- bootstrap vs incremental;
- cursor/checkpoint;
- tombstones;
- transação local;
- política de retry;
- comportamento de falha parcial;
- observabilidade mínima;
- testes de reinício/offline/reconciliação.

Se o contrato remoto não confirmar esses campos, pare e acione Maquiavel.
