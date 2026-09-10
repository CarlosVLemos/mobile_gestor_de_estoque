# Contract — SDD-001

Status: SUPERSEDED
Version: 1
Change Request: N/A
Human approval / freeze date:
Superseded date: 2026-09-09
Supersession record: [`supersession.md`](supersession.md)

> Registro histórico: este contrato permaneceu em `DRAFT`, nunca foi `FROZEN` e não autorizou implementação.

## Scope

### Problema resolvido
Materializar a primeira fundação local-first do aplicativo por meio de Drift/SQLite e tornar o catálogo dependente de persistência local, preservando as fronteiras arquiteturais existentes.

### Fora de escopo
- autenticação mobile real;
- token/secure storage;
- sincronização remota;
- SyncEngine;
- outbox e vendas offline;
- dashboard persistente;
- background sync;
- cache de imagens.

## Allowed paths

### Flutter owner files
- `pubspec.yaml`
- `pubspec.lock`
- `lib/core/database/**`
- `lib/features/catalog/application/**`
- `lib/features/catalog/data/**`
- `lib/features/catalog/domain/**`
- `lib/features/catalog/catalog_providers.dart`
- `test/core/database/**`
- `test/features/catalog/**`

### Shared/documentation files
- `sdd/spec 01/**`
- `para mobile/08-processo-de-trabalho.md`
- `para mobile/06-registro-decisoes.md` somente se a mudança de processo/isolamento precisar virar decisão aceita

### Paths proibidos sem Change Request
- `lib/features/auth/**`
- `lib/core/sync/**`
- `lib/features/sales/**`
- `lib/features/dashboard/**`
- `lib/app/router/**`
- endpoints ou código do backend em outro repositório

## Ownership
- Coordination/contract owner: Coordenação Mobile
- Flutter implementation owner: Implementação Flutter
- Validation owner: Qualidade
- Shared files owner: Coordenação Mobile

## Contexto e isolamento local

- O banco operacional deve ser identificado pelo par `userId + tenantId`.
- O código de produção não deve assumir tenant único.
- Enquanto autenticação mobile não existir, `appFixtureAccessProfile` pode fornecer o contexto somente para desenvolvimento/teste controlado.
- O mecanismo de nome do arquivo deve ser determinístico e sanitizado; IDs brutos não devem permitir path traversal.
- Troca de contexto exige encerramento da conexão anterior antes da abertura da próxima.

## Persistence

### Dependências
- `drift`
- driver SQLite compatível com Flutter adotado pela implementação
- `drift_dev`
- `build_runner`

A escolha exata do driver deve ser registrada no fechamento se houver mais de uma opção tecnicamente viável.

### Schema version
- versão inicial: `1`
- qualquer alteração posterior de schema exige migration explícita e teste de preservação de dados.

### Tabelas

#### categories
- `id`: text PK
- `name`: text NOT NULL

#### products
- `id`: text PK
- `name`: text NOT NULL
- `sku`: text NOT NULL
- `brand`: text NOT NULL
- `price`: real NULL
- `stock_quantity`: integer NOT NULL
- `stock_status`: text NOT NULL, valores aceitos `available | low | out`
- `is_available_for_sale`: boolean NOT NULL
- `image_url`: text NULL
- `category_id`: text NULL FK -> categories.id, `ON DELETE SET NULL`
- `updated_at`: datetime NOT NULL

#### sync_collections
- `collection`: text PK
- `mode`: text NOT NULL
- `cursor`: text NULL
- `last_success_at`: datetime NULL
- `is_bootstrapped`: boolean NOT NULL default false
- `total_received`: integer NOT NULL default 0
- `last_error`: text NULL

### Regras de persistência
- nenhum fallback de migração pode apagar automaticamente o banco;
- fixtures devem entrar pelo banco mediante seed idempotente;
- seed repetido não duplica registros;
- a UI não acessa DAO ou Drift diretamente;
- o domínio não importa classes geradas pelo Drift.

## Catalog contract

Fluxo obrigatório:

```text
CatalogPage
  -> CatalogController
    -> LoadCatalogUseCase
      -> CatalogRepository
        -> CatalogDao
          -> AppDatabase
```

### CatalogProduct

A entidade deve expor valor temporal semântico:

```text
DateTime updatedAt
```

Não deve manter `updatedAtLabel` como dado de domínio após a migração desta Spec.

### CatalogRepository

- continua sendo o contrato consumido pelo use case;
- a implementação padrão deve ser baseada em persistência local;
- filtros já suportados pelo catálogo devem continuar com comportamento equivalente;
- `price = null` é valor válido;
- estoque zero não remove o produto do catálogo;
- restrição de feature/permissão não deve ser convertida em erro genérico.

## Seed de desenvolvimento

- deve existir mecanismo explícito de seed para popular o banco em ambiente sem integração remota;
- deve ser idempotente;
- não deve existir na `presentation`;
- não deve mascarar ausência de integração remota como sincronização concluída;
- testes podem injetar bancos temporários/in-memory.

## Acceptance criteria

- **AC-001:** dependências Drift e geração de código configuradas sem quebrar `flutter analyze`.
- **AC-002:** `AppDatabase` schema v1 contém exatamente as tabelas acordadas para esta Spec.
- **AC-003:** o banco aberto para contexto A utiliza arquivo/conexão diferente do contexto B.
- **AC-004:** trocar de contexto fecha a conexão anterior antes de expor a nova.
- **AC-005:** um produto persistido continua disponível após fechar e reabrir o banco do mesmo contexto.
- **AC-006:** `price = null` round-tripa pelo banco sem erro.
- **AC-007:** produto com `stock_quantity = 0` permanece consultável.
- **AC-008:** `FixtureCatalogRepository` deixa de ser a implementação padrão do `catalogRepositoryProvider`.
- **AC-009:** fixture usada em desenvolvimento é inserida por seed idempotente na persistência local.
- **AC-010:** `CatalogProduct` usa `DateTime updatedAt`, deixando formatação de data fora do domínio.
- **AC-011:** apresentação/application/domain continuam respeitando os testes de fronteira arquitetural.
- **AC-012:** filtros e estados atuais do catálogo não sofrem regressão funcional relevante.
- **AC-013:** nenhuma implementação de autenticação, sync remoto ou outbox é adicionada incidentalmente.
- **AC-014:** `dart format`, `flutter analyze` e a suíte relevante de `flutter test` passam sem falhas introduzidas.

## Governance
- Spec state: `draft` | `ready` | `in_progress` | `paused` | `blocked` | `done` | `cancelled` | `superseded` | `rejected`
- Validation verdicts: `passed` | `failed` | `blocked` | `passed_with_restrictions`
- Individual results: `PASS` | `FAIL` | `BLOCKED` | `NOT_RUN`
- Partial audit: yes | no
- Reduced profile: no

## Validation mapping
- AC-001 -> CT-01, CT-02
- AC-002 -> CT-03
- AC-003 -> CT-04
- AC-004 -> CT-05
- AC-005 -> CT-06
- AC-006 -> CT-07
- AC-007 -> CT-08
- AC-008 -> CT-09
- AC-009 -> CT-10
- AC-010 -> CT-11
- AC-011 -> CT-12
- AC-012 -> CT-13, CT-14
- AC-013 -> CT-15
- AC-014 -> CT-01, CT-02, CT-16
