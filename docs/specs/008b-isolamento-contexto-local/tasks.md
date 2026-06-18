# Tasks: Spec 008B - Isolamento de Contexto Local por Usuário/Tenant

- [ ] **Fase 1: Gerenciamento Dinâmico de Conexões**
  - [ ] Criar `lib/core/database/database_factory.dart` responsável por gerar caminhos de arquivos SQLite dinamicamente com base no `userId` e `tenantId`.
  - [ ] Implementar a lógica de abertura de conexão do Drift de forma tardia (lazy), condicionada à existência de um perfil ativo.

- [ ] **Fase 2: Serviço de Expurgo (Purge)**
  - [ ] Criar `lib/core/database/data_purge_service.dart` com o método `purge()`.
  - [ ] Implementar o fechamento ordenado do banco de dados Drift ativo (`database.close()`).
  - [ ] Adicionar lógica para varrer e remover arquivos temporários de imagens baixadas no diretório de cache do app.

- [ ] **Fase 3: Integração com Sessão**
  - [ ] Conectar o `DataPurgeService` ao fluxo de encerramento de sessão no `AuthController`.
  - [ ] Garantir que o encerramento do banco execute antes do redirecionamento de tela do GoRouter para evitar concorrências de leitura de widgets em fase de descarte.

- [ ] **Fase 4: Testes de Segurança e Isolamento**
  - [ ] Criar testes unitários simulando a alteração consecutiva de usuários no mock de sessão e verificando se os caminhos dos arquivos do SQLite no disco são independentes.
  - [ ] Testar se o fechamento do banco não gera exceções de ponteiro nulo ou transações ativas pendentes.
