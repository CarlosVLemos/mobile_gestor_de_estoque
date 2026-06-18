# Spec 009A - Revisão de Abertura

## Status

Planejada em 18 de junho de 2026. Não implementada.

## Escopo pretendido

- Adição das dependências do `drift`, `sqlite3` e `build_runner` ao projeto;
- Modelagem física da tabela de Categorias (`CategoriesTable`);
- Modelagem física da tabela de Produtos (`ProductsTable`) com chave estrangeira vinculada às categorias e suporte a preço nulo (`price = null`);
- Modelagem física da tabela de KPIs consolidados do Painel (`DashboardKpisTable`);
- Modelagem física de checkpoints de sincronização (`SyncCheckpointsTable`) com suporte a carimbos de data/hora e cursores;
- Implementação da classe base `AppDatabase` configurando a conexão local Drift com suporte a testes unitários em memória;
- Geração dos arquivos compilados de persistência (`.g.dart`) via build_runner;
- Suíte de testes unitários de banco validando operações de CRUD e integridade relacional.

## Gate de implementação

FECHADO.

Esta especificação define o schema do banco de dados relacional Drift. Nenhuma escrita em arquivos do app está autorizada.

## Fontes consultadas

- `para mobile/00-contexto-operacional.md`;
- `para mobile/05-arquitetura-mobile.md` (banco local e Drift);
- `para mobile/06-registro-decisoes.md` (decisões MOB-005, MOB-010, MOB-012, UI-006, Questão Aberta 3).

## Decisões já assumidas pelo pedido do usuário

- O Drift é o banco de dados operacional local principal;
- O schema do banco de dados relacional deve ser versionado;
- Os produtos devem tolerar preços nulos sem quebrar ou causar erros de parsing.

## Pontos curtos a refinar antes de aprovar a spec

- Garantir que a integridade relacional (foreign keys) no SQLite esteja ativa por padrão através de um callback de abertura (`onConfigure: (db) async { await db.customStatement('PRAGMA foreign_keys = ON;'); }`). Isto é importante para verificar se a Sync Engine está respeitando a ordem de inserção necessária (Categorias antes de Produtos).

## Veredito

Especificação do Drift Schema revisada e refinada. O gate permanece fechado aguardando liberação para execução.
