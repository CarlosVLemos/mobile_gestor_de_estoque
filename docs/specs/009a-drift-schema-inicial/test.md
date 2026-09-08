# Plano de validação — Spec 009A

## Cenário crítico: migração real

1. Criar banco físico no schema v1 da 008B.
2. Inserir `sync_outbox(id: 'sale-pending', status: 'pending')`.
3. Fechar completamente o banco.
4. Abrir o mesmo arquivo com o schema novo.
5. Comprovar:
   - migração concluída;
   - novas tabelas existentes;
   - `sync_outbox` existente;
   - linha `sale-pending` intacta.

O teste falha se a implementação apagar/recriar o arquivo.

## Banco novo

Validar criação direta na versão nova e CRUD mínimo das quatro tabelas novas.

## Produtos

- `price = null` round-trip;
- categoria nullable;
- FK `ON DELETE SET NULL`;
- tombstone preenche `deleted_at` e consulta operacional exclui a linha;
- reaparecimento do mesmo `id` pode limpar `deleted_at` por upsert futuro.

## Dashboard

Persistir snapshot com `revision`, metadados e `payload_json`; alteração da linha deve emitir atualização para observador Drift.

## Sync metadata

Validar independência entre coleções e round-trip de `cursor`, `checkpoint`, `target_checkpoint` e `revision`.

## Isolamento

Reutilizar `DatabaseFactory` para comprovar que dois pares user+tenant continuam em arquivos distintos após a migração.
