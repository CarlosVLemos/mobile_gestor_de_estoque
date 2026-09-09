# Spec 009C — Revisão de abertura atualizada

## Status

`IMPLEMENTED` — 009A/009B foram entregues e a 009C foi integrada ao engine contextual.

## Auditoria backend

Auditado `CarlosVLemos/gestor_de_estoque` `dev` @ `4ef4b3ee6374848ff903ce1f467daeff0975b005`.

A spec antiga estava incorreta ao descrever produtos por `limit/page/has_more_pages`. O protocolo real usa `per_page`, cursor opaco, checkpoint, tombstones e `meta.next_cursor/has_more/target_checkpoint`.

O dashboard também foi corrigido: ele é snapshot por período/revision e não deve herdar o protocolo incremental de produtos. `category_id` é validado na request, mas a implementação auditada não o aplica no serviço; o mobile não dependerá desse filtro.

## Local-first

A UI continuará lendo Drift. HTTP apenas reconcilia o armazenamento local; falha de rede não apaga o último snapshot/catálogo.

## Gate

Contrato remoto `FROZEN`; alterações posteriores exigem Change Request.

## Veredito

Implementação concluída sem alterar backend, schema, SyncEngine ou outbox.
