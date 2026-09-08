# Tasks: Spec 009A — Evolução do Schema Drift

- [ ] Confirmar contrato remoto e tipos reais antes de definir tabelas de catálogo/dashboard.
- [ ] Evoluir `AppDatabase` existente; não criar uma segunda classe de banco.
- [ ] Definir a próxima `schemaVersion` a partir da versão real v1.
- [ ] Adicionar tabelas de categorias, produtos, KPIs e checkpoints por migração versionada.
- [ ] Preservar `sync_outbox` sem remoção, renomeação, recriação ou expansão de protocolo.
- [ ] Implementar `MigrationStrategy` que preserve arquivo, dados e operações pendentes.
- [ ] Gerar código Drift somente após as alterações de schema estarem agrupadas.
- [ ] Criar teste de banco novo.
- [ ] Criar teste de upgrade: criar banco v1, inserir `sync_outbox`, fechar, abrir na nova versão e comprovar a preservação da linha e a criação das novas tabelas.
- [ ] Criar testes de `price = null`, integridade referencial e isolamento por contexto quando as tabelas forem definidas.
