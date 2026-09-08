# Tasks: Spec 008B - Isolamento de Contexto Local por Usuário/Tenant

- [x] **Fase 1: Gerenciamento Dinâmico de Conexões**
  - [x] Criar `lib/core/database/database_factory.dart` responsável por gerar caminhos de arquivos SQLite dinamicamente com base no `userId` e `tenantId`.
  - [x] Implementar a lógica de abertura de conexão do Drift de forma tardia (lazy), condicionada à existência de um perfil ativo.

- [x] **Fase 2: Serviço de Expurgo (Purge) e Alertas de Outbox**
  - [x] Criar `lib/core/database/data_purge_service.dart` com o método `purge()`.
  - [x] Implementar a verificação de outbox pendente e expor método de confirmação de logout com pendências.
  - [x] Implementar o fechamento ordenado do banco de dados Drift ativo (`database.close()`).
  - [x] Adicionar lógica para varrer e remover arquivos temporários de imagens baixadas no diretório de cache do app específicos do tenant.

- [x] **Fase 3: Integração com Sessão e Sequenciamento**
  - [x] Conectar o `DataPurgeService` ao fluxo de encerramento de sessão no `AuthController`.
  - [x] Garantir que o encerramento do banco e limpeza de arquivos execute em ordem estrita de passos (1. fechar conexões, 2. limpar arquivos, 3. invalidar providers Riverpod) antes de executar o redirecionamento de tela do GoRouter.
  - [x] Validar a ausência de exceções tardias em widgets na árvore Flutter em fase de descarte de rota.

- [x] **Fase 4: Testes de Segurança e Isolamento**
  - [x] Criar testes unitários simulando a alteração consecutiva de usuários no mock de sessão e verificando se os caminhos dos arquivos do SQLite no disco são independentes.
  - [x] Testar se o fechamento do banco não gera exceções de ponteiro nulo ou transações ativas pendentes.
  - [x] Testar a preservação física dos arquivos SQLite e recuperação da outbox ao re-logar com o mesmo usuário.
