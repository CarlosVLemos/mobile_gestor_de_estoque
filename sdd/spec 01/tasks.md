# Tasks — SDD-001

## Regras operacionais
- Nenhuma implementação começa antes de `contract.md` ficar `FROZEN`.
- Mudança de escopo, schema, isolamento ou paths exige Change Request.
- Não reimplementar trabalho já materializado da antiga Spec 007.
- Não inventar autenticação, sync ou endpoint ausente.

## Contexto de execução
- **Execution mode:** `SINGLE_WRITER` durante a implementação inicial.
- **Parallelism:** bloqueado até contrato congelado; depois somente testes/documentação podem ocorrer em paralelo sem tocar os mesmos paths.
- **Partial audit / restrictions:** registrar qualquer validação impossível no ambiente.

## Fase 1 — Baseline e governança
- [ ] Confirmar aprovação humana das decisões D-001 a D-005 da `spec.md`.
- [ ] Marcar `contract.md` como `FROZEN` e registrar data.
- [ ] Auditar a antiga Spec 007 contra `lib/core/network`, `lib/core/errors` e `lib/core/result`.
- [ ] Registrar somente lacunas reais da camada de rede, sem ampliar esta Spec.
- [ ] Atualizar `para mobile/08-processo-de-trabalho.md` para reconhecer `sdd/` como processo formal, preservando `docs/specs/` como histórico.
- [ ] Registrar em `06-registro-decisoes.md` a decisão de processo/isolamento caso necessário.

## Fase 2 — Dependências e fundação Drift
- [ ] Adicionar `drift` e driver SQLite Flutter compatível.
- [ ] Adicionar `drift_dev` e `build_runner` em `dev_dependencies`.
- [ ] Definir `AppDatabase` com `schemaVersion = 1`.
- [ ] Criar tabelas `categories`, `products` e `sync_collections` conforme contrato.
- [ ] Implementar estratégia explícita de migrations sem fallback destrutivo.
- [ ] Gerar arquivos necessários e decidir/documentar política de versionamento de `.g.dart`.

## Fase 3 — Isolamento de contexto
- [ ] Criar modelo/valor interno de contexto de banco com `userId` e `tenantId`.
- [ ] Criar sanitização/nome determinístico de arquivo SQLite.
- [ ] Criar `DatabaseFactory` responsável por abrir/fechar banco.
- [ ] Garantir que mudar contexto fecha a conexão anterior antes da nova.
- [ ] Permitir contexto fixture apenas por injeção explícita para desenvolvimento/teste.
- [ ] Não acoplar a factory diretamente ao futuro AuthController inexistente.

## Fase 4 — DAO e mapeamento do catálogo
- [ ] Criar DAO/queries locais para categorias e produtos.
- [ ] Criar mapper Drift <-> domínio.
- [ ] Alterar `CatalogProduct.updatedAtLabel` para `DateTime updatedAt`.
- [ ] Mover qualquer formatação de `updatedAt` necessária para presentation/shared formatter.
- [ ] Preservar `price` nullable e enum de estoque.
- [ ] Preservar categoria opcional e imagem opcional.

## Fase 5 — Repository local e seed
- [ ] Criar implementação local de `CatalogRepository` usando DAO.
- [ ] Criar seed idempotente a partir das fixtures existentes para dev/test.
- [ ] Garantir que o seed não simule checkpoint/sync remoto concluído.
- [ ] Trocar `catalogRepositoryProvider` para a implementação persistente padrão.
- [ ] Manter `FixtureCatalogRepository` somente para testes específicos ou compatibilidade temporária explícita.
- [ ] Preservar filtros e estados do contrato atual de catálogo.

## Fase 6 — Integração de ciclo de vida
- [ ] Garantir inicialização do banco antes de o catálogo depender dele.
- [ ] Garantir descarte/fechamento adequado da conexão no ciclo de vida de teste/app aplicável.
- [ ] Evitar abertura duplicada concorrente para o mesmo contexto.
- [ ] Não modificar router/auth além do necessário; se surgir necessidade, abrir Change Request.

## Fase 7 — Testes
- [ ] Testar criação do schema v1.
- [ ] Testar isolamento contexto A x contexto B.
- [ ] Testar fechamento de conexão durante troca de contexto.
- [ ] Testar persistência após reabertura.
- [ ] Testar `price = null`.
- [ ] Testar `stock_quantity = 0`.
- [ ] Testar FK de categoria e `ON DELETE SET NULL`.
- [ ] Testar seed idempotente.
- [ ] Testar repository local e filtros já existentes.
- [ ] Atualizar testes de `CatalogProduct` afetados por `updatedAt`.
- [ ] Executar testes arquiteturais.
- [ ] Executar testes de widget do catálogo.

## Fase 8 — Validação e fechamento
- [ ] Executar `dart format` nos arquivos alterados.
- [ ] Executar `flutter analyze`.
- [ ] Executar `flutter test` ou o menor conjunto relevante + suíte arquitetural.
- [ ] Preencher `validation-result.md` com comandos e evidências.
- [ ] Preencher `review.md` com mudanças, riscos residuais e limitações.
- [ ] Confirmar que auth/sync/outbox não foram implementados incidentalmente.
- [ ] Marcar Spec como `done` somente após aceite e validação final.
