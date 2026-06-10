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

- Ja existem endpoints JSON em `api/mobile/*`.
- Hoje os endpoints existentes cobrem perfil autenticado, dashboard e catalogo de produtos.
- O fluxo de login por token Sanctum e a sincronizacao offline de vendas continuam apenas planejados na `Spec 22`.

## Fonte principal

Este material foi consolidado a partir de:

- `routes/api.php`
- `app/Http/Controllers/Api/Mobile/*`
- `app/Http/Resources/Api/Mobile/*`
- `app/Http/Requests/Api/Mobile/*`
- `tests/Feature/Api/Mobile/MobileApiPreparationTest.php`
- `SDD/spec/spec 22/spec-22-api-mobile-sanctum-sync-offline.md`
- `para mobile/designmobile.md`
