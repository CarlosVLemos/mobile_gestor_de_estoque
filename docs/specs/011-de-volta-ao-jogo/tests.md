# Tests — SDD-001

Status: `SUPERSEDED`

> Plano histórico não executado. A Spec 011 não chegou à implementação nem ao gate de QA; consulte [`supersession.md`](supersession.md).

## Objetivo
Validar que a primeira fundação local-first é persistente, isolada por contexto, não destrutiva e mantém o comportamento funcional do catálogo.

## Estratégia
- testes unitários para factory, mapper e repository;
- testes de banco Drift com arquivos temporários ou conexão de teste adequada;
- testes de widget/regressão do catálogo já existentes;
- testes arquiteturais do projeto;
- análise estática e formatação.

## Casos de teste

### CT-01 — Formatação
**Mapeia:** AC-001, AC-014

Executar:
```bash
dart format --output=none --set-exit-if-changed lib test
```

Resultado esperado: exit code 0 para os arquivos no escopo da alteração.

### CT-02 — Análise estática
**Mapeia:** AC-001, AC-014

Executar:
```bash
flutter analyze
```

Resultado esperado: nenhuma falha introduzida pela Spec.

### CT-03 — Schema v1
**Mapeia:** AC-002

Verificar:
- criação de `categories`;
- criação de `products`;
- criação de `sync_collections`;
- tipos/nullability/PK/FK conforme contrato;
- `schemaVersion == 1`.

### CT-04 — Isolamento entre contextos
**Mapeia:** AC-003

Dado contexto A e contexto B com IDs distintos:
1. abrir A;
2. persistir produto exclusivo de A;
3. fechar/trocar para B;
4. confirmar que B não encontra produto de A;
5. reabrir A;
6. confirmar que A ainda encontra o registro.

### CT-05 — Fechamento na troca de contexto
**Mapeia:** AC-004

Instrumentar/fakear a factory para comprovar que `close()` da conexão anterior conclui antes da exposição da conexão do novo contexto.

### CT-06 — Persistência após reabertura
**Mapeia:** AC-005

1. abrir banco;
2. inserir produto;
3. fechar banco;
4. reabrir o mesmo arquivo/contexto;
5. consultar produto.

Resultado: registro preservado.

### CT-07 — Preço nulo
**Mapeia:** AC-006

Persistir produto com `price = null`, ler novamente e confirmar null sem exceção nem coerção para zero.

### CT-08 — Estoque zero
**Mapeia:** AC-007

Persistir produto com `stock_quantity = 0` e `stock_status = out`.

Resultado: produto continua retornado pelas consultas gerais de catálogo.

### CT-09 — Provider usa repository local
**Mapeia:** AC-008

Testar o container Riverpod padrão e confirmar que `catalogRepositoryProvider` resolve para implementação local persistente, não `FixtureCatalogRepository`.

### CT-10 — Seed idempotente
**Mapeia:** AC-009

Executar o seed de desenvolvimento duas vezes.

Resultado:
- mesma quantidade de registros;
- IDs preservados;
- sem duplicação;
- nenhum checkpoint marcado falsamente como sync remoto concluído.

### CT-11 — Domínio usa DateTime
**Mapeia:** AC-010

Confirmar que `CatalogProduct` expõe `DateTime updatedAt` e que nenhuma regra de domínio depende de string formatada de data.

### CT-12 — Fronteiras arquiteturais
**Mapeia:** AC-011

Executar:
```bash
flutter test test/architecture
```

Resultado esperado: todos os testes passam.

### CT-13 — Repository e filtros
**Mapeia:** AC-012

Cobrir no repository local os filtros já suportados pelo catálogo, preservando comportamento de busca/categoria/ordenação conforme o contrato atual.

### CT-14 — Widget/regressão do catálogo
**Mapeia:** AC-012

Executar testes existentes de catálogo, especialmente estados e renderização compacta.

Comando mínimo:
```bash
flutter test test/features/catalog
```

### CT-15 — Escopo negativo
**Mapeia:** AC-013

Auditoria por diff deve confirmar ausência de implementação incidental em:
- `lib/features/auth/**`;
- `lib/core/sync/**`;
- `lib/features/sales/**`;
- backend remoto.

### CT-16 — Suíte relevante
**Mapeia:** AC-014

Preferencialmente:
```bash
flutter test
```

Se o ambiente impedir a suíte completa, executar o subconjunto relevante e registrar explicitamente a restrição em `validation-result.md`.

## Teste futuro de migração

A Spec 01 cria apenas schema v1, portanto não existe migração v0 -> v1 de dados de usuário a preservar. A partir da primeira alteração de schema, toda Spec que tocar banco deverá incluir teste criando o banco na versão anterior, inserindo dados e comprovando preservação após upgrade.

## Evidências obrigatórias

Para cada comando executado, registrar em `validation-result.md`:
- comando;
- ambiente relevante;
- exit code;
- resumo do resultado;
- falhas encontradas;
- restrições ou testes não executados.
