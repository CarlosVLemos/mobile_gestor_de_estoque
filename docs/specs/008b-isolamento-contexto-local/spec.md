# Spec 008B: Isolamento de Contexto Local por Usuário/Tenant

## Problema
Como um aplicativo local-first persistente, múltiplos usuários ou organizações (tenants) podem operar no mesmo dispositivo físico em momentos diferentes. Sem um isolamento rígido, dados locais de negócio (como catálogo de produtos, preços restritos ou transações) do Tenant A poderiam ser visualizados por engano pelo Usuário B ao se autenticar no Tenant B, violando premissas fundamentais de conformidade e segurança.

## Objetivo
Implementar a separação lógica e física da base de dados local (Drift/SQLite) por usuário e tenant ativo, garantindo o fechamento seguro e o expurgo total de dados em memória e em cache do contexto anterior durante ações de logout ou alteração de sessão.

## Fora de Escopo
* Criptografia total de tabelas de banco de dados SQLite (SQLCipher) - mantido fora do escopo inicial.
* Sincronização em segundo plano de tabelas inativas (somente o usuário/tenant ativo é sincronizado).

## Regras de Negócio e Diretrizes Técnicas
1. **Banco de Dados Isolado Fisicamente:**
   * O caminho do arquivo de banco de dados SQLite gerado pelo `Drift` deve ser nomeado dinamicamente com base no identificador único do usuário e do tenant logados (ex: `app_database_u_${userId}_t_${tenantId}.db`).
   * O banco de dados só deve ser instanciado e aberto após a conclusão do boot de sessão (`POST /login` ou validação do token com o endpoint `/me`).
2. **Fechamento e Ciclo de Vida do Banco:**
   * Ao deslogar ou expirar a sessão, a conexão ativa do banco de dados SQLite atual deve ser formalmente encerrada (`database.close()`) para evitar vazamentos de memória ou bloqueio de arquivos.
3. **Expurgo Total de Dados (Purge):**
   * Implementar um serviço de expurgo (`DataPurgeService`) acionado no logout que limpa:
     * Cache de imagens no filesystem temporário/privado do dispositivo.
     * Provedores de estado em memória (limpar estados do Riverpod).
     * Preferências temporárias que contenham dados do usuário anterior.
4. **Resolução de Operações Pendentes (Outbox):**
   * Se houver itens pendentes de envio no Outbox local ao tentar deslogar, o aplicativo deve alertar o usuário de que existem vendas não sincronizadas que serão perdidas (ou mantidas de forma isolada no arquivo SQLite do usuário específico para sincronizar no próximo acesso).

## Estrutura de Arquivos Proposta
```text
lib/core/
  database/
    database_factory.dart     # Gerenciador de conexões Drift dinâmicas
    data_purge_service.dart   # Serviço de limpeza de cache e estados
```

## Critérios de Aceite
* O banco de dados não é instanciado em modo anônimo no startup; ele aguarda a inicialização do contexto de usuário/tenant.
* Ao logar com o Usuário X, o arquivo SQLite correspondente é aberto. Ao deslogar e logar com o Usuário Y, um novo arquivo SQLite diferente é criado e aberto, mantendo os dados de X intocados.
* A chamada de logout fecha a conexão ativa do banco de dados SQLite de forma limpa e limpa todos os caches em disco e estados em memória (Riverpod `ref.invalidate`).
* A suíte de testes unitários valida que chamadas consecutivas de login/logout fecham e abrem conexões com caminhos de arquivos correspondentes.
