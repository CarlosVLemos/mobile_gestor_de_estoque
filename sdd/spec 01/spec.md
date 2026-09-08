# Spec 01 — Fundação Local-First: Drift e Primeira Vertical Persistente do Catálogo

Status: `draft`
Data de abertura: 2026-09-08
Owner: Coordenação Mobile
Execution mode: `SINGLE_WRITER` até `contract.md` ficar `FROZEN`

## Objetivo

Transformar a arquitetura local-first já aceita em uma primeira capacidade concreta e testável, sem antecipar autenticação, sincronização remota ou vendas offline que ainda dependem de contratos externos.

A entrega deve criar a fundação Drift/SQLite, formalizar o isolamento do banco por contexto de usuário/tenant e fazer o catálogo deixar de depender diretamente de fixture em memória para leitura operacional.

Ao final desta Spec, o catálogo deve conseguir renderizar dados persistidos localmente, sobreviver ao reinício do aplicativo e continuar respeitando as regras existentes de permissão, preço anulável e produto sem estoque.

## Problema atual

O projeto possui uma arquitetura bem definida, testes arquiteturais, Riverpod, `go_router`, Dio, tratamento de erros e estrutura por feature. Entretanto, a parte central do local-first ainda não está materializada:

- `lib/core/database/` ainda não possui banco operacional;
- `lib/core/sync/` ainda não possui motor de sincronização;
- o catálogo usa `FixtureCatalogRepository` e `catalog_fixture.dart`;
- o estado atual não comprova persistência após reinício;
- autenticação mobile por token ainda não está disponível;
- existem Specs antigas planejando rede, autenticação, Drift, sync e outbox, mas planejamento não equivale a implementação.

O risco principal é continuar expandindo a arquitetura horizontalmente e acumular mais estruturas planejadas sem fechar uma vertical real.

## Decisão de processo desta abertura

A partir desta Spec, a pasta `sdd/` passa a ser a nova superfície proposta para especificações formais do mobile, tomando como referência o modelo de SDD usado no repositório web, mas adaptado ao Flutter.

Esta decisão deve ser refletida posteriormente em `para mobile/08-processo-de-trabalho.md` e, se necessário, em `para mobile/06-registro-decisoes.md` antes de ser considerada normativa para todas as próximas Specs.

Os documentos existentes em `docs/specs/` permanecem como histórico e referência. Eles não devem ser apagados nem reescritos retroativamente.

## Escopo

Esta Spec cobre somente a primeira fundação persistente do app:

1. auditar o que da antiga Spec 007 já está implementado e evitar reimplementação desnecessária;
2. congelar a estratégia de isolamento físico do banco por contexto de usuário/tenant;
3. adicionar e configurar Drift/SQLite;
4. criar `DatabaseFactory` e ciclo de vida seguro da conexão;
5. criar o schema inicial mínimo para catálogo e metadados de persistência;
6. criar DAOs/mappers necessários ao catálogo;
7. substituir a leitura operacional direta de fixture por um repositório local persistente;
8. usar fixture somente como seed explícito de desenvolvimento/teste enquanto autenticação e sync remoto não estiverem disponíveis;
9. preservar os estados de UI e o comportamento já coberto por testes;
10. criar testes de persistência, isolamento e regressão.

## Fora de escopo

Não faz parte desta Spec:

- implementar `POST /api/mobile/login` ou qualquer endpoint inexistente;
- armazenar token ou implementar `flutter_secure_storage`;
- consumir o catálogo remoto em produção;
- implementar `SyncEngine`, delta sync, retry, tombstones ou locks de sincronização;
- implementar outbox;
- persistir vendas;
- migrar dashboard para Drift;
- Workmanager ou execução em background;
- cache de imagens em filesystem;
- relatórios;
- criar tabelas especulativas para contratos ainda não existentes;
- alterar regras visuais do catálogo além do mínimo necessário para adaptar tipos persistidos.

## Relação com Specs anteriores

Esta Spec consolida o primeiro recorte executável das seguintes Specs históricas:

- `007-core-rede-erros-resultado`: usar como referência e auditar o que já foi entregue; não reimplementar Dio, redação ou `Result` que já existirem corretamente;
- `008b-isolamento-contexto-local`: aproveitar a proposta de isolamento físico por usuário/tenant, mas formalizar a decisão antes de implementar;
- `009a-drift-schema-inicial`: reaproveitar somente o que continuar compatível com a arquitetura canônica;
- `009b-sync-engine-base`: permanece fora do escopo;
- `009c-sync-leitura-catalogo-painel`: permanece fora do escopo remoto nesta etapa;
- `010-outbox-vendas`: permanece fora do escopo.

Quando houver conflito, prevalece a hierarquia já definida no projeto: decisão aceita, arquitetura canônica, regras de negócio e somente depois Specs históricas.

## Ordem de execução prioritária

### P0 — Governança e baseline

- registrar esta Spec e congelar o contrato;
- comparar a Spec 007 com o código atual;
- listar lacunas reais sem reabrir trabalho já materializado;
- atualizar a documentação de processo para reconhecer `sdd/` após aprovação humana.

### P0 — Isolamento e banco

- formalizar banco físico separado por contexto usuário/tenant;
- criar uma chave de contexto estável para localizar o arquivo SQLite sem misturar dados entre contextos;
- a conexão deve ser aberta e fechada por uma abstração de fábrica, não diretamente por páginas ou features;
- o perfil fixture atual pode fornecer contexto temporário somente em desenvolvimento/teste.

### P0 — Schema mínimo

Criar apenas as estruturas necessárias para provar a vertical do catálogo:

```text
categories
products
sync_collections
```

`sync_collections` existe apenas como metadado preparado para o futuro. Esta Spec não avança cursor nem implementa sincronização.

### P1 — Vertical persistente do catálogo

Fluxo alvo:

```text
CatalogPage
  -> CatalogController
    -> LoadCatalogUseCase
      -> CatalogRepository
        -> CatalogDao
          -> Drift / SQLite
```

Fixture não deve ser fonte lida diretamente pela UI. Quando usada, deve alimentar o banco por um seed explícito e idempotente.

### P1 — Testes e fechamento

- persistência após fechar/reabrir banco;
- isolamento entre dois contextos diferentes;
- `price = null` preservado;
- produto sem estoque continua visível;
- filtros atuais continuam funcionando;
- testes arquiteturais continuam passando;
- `dart format`, `flutter analyze` e `flutter test` executados.

## Decisões a congelar no contrato

### D-001 — Isolamento local

Proposta: cada par usuário/tenant possui banco físico operacional próprio.

O aplicativo não deve abrir um banco operacional anônimo compartilhado entre contextos reais. Durante a fase sem autenticação, o contexto fixture existente pode ser usado somente como bootstrap controlado de desenvolvimento/teste.

### D-002 — Drift como banco operacional

O SQLite via Drift é fonte operacional local. Não é cache descartável.

Falha de migração não autoriza apagar o arquivo e começar do zero.

### D-003 — Schema inicial enxuto

Não criar agora tabelas de dashboard, outbox, vendas, imagens ou autenticação.

A primeira versão do schema deve provar catálogo persistente e estratégia de migração antes de ampliar o banco.

### D-004 — Domínio não armazena rótulo de data

`CatalogProduct.updatedAtLabel` deve ser substituído por um valor temporal semântico (`DateTime updatedAt`) na camada de domínio. A formatação visual da data pertence à apresentação/formatter.

### D-005 — Fixture vira seed, não repositório operacional

`FixtureCatalogRepository` deixa de ser a implementação padrão da feature quando a fundação Drift estiver pronta.

Fixtures continuam permitidas em testes e no bootstrap de desenvolvimento, desde que sejam inseridas através da camada local e não consumidas diretamente pela tela.

## Modelo de dados inicial

### `categories`

- `id`: text, PK;
- `name`: text.

### `products`

- `id`: text, PK;
- `name`: text;
- `sku`: text;
- `brand`: text;
- `price`: real nullable;
- `stock_quantity`: integer;
- `stock_status`: text;
- `is_available_for_sale`: boolean;
- `image_url`: text nullable;
- `category_id`: text nullable, FK para `categories.id`, `ON DELETE SET NULL`;
- `updated_at`: datetime.

### `sync_collections`

- `collection`: text, PK;
- `mode`: text;
- `cursor`: text nullable;
- `last_success_at`: datetime nullable;
- `is_bootstrapped`: boolean;
- `total_received`: integer;
- `last_error`: text nullable.

Nesta Spec, a tabela pode ser criada e testada, mas nenhum serviço deve fingir que existe sync remoto funcional.

## Requisitos EARS

- Quando o app possuir um contexto operacional válido, o `DatabaseFactory` deve abrir somente o banco correspondente àquele usuário/tenant.
- Quando o contexto mudar, a conexão anterior deve ser encerrada antes de a nova conexão ser exposta.
- Quando o catálogo for carregado, a apresentação deve obter os produtos por `CatalogRepository`, sem importar Drift ou DAO.
- Quando houver dados persistidos e a rede estiver indisponível, a leitura local deve continuar possível sem depender de uma requisição HTTP.
- Quando `price` for nulo, o produto deve continuar válido e renderizável.
- Quando `stock_quantity` for zero, o produto deve continuar podendo existir no catálogo.
- Quando uma fixture de desenvolvimento for necessária, ela deve ser persistida por um seeder idempotente antes de ser consumida pelo repositório local.
- Quando o banco for reaberto, os registros persistidos anteriormente devem permanecer disponíveis.
- Se uma migração futura falhar, o aplicativo não deve implementar fallback destrutivo que apague dados silenciosamente.
- Enquanto autenticação e sync remoto estiverem bloqueados por contrato, nenhuma camada deve inventar endpoint, token ou confirmação de sincronização.

## Estados de interface preservados

A Spec não redesenha o catálogo. Devem continuar suportados os estados aplicáveis já existentes:

- `loading`;
- `ready`;
- `empty`;
- `restricted`;
- `offline`;
- `failure`;
- filtro inválido;
- rate limit, quando houver origem remota futura.

A persistência local não deve transformar ausência de rede em tela vazia se houver dados locais válidos.

## Riscos principais

1. **Mistura entre tenants** — mitigada por isolamento físico e testes com dois contextos.
2. **Fixture continuar virando produção acidentalmente** — mitigada por seed explícito e provider substituível.
3. **Schema crescer antes da hora** — mitigado pelo escopo mínimo desta Spec.
4. **Acoplamento do domínio ao Drift** — mitigado por DAO + mapper + repository.
5. **Migração destrutiva** — proibida pelo contrato e coberta por testes.
6. **Duplicar trabalho da Spec 007** — mitigado pela auditoria inicial obrigatória.
7. **Tratar sync planejado como entregue** — `sync_collections` nesta etapa é somente infraestrutura de persistência.

## Gates

1. Spec revisada e decisões D-001 a D-005 aprovadas.
2. `contract.md` marcado como `FROZEN`.
3. Implementação limitada aos paths autorizados.
4. Testes de persistência e isolamento aprovados.
5. Regressão do catálogo aprovada.
6. `flutter analyze` e `flutter test` sem falhas introduzidas pela entrega.
7. `review.md` e `validation-result.md` preenchidos.

## Critério de conclusão

A Spec só pode ser marcada `done` quando o aplicativo possuir uma fundação Drift funcional e testada, o catálogo utilizar persistência local como fonte operacional, fixtures não forem mais lidas diretamente pela implementação padrão da feature, os dados sobreviverem ao reinício e dois contextos distintos não compartilharem banco operacional.

A conclusão desta Spec não significa que sincronização remota, autenticação ou venda offline estejam prontas.
