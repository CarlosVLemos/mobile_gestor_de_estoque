# Para Mobile

Esta pasta é a base de conhecimento do aplicativo Flutter.

## Comece aqui

Leia primeiro:

- `00-contexto-operacional.md`

Ele resume o estado atual e informa quais documentos adicionais são necessários
para cada tarefa.

## Documentos canônicos

- `01-visao-geral-mobile.md`: objetivo, escopo e evolução do produto.
- `02-definicoes-de-interface.md`: regras de interface e estados visuais.
- `03-endpoints-mobile.md`: contratos remotos existentes e planejados.
- `04-regras-e-necessidades-mobile.md`: regras de negócio e segurança.
- `05-arquitetura-mobile.md`: arquitetura Flutter e persistência local.
- `06-registro-decisoes.md`: decisões aceitas, dependentes e substituídas.
- `07-uso-de-mcps.md`: política para MCPs do projeto.
- `08-processo-de-trabalho.md`: fluxo de execução, specs e validação.
- `designmobile.md`: blueprint visual detalhado, consultado sob demanda.

## Instruções para agentes

O `AGENTS.md` canônico fica na raiz do repositório para alcançar `lib/`, `test/`
e as plataformas Flutter.

O arquivo `para mobile/AGENTS.md` apenas complementa essas instruções para
manutenção da documentação.

## Status atual

- Código da 009A/B/C escrito; validação com Flutter pendente.
- Startup demonstrativo até haver sessão/banco isolado fornecido pela 008/008B.
- Catálogo com fonte paginada e leitura Drift; decoder HTTP do painel dependente.
- Login por token e outbox/vendas remotas ainda não implementados.
- [Estado consolidado e próxima sessão](../docs/estado-atual.md).

## Fonte principal

Este material foi consolidado a partir de:

- `routes/api.php`
- `app/Http/Controllers/Api/Mobile/*`
- `app/Http/Resources/Api/Mobile/*`
- `app/Http/Requests/Api/Mobile/*`
- `tests/Feature/Api/Mobile/MobileApiPreparationTest.php`
- `SDD/spec/spec 22/spec-22-api-mobile-sanctum-sync-offline.md`
- `para mobile/designmobile.md`
