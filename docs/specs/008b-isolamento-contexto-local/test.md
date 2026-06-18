# Spec 008B - Referência de Validação Futura

## Objetivo

Registrar como a futura implementação da Spec 008B (Isolamento de Contexto Local por Usuário/Tenant) deverá ser validada.

## O que verificar depois

A futura implementação deverá comprovar que:
- O banco de dados Drift/SQLite não é instanciado em modo anônimo no início do app;
- Fazer login com Usuário A abre um arquivo SQLite com nome contendo seu ID e Tenant;
- Fazer logout do Usuário A e login com Usuário B cria/abre um arquivo SQLite diferente e isolado;
- Os dados do Usuário A permanecem salvos no disco sem alterações ou exclusões;
- O logout força a execução da sequência de purificação na ordem correta (fechar conexão, limpar caches de disco, invalidar provedores Riverpod).

## Cenários de Teste a Cobrir

### 1. Isolamento Físico de Bancos de Dados
* **Verificar:**
  - Fazer login com `User X` (Tenant `T1`).
  - Adicionar um registro local fictício (ex: uma categoria).
  - Deslogar e fazer login com `User Y` (Tenant `T2`).
  - Listar as categorias locais e verificar que a lista está vazia (os dados de X não vazam para Y).
  - Verificar no filesystem privado do aplicativo que existem dois arquivos `.db` diferentes.

### 2. Preservação de Dados da Outbox no Logout
* **Verificar:**
  - Fazer login com `User X`.
  - Criar uma venda offline (ficando pendente no outbox local).
  - Deslogar do aplicativo (confirmando o aviso de pendências).
  - Fazer login novamente com `User X`.
  - Validar que o banco recupera a conexão com o mesmo arquivo SQLite e a venda pendente continua salva na outbox, pronta para envio.

### 3. Sequenciamento de Purge e Invalidação Reativa
* **Verificar:**
  - Adicionar logs no `DataPurgeService` mostrando os carimbos de data/hora de cada etapa.
  - Efetuar o logout.
  - Confirmar nos logs que:
    1. A chamada `database.close()` completou.
    2. O cache de imagens no disco foi varrido.
    3. Os estados do Riverpod foram invalidados.
    4. O GoRouter executou a navegação para `/login`.

## Checklist de Validação

- [ ] Lógica lazy no `DatabaseFactory` implementada.
- [ ] Nome do arquivo de banco contendo `${userId}` e `${tenantId}` dinâmicos.
- [ ] Classe `DataPurgeService` implementando a sequência de passos.
- [ ] O `AuthController` intercepta e executa o purge no encerramento de sessão.
- [ ] Testes unitários validando a unicidade dos caminhos físicos passando com sucesso.
- [ ] Testes comprovando a não-perda física de vendas pendentes ao deslogar.
