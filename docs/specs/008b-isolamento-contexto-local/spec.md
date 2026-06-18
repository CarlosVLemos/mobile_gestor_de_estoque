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
2. **Preservação Física da Outbox no Logout:**
   * Caso existam operações pendentes na fila de Outbox local ao tentar deslogar, o aplicativo deve alertar o usuário de que existem vendas não sincronizadas.
   * No entanto, por estarem em banco de dados isolado fisicamente por usuário/tenant, os dados de venda pendentes **NÃO são excluídos ou perdidos**. Eles permanecem seguros dentro do arquivo físico correspondente (`app_database_u_${userId}_t_${tenantId}.db`).
   * Quando o mesmo usuário efetuar login novamente no mesmo dispositivo, o app se reconectará ao mesmo arquivo SQLite e retomará o processamento da Outbox pendente.
3. **Sequência Estrita de Fechamento e Expurgo (Purge):**
   * Durante o logout ou expiração de sessão, o aplicativo deve executar os passos na seguinte ordem cronológica estrita para evitar concorrência de widgets tentando acessar recursos sendo finalizados:
     1. **Fechar Conexões:** Interromper sincronizações ativas da Sync Engine e chamar `database.close()` de forma assíncrona, garantindo que o SQLite libere o arquivo físico.
     2. **Expurgar Caches de Disco:** Excluir arquivos de cache de imagens e dados temporários no filesystem privado do aplicativo referentes a este usuário/tenant.
     3. **Invalidar Provedores em Memória:** Chamar `ref.invalidate` ou resetar todos os estados em memória do Riverpod para limpar metadados de catálogo, dashboard e carrinho do usuário antigo.
     4. **Navegar:** Efetuar o redirecionamento de rotas do GoRouter para a tela de login (`/login`).
4. **Fechamento e Ciclo de Vida do Banco:**
   * Ao deslogar ou expirar a sessão, a conexão ativa do banco de dados SQLite atual deve ser formalmente encerrada (`database.close()`) para evitar vazamentos de memória ou bloqueio de arquivos.

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
* A chamada de logout executa a sequência de purificação de forma síncrona e assíncrona ordenada, fechando conexões primeiro.
* Deslogar com vendas pendentes na outbox avisa o usuário, mas não corrompe ou deleta o arquivo físico do banco.
* A suíte de testes unitários valida que chamadas consecutivas de login/logout fecham e abrem conexões com caminhos de arquivos correspondentes.

