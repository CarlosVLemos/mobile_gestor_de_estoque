# Plano de validação futuro — Spec 009A

## Cenário crítico de upgrade

1. Criar um banco físico no schema v1 da 008B.
2. Inserir uma linha pendente em `sync_outbox`.
3. Fechar o banco.
4. Abrir o mesmo arquivo com a versão nova da 009A.
5. Comprovar que a migração terminou, as novas tabelas existem e a linha antiga
   da outbox continua intacta.

## Cenários adicionais

- Banco novo cria todas as tabelas na versão nova.
- `price = null` persiste e é lido como estado válido.
- Chaves estrangeiras e a ordem categorias → produtos são testadas quando os
  tipos remotos forem congelados.
- Contextos user + tenant diferentes continuam usando arquivos independentes.

## Proibições de validação

Nenhum teste de migração pode usar apagar banco, reset de schema ou recriação
do arquivo como mecanismo de sucesso.
