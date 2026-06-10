# Arquitetura Mobile

## 1. Objetivo

Este documento define as regras e especificações da arquitetura do aplicativo
mobile do Arara-Gastos.

O escopo é exclusivamente o cliente Flutter. Contratos, tecnologias, rotas,
middlewares e decisões internas do backend não fazem parte desta especificação.

A arquitetura deve permitir:

- operação rápida em Android e iOS;
- leitura local dos dados necessários à interface;
- funcionamento consistente com conexão instável;
- sincronização incremental e retomável;
- registro seguro de operações feitas offline;
- evolução por funcionalidades sem concentrar o projeto em arquivos gigantes;
- testes isolados de domínio, persistência, sincronização e interface.

## 2. Princípios arquiteturais

### 2.1 Local-first

A interface deve ler prioritariamente do banco local. A comunicação remota
atualiza esse banco e reconcilia operações pendentes.

Consequências:

- a UI não deve depender diretamente de uma requisição para renderizar;
- online e offline usam o mesmo fluxo de leitura;
- perda de conectividade não deve apagar o estado visível;
- dados locais devem informar quando foram sincronizados pela última vez;
- informações ainda não confirmadas devem ter estado visual próprio.

### 2.2 Operações offline são intenções

Uma ação criada offline não deve ser tratada como operação remota confirmada.
Ela deve ser persistida localmente como intenção e entrar na fila de
sincronização.

O aplicativo deve distinguir claramente:

- rascunho local;
- pendente de sincronização;
- sincronizando;
- confirmado;
- aguardando aceite do usuário;
- rejeitado;
- falha temporária;
- falha permanente;
- cancelado localmente.

### 2.3 Fonte remota soberana

O aplicativo pode trabalhar com uma visão local, mas não deve considerar como
definitivos dados sensíveis sujeitos à validação remota, como:

- estoque final;
- disponibilidade definitiva para venda;
- preço autorizado;
- permissões;
- features disponíveis;
- confirmação de venda;
- resolução de conflitos.

### 2.4 Separação por feature e camadas

O código deve ser organizado por funcionalidade, preservando fronteiras entre
interface, casos de uso, domínio e infraestrutura.

Fluxo padrão:

```text
Page -> Controller -> UseCase -> Repository -> DAO/API
```

Não é permitido:

- uma página acessar HTTP ou banco diretamente;
- DTO remoto ser usado como estado visual;
- widget decidir regra de sincronização;
- camada de dados decidir comportamento visual;
- uma feature acessar detalhes internos de outra feature.

## 3. Stack de referência

| Área | Tecnologia | Responsabilidade |
| --- | --- | --- |
| Framework | Flutter | Aplicação Android e iOS |
| Estado e injeção | Riverpod | Dependências, estado assíncrono e testabilidade |
| Banco local | Drift + SQLite | Dados operacionais, outbox, cursores e migrações |
| HTTP | Dio | Cliente remoto, interceptors, timeout e erros |
| Credenciais | `flutter_secure_storage` | Tokens e dados sensíveis |
| Navegação | `go_router` | Rotas, redirecionamento por sessão e deep links |
| Modelos | Freezed + `json_serializable` | Imutabilidade, unions e serialização |
| Background | Workmanager | Sincronizações auxiliares periódicas |
| Rede | `connectivity_plus` + health check | Sinal de conectividade e disponibilidade real |
| Imagens | Filesystem privado | Cache de imagens fora do SQLite |

Essas escolhas são o padrão inicial. Uma substituição deve ser registrada por
decisão arquitetural e demonstrar benefício técnico concreto.

## 4. Estrutura de diretórios

```text
lib/
  main.dart
  bootstrap.dart

  app/
    arara_app.dart
    router/
    theme/
    localization/

  core/
    auth/
    background/
    config/
    database/
    errors/
    images/
    logging/
    network/
    result/
    security/
    sync/

  shared/
    formatters/
    ui_states/
    validators/
    widgets/

  features/
    auth/
    catalog/
    clients/
    dashboard/
    inventory/
    reports/
    sales/
    settings/
```

Estrutura interna de uma feature:

```text
features/sales/
  domain/
    entities/
    failures/
    repositories/
    value_objects/

  application/
    services/
    use_cases/

  data/
    dto/
    local/
    mappers/
    remote/
    repositories/

  presentation/
    controllers/
    pages/
    state/
    widgets/
```

Features que ainda não necessitem de todas as pastas podem começar menores,
desde que mantenham as fronteiras entre apresentação e acesso a dados.

## 5. Responsabilidade das camadas

| Camada | Deve fazer | Não deve fazer |
| --- | --- | --- |
| `presentation` | Telas, widgets, controllers e estados visuais | Acessar Dio ou Drift diretamente |
| `application` | Orquestrar casos de uso e fluxos da feature | Conhecer widgets ou detalhes de transporte |
| `domain` | Entidades, contratos, value objects e regras conceituais | Conhecer JSON, banco, HTTP ou Flutter |
| `data` | DTOs, DAOs, fontes remotas, mappers e repositórios concretos | Decidir navegação ou apresentação |
| `core/sync` | Bootstrap, delta, outbox, locks e checkpoints | Conter regra visual |
| `core/database` | Schema Drift, migrações e verificação | Apagar dados pendentes após falha |
| `core/images` | Download, cache, metadados e limpeza | Decidir regra de catálogo ou venda |

## 6. Estado e apresentação

### 6.1 Controllers

Controllers Riverpod devem:

- receber casos de uso por injeção;
- expor estados imutáveis;
- representar carregamento, conteúdo, vazio, indisponibilidade e erro;
- evitar lógica de formatação que pertença a widgets ou formatters;
- não armazenar `BuildContext`;
- poder ser testados sem inicializar uma árvore Flutter completa.

### 6.2 Estados assíncronos

Cada feature deve modelar explicitamente os estados relevantes. Um booleano
`isLoading` isolado não é suficiente para fluxos com cache e sincronização.

Estados comuns:

- `initial`;
- `loading`;
- `ready`;
- `refreshing`;
- `empty`;
- `offline`;
- `restricted`;
- `failure`.

Um estado pode exibir dados locais e, ao mesmo tempo, informar que uma
atualização está em andamento ou falhou.

### 6.3 Erros

Erros técnicos devem ser convertidos em falhas de domínio ou aplicação antes
de chegar à interface.

Categorias mínimas:

- autenticação;
- autorização;
- validação;
- conectividade;
- limite de requisições;
- indisponibilidade remota;
- persistência local;
- conflito de sincronização;
- erro desconhecido.

A UI deve receber mensagens acionáveis e não códigos internos, stack traces ou
exceções do Dio/SQLite.

## 7. Banco local

### 7.1 Papel do Drift

O Drift é o armazenamento operacional do aplicativo, não apenas um cache
descartável. Ele pode conter operações que ainda não existem remotamente.

Regras:

- nunca recriar o banco automaticamente diante de erro de migração;
- nunca apagar outbox ou vendas pendentes como estratégia de recuperação;
- aplicar páginas de sincronização em transações;
- usar inserção e atualização em lote;
- versionar o schema;
- testar migrações antes de cada release que altere tabelas.

### 7.2 Metadados de sincronização

Cada coleção sincronizável deve possuir checkpoint independente.

Tabela conceitual:

```text
sync_collections
- collection
- mode: bootstrap | delta
- cursor
- last_success_at
- is_bootstrapped
- total_received
- last_error
```

O cursor só pode avançar depois que a página correspondente for persistida com
sucesso.

## 8. Motor de sincronização

### 8.1 Componentes

```text
Flutter UI
  -> Drift
  -> SyncEngine
       - Bootstrap Sync
       - Delta Sync
       - Push Outbox
       - Tombstone Handler
       - Image Cache Manager
       - Eviction Worker
       - Migration Safety
       - Sync Lock
  -> RemoteDataSource
```

O `SyncEngine` trabalha com interfaces remotas. Ele não deve conhecer detalhes
de implementação do servidor.

### 8.2 Primeira sincronização

A carga inicial deve ser:

- paginada;
- processada em blocos;
- persistida em batch;
- retomável por cursor ou checkpoint;
- observável pela interface;
- cancelável sem corromper o banco;
- tolerante ao fechamento inesperado do aplicativo.

A UI deve poder mostrar progresso compreensível, por exemplo:

```text
Preparando catálogo
3.500 produtos sincronizados
```

### 8.3 Sincronização incremental

Regras:

- usar cursor estável fornecido pelo contrato remoto;
- aplicar cada página em uma transação local;
- não avançar checkpoint em falha parcial;
- aceitar reprocessamento da última página sem duplicar dados;
- fazer `upsert` por identificador estável;
- registrar horário da última sincronização concluída.

O relógio do aparelho não deve ser usado como única referência para decidir o
que mudou remotamente.

### 8.4 Registros removidos

Quando a fonte remota informar a remoção de um registro, o app deve tratá-lo
como tombstone.

Comportamento local:

- marcar como removido ou inativo;
- retirar das listas operacionais;
- impedir uso em novas operações;
- preservar referências históricas;
- manter arquivos associados até a política de limpeza permitir remoção.

### 8.5 Gatilhos

A sincronização pode ser solicitada por:

- abertura do aplicativo;
- gesto manual de atualização;
- retorno confirmado da conectividade;
- criação de operação local relevante;
- tarefa periódica em background.

O foreground é o mecanismo principal. Background é auxiliar e não pode ser a
única forma de garantir envio.

## 9. Outbox

Toda ação offline relevante deve ser persistida antes de ser considerada
registrada pela interface.

Tabela conceitual:

```text
sync_outbox
- id
- client_request_id
- operation_type
- payload_json
- status
- attempts
- next_attempt_at
- last_error
- created_at
- updated_at
```

Estados mínimos:

```text
pending
syncing
confirmed
requires_acceptance
failed_retryable
failed_permanent
cancelled
```

Regras:

- `client_request_id` deve ser gerado uma única vez e persistido;
- reenvios devem reutilizar o mesmo identificador;
- marcar como `syncing` não pode remover o payload;
- falha temporária usa retry com backoff;
- falha permanente exige ação ou ciência do usuário;
- resposta que exija aceite não pode ser confirmada automaticamente;
- itens confirmados só saem da fila após persistência local da confirmação;
- payloads devem ter versão para suportar evolução futura.

## 10. Concorrência

Somente uma execução global do `SyncEngine` pode alterar checkpoints e drenar a
outbox por vez.

Deve existir:

- mutex em memória para concorrência no mesmo isolate;
- lock persistido para execuções em contextos diferentes;
- TTL para recuperar locks abandonados;
- identificador do executor;
- liberação em bloco `finally`.

Tabela conceitual:

```text
sync_locks
- name
- owner_id
- acquired_at
- expires_at
```

Um novo gatilho ocorrido durante uma sincronização pode ser ignorado ou
registrado para uma nova execução, mas nunca iniciar processamento concorrente.

## 11. Imagens offline

Imagens não devem ser armazenadas como BLOB no Drift.

Estratégia:

- arquivos no diretório privado do aplicativo;
- metadados no banco local;
- thumbnail separada da imagem completa;
- download sob demanda;
- placeholder obrigatório;
- prioridade para imagens visíveis ou ligadas a operações pendentes;
- limite configurável de armazenamento.

Tabela conceitual:

```text
local_product_images
- product_id
- variant: thumbnail | full
- remote_url
- local_path
- content_hash
- size_bytes
- last_accessed_at
- downloaded_at
- deleted_at
```

Política inicial de retenção:

- manter thumbnails de produtos ativos recentemente;
- manter imagens usadas por operações pendentes;
- manter arquivos acessados nos últimos 30 dias;
- remover imagens completas antigas antes de thumbnails;
- remover arquivos órfãos;
- invalidar arquivo quando o hash remoto mudar;
- adiar a remoção de imagens ligadas a histórico ainda visível.

## 12. Background e conectividade

### 12.1 Background

Workmanager deve ser usado como apoio para:

- tentar drenar a outbox;
- executar delta sync leve;
- baixar thumbnails prioritárias;
- limpar imagens e arquivos órfãos.

O app deve assumir que Android ou iOS pode atrasar, interromper ou não executar
uma tarefa periódica.

### 12.2 Conectividade

`connectivity_plus` informa a presença de uma rede, não a disponibilidade real
do serviço remoto.

Antes de iniciar uma operação remota relevante, o app deve:

- observar conectividade;
- executar verificação leve de disponibilidade quando necessário;
- aplicar timeout;
- converter falha em estado offline ou indisponível;
- evitar loops agressivos de retry.

## 13. Autenticação e segurança local

Regras:

- credenciais e tokens ficam apenas no armazenamento seguro;
- dados sensíveis não devem aparecer em logs;
- logout deve limpar credenciais e interromper sincronizações autenticadas;
- troca de usuário ou contexto deve impedir mistura de bancos/dados;
- permissões locais são apenas orientação de UX;
- módulos e ações devem reagir às permissões e features recebidas;
- identificador do dispositivo deve ser estável por instalação;
- payloads da outbox devem conter somente o necessário;
- screenshots, clipboard e logs sensíveis devem ser avaliados por tela.

Ao expirar a sessão:

- dados pendentes não devem ser apagados automaticamente;
- novas operações autenticadas devem ser bloqueadas;
- a UI deve solicitar nova autenticação;
- após autenticar, o app deve validar se o contexto é compatível antes de
  retomar a outbox.

## 14. Navegação

O `go_router` deve separar:

- fluxo de inicialização;
- fluxo não autenticado;
- shell autenticado;
- telas modais e detalhes;
- estados de sessão expirada ou acesso bloqueado.

Navegação principal prevista:

- Painel;
- Produtos;
- Pedidos/Vendas, quando disponível;
- Estoque;
- Mais.

Itens devem ser exibidos conforme features e permissões. Ocultar uma opção é
uma decisão de UX, não uma autorização definitiva.

## 15. Observabilidade

Logs devem ser estruturados e classificados por módulo.

Registrar:

- início e fim de sincronização;
- coleção e checkpoint, sem dados sensíveis;
- duração e quantidade processada;
- tentativa e resultado de item da outbox;
- falhas de migração;
- aquisição e expiração de lock;
- uso e limpeza do cache de imagens.

Não registrar:

- token;
- senha;
- payload completo de venda;
- dados pessoais desnecessários;
- conteúdo integral do banco.

## 16. Testes obrigatórios

### 16.1 Unidade

- entidades e value objects;
- casos de uso;
- mappers;
- classificação de falhas;
- transições de estado da outbox;
- política de retry;
- política de evicção.

### 16.2 Banco e migrações

Para cada mudança de schema:

1. Criar banco na versão anterior.
2. Inserir dados sincronizados.
3. Inserir operação pendente e item na outbox.
4. Abrir com a nova versão.
5. Executar a migração.
6. Verificar preservação dos dados pendentes.
7. Verificar que a sincronização ainda consegue processá-los.

Nenhuma atualização de schema deve ser publicada sem teste preservando a
outbox pendente.

### 16.3 Integração

- bootstrap interrompido e retomado;
- falha antes e depois de persistir uma página;
- reprocessamento idempotente;
- delta sync;
- tombstones;
- lock expirado;
- conectividade oscilante;
- sessão expirada com operação pendente;
- resposta que exige aceite do usuário.

### 16.4 Widgets

- estados carregando, vazio, offline, restrito e erro;
- preço ausente sem apresentar falha;
- badges de sincronização;
- catálogo com dados locais durante refresh;
- navegação condicionada por feature e permissão.

## 17. Regras de entrega

Uma feature mobile só deve ser considerada pronta quando:

- respeitar as camadas definidas;
- funcionar com dados locais;
- apresentar estados de carregamento, vazio, erro e offline;
- possuir tratamento explícito de permissões;
- possuir testes proporcionais ao risco;
- não registrar dados sensíveis;
- preservar operações pendentes em falhas;
- documentar qualquer nova tabela ou estado de sincronização.

## 18. Decisão consolidada

O Arara Mobile será um cliente Flutter local-first. Drift será o banco
operacional local, Riverpod controlará estado e dependências, Dio concentrará a
comunicação remota e a outbox preservará ações feitas sem confirmação imediata.

A interface sempre partirá do estado local. O `SyncEngine` reconciliará esse
estado por cargas paginadas e incrementais, com checkpoints, locks,
tombstones, retries controlados e execução auxiliar em background.

O banco local deverá ser tratado como dado importante: migrações não poderão
descartar operações pendentes, imagens serão armazenadas fora do SQLite e
qualquer conflito que exija decisão humana será apresentado explicitamente ao
usuário.

> O mobile mantém uma visão operacional local, registra intenções com segurança
> e se reconcilia com a fonte remota sem assumir decisões que não pertencem ao
> aplicativo.
