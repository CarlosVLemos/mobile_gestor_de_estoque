# Spec 009A — Revisão da implementação parcial

## Status em 8 de setembro de 2026

Execução autorizada pelo pedido atual do usuário, substituindo o gate de abertura
anterior. Implementação parcial, sem validação executável e sem aceite final.

## Entregue em código

- Dependências Drift, SQLite e geração declaradas no `pubspec.yaml`.
- Categorias, produtos e checkpoints com chaves estáveis em texto.
- KPIs e alertas relacionais, detalhes do painel em snapshot JSON local v1,
  derivados das entidades locais existentes; não definem campos HTTP.
- Tabela `sync_locks` acrescentada pela 009B ao schema inicial não publicado.
- Preço anulável e categoria opcional com `ON DELETE SET NULL`.
- `AppDatabase` versão 1 com executor injetado e foreign keys habilitadas em
  `beforeOpen`. Migração não implementada falha sem recriar o banco.
- Testes de CRUD/upsert, preço nulo, integridade referencial, rollback de página
  com preservação do checkpoint e persistência após reabertura de arquivo.

## Pendências

- Dart e Flutter ausentes: dependências não resolvidas, `pubspec.lock` não
  atualizado, geração `.g.dart`, formatação, análise e testes não executados.
- Gerar `app_database.g.dart` antes de analisar ou compilar o projeto. Não foi
  escrito código gerado manualmente. Arquivo gerado não incluído nesta entrega.
- O schema local do painel está escrito. Seu decoder remoto ainda depende
  dos campos internos do contrato e da validação descrita na 009C.
- O provider de banco está preparado para injeção. A abertura de arquivo em
  produção aguarda isolamento de contexto da 008B.
- Spec 009B em implementação parcial, com engine, lease e checkpoints Drift.
  Spec 009C em implementação parcial; veja sua revisão. O startup permanece
  demonstrativo enquanto não houver contexto autenticado injetado.
- A 009C respeita o contrato canônico: `per_page` de 1 a 50, em lugar de
  `limit: 100`. Cursor remoto continua dependente de contrato confirmado.

## Referência técnica

Configuração consultada na [documentação oficial do Drift](https://drift.simonbinder.eu/setup/).
As versões declaradas ainda precisam ser resolvidas e verificadas com o SDK do projeto.
