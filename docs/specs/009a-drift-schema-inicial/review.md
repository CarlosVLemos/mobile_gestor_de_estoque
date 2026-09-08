# Spec 009A — Revisão de Abertura Atualizada

## Status

Planejada. Não implementada.

## Premissas confirmadas pela 008B

- Drift e SQLite já são dependências do projeto.
- `AppDatabase` já existe, com schemaVersion `1` e tabela `sync_outbox`.
- `DatabaseFactory` abre bancos físicos isolados por usuário + tenant.
- `build_runner` e `drift_dev` já estão configurados; geração não é tarefa de
  setup inicial.

## Escopo futuro

Evoluir o schema v1 por migração segura para tabelas de leitura local. A 009A
não pode destruir ou remodelar a outbox mínima deixada pela 008B.

## Gate de implementação

FECHADO. O contrato da futura evolução está em rascunho e os tipos remotos
necessários ainda exigem confirmação antes de congelamento.

## Veredito

Documentação atualizada para partir do estado real da 008B; nenhuma parte da
009A foi implementada.
